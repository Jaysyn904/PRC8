/** @file
    sp_repairinflict.nss

    Repair / Inflict Damage (construct) handler.
    Mirrors nw_s0_cureinflict structure and mass behaviour.
*/

#include "prc_sp_func"
#include "prc_inc_function"
#include "prc_inc_sp_tch"
#include "prc_add_spell_dc"

int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nSpellID, int bIsRepair)
{
    int nMetaMagic  = PRCGetMetaMagicFeat();
    int bMass       = IsMassRepair(nSpellID) || IsMassInflictDamage(nSpellID);
    int nHealVFX;
    int nEnergyType = DAMAGE_TYPE_MAGICAL;
    int nSpellLevel = StringToInt(lookup_spell_level(PRCGetSpellId()));
    int nDice       = bMass ? nSpellLevel - 4 : nSpellLevel;
    int bHeal;
    int nAmount;

    switch(nDice)       //nDice == 0 for minor => small vfx
    {
        case 0:          nHealVFX = VFX_IMP_MAGBLUE; break;
        case 1:          nHealVFX = VFX_IMP_MAGBLUE; break;
        case 2:          nHealVFX = VFX_IMP_MAGBLUE; break;
        case 3:          nHealVFX = VFX_IMP_LIGHTNING_S; break;
        case 4: default: nHealVFX = VFX_IMP_MAGBLUE; break;
    }

/*     switch(nDice)       //nDice == 0 for minor => small vfx
    {
        case 0:          nHealVFX = VFX_IMP_HEAD_HEAL; break;
        case 1:          nHealVFX = VFX_IMP_HEALING_S; break;
        case 2:          nHealVFX = VFX_IMP_HEALING_M; break;
        case 3:          nHealVFX = VFX_IMP_HEALING_L; break;
        case 4: default: nHealVFX = VFX_IMP_HEALING_G; break;
    } */

    // Repair/Inflict construct bonus: +1 per caster level, max +5
    int nExtraDamage = PRCMin(nCasterLevel, 5);

    // Mass spell AoE targeting (same mass behaviour as cure/inflict)
    location lLoc;
    if(bMass)
    {
        lLoc    = PRCGetSpellTargetLocation();
        oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLoc, TRUE);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(bIsRepair ? VFX_FNF_LOS_HOLY_20 : VFX_FNF_LOS_EVIL_20), lLoc);
    }

    float fDelay    = 0.0;
    int nAffected   = 0;
    int nMaxAffected= bMass ? nCasterLevel : 1;
    int iAttackRoll = 1;

    while(GetIsObjectValid(oTarget))
    {
        // Skip non-creatures or creatures that are not constructs.
        if(GetObjectType(oTarget) != OBJECT_TYPE_CREATURE || MyPRCGetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT)
        {
            oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLoc, TRUE);
            continue;
        }

        if(bMass) fDelay = PRCGetRandomDelay();

        // Compute heal/damage amount
        if(nMetaMagic & METAMAGIC_MAXIMIZE)
        {
            nAmount = nDice * 8 + nExtraDamage;
        }
        else
            nAmount = d8(nDice) + nExtraDamage;

        if((nMetaMagic & METAMAGIC_EMPOWER))
            nAmount += (nAmount / 2);

        // Minor (dice == 0) => 1 point
        if(nDice == 0)
            nAmount = 1;

        // Determine heal vs harm. For this handler:
        //  - Repair spells heal constructs.
        //  - InflictDamage spells harm constructs.
        bHeal = bIsRepair;

        // Repair (healing constructs)
        if(bHeal && !spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster)) // assume only heal non-hostiles
        {
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectHeal(nAmount, oTarget), oTarget));
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nHealVFX), oTarget));
            SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellID, FALSE));
            nAffected++;
        }
        // Inflict Damage (harm constructs)
        else if(!bHeal && spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster))
        {
            // Add any per-dice flat additions similar to cure/inflict behaviour
            nAmount += SpellDamagePerDice(OBJECT_SELF, nDice);

            // Roll touch attack if not mass
            iAttackRoll = bMass ? TRUE : PRCDoMeleeTouchAttack(oTarget);
            if(iAttackRoll > 0)
            {
                SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellID));

				// Inflict-damage spells are subject to SR. Repair spells are not.
				if(!PRCDoResistSpell(oCaster, oTarget, nCasterLevel + SPGetPenetr()))
				{
					
/* 					int MySavingThrow(
					int nSavingThrow,
					object oTarget,
					int nDC,
					SAVING_THROW_TYPE_NONE,
					object oSaveVersus = OBJECT_SELF,
					float fDelay = 0.0f	); */


					// Inflict damage spells: Will save for half
					//int nSave = WillSave(oTarget, PRCGetSaveDC(oCaster, nSpellID));
					int nSave = PRCMySavingThrow(SAVING_THROW_WILL, oTarget, PRCGetSaveDC(oTarget, oCaster, nSpellID), SAVING_THROW_TYPE_SPELL, OBJECT_SELF, fDelay);

					int nFinal = nAmount;

					if(nSave == 1) // successful save
						nFinal /= 2;

					effect eDam = PRCEffectDamage(oTarget, nFinal, nEnergyType);
					DelayCommand(fDelay + 1.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
					DelayCommand(fDelay,       SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HARM), oTarget));
				}
            }

            nAffected++;
        }

        // Terminate loop if target limit reached
        if(nAffected >= nMaxAffected)
            break;

        // Next in AoE
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLoc, TRUE);
    }

    return bMass ? TRUE : iAttackRoll;    // TRUE if charges should be decremented
}

void main()
{
    if (!X2PreSpellCastCode()) return;

    int nSpellID = PRCGetSpellId();
    // Determine whether this is a repair (heal) or inflict-damage (harm) spell
    int bIsRepair = IsMassRepair(nSpellID) || IsRepair(nSpellID); // implement IsRepair/IsMassRepair in your spell table if not present
    int nSchool = SPELL_SCHOOL_TRANSMUTATION;
    PRCSetSchool(nSchool);

    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLevel = PRCGetCasterLevel(oCaster);

    // Check for holding charge
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT);
    if(!nEvent) // normal cast
    {
        // can't hold the charge with mass repair/inflict spells
        if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget && IsTouchSpell(nSpellID))
        {
            SetLocalSpellVariables(oCaster, 1);
            return;
        }
        DoSpell(oCaster, oTarget, nCasterLevel, nSpellID, bIsRepair);
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            if(DoSpell(oCaster, oTarget, nCasterLevel, nSpellID, bIsRepair))
                DecrementSpellCharges(oCaster);
        }
    }

    PRCSetSchool();
}