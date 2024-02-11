/** @file
    nw_s0_cureinflict

    Handles all the cure/inflict spells

    By: Flaming_Sword
    Created: Jun 13, 2006
    Modified: Jun 30, 2006

    Consolidation of multiple scripts
    modified healing vfx for inflict spells
    changed cure minor wounds to heal 1 hp
        in line with SRD
    added will save 1/2 damage for cure spells
    added mass cure spells
    added mass heal-like random delay for mass
        cure spells (to look cool, delay can be
        set to zero if desired)
*/

#include "prc_sp_func"
#include "prc_inc_function"
#include "prc_inc_sp_tch"
#include "prc_add_spell_dc"

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nSpellID, int bIsCure)
{
    int nMetaMagic  = PRCGetMetaMagicFeat();
    int bMass       = IsMassCure(nSpellID) || IsMassInflict(nSpellID);
    int nHealVFX;
    int nEnergyType = bIsCure ? DAMAGE_TYPE_POSITIVE : DAMAGE_TYPE_NEGATIVE;
    int nSpellLevel = StringToInt(lookup_spell_cleric_level(PRCGetSpellId()));
    int nDice       = bMass ? nSpellLevel - 4 : nSpellLevel; // The spells use a number of dice equivalent to spell level, mass versions 4 fewer
    int bHeal;

    switch(nDice)       //nDice == 0 for cure/inflict minor wounds
    {
        case 0:          nHealVFX = VFX_IMP_HEAD_HEAL; break;
        case 1:          nHealVFX = VFX_IMP_HEALING_S; break;
        case 2:          nHealVFX = VFX_IMP_HEALING_M; break;
        case 3:          nHealVFX = VFX_IMP_HEALING_L; break;
        case 4: default: nHealVFX = VFX_IMP_HEALING_G; break;
    }

    // Extra points based on spell level, capped to caster level
    int nExtraDamage = min(nSpellLevel * 5, nCasterLevel);

    // Healing is more effective for players on low or normal difficulty
    int nDifficultyCondition = (GetIsPC(oTarget) && (GetGameDifficulty() < GAME_DIFFICULTY_CORE_RULES)) && bIsCure;

    // Mass spell AoE targeting
    location lLoc;
    if(bMass)
    {
        lLoc    = PRCGetSpellTargetLocation();
        oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLoc, TRUE);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(bIsCure ? VFX_FNF_LOS_HOLY_20 : VFX_FNF_LOS_EVIL_20), lLoc);
    }

    // Targeting loop
    float fDelay    = 0.0;
    int nHealed     = 0;
    int nMaxHealed  = bMass ? nCasterLevel : 1;
    int iAttackRoll = 1;
    while(GetIsObjectValid(oTarget))
    {
        // Skip non-creatures. AoE targeting shouldn't get them anyway, but single target spells shouldn't affect non-creatures either
        // Also skip constructs, since they are neither living nor undead. Technically, they would qualify for being healed by mass cures, but we assume that's just bad editing.
        //Improved Fortification overrides Warforged's ability to be healed.
        if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT && !GetIsWarforged(oTarget) || GetHasFeat(FEAT_IMPROVED_FORTIFICATION, oTarget))
        {
            oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLoc, TRUE);
            continue;
        }

        //random delay like mass heal so it looks cool :P (can be set to zero if behavior is not desired)
        if(bMass) fDelay = PRCGetRandomDelay();

        // Roll damage / heal points
        int iBlastFaith = BlastInfidelOrFaithHeal(oCaster, oTarget, nEnergyType, TRUE);
        int iTombTainted = GetHasFeat(FEAT_TOMB_TAINTED_SOUL, oTarget) && GetAlignmentGoodEvil(oTarget) != ALIGNMENT_GOOD;
        int nHeal = 0;
        if((nMetaMagic & METAMAGIC_MAXIMIZE) || iBlastFaith || nDifficultyCondition)
        {
            nHeal = nDice * 8 + nExtraDamage;
            if(nDifficultyCondition && ((nMetaMagic & METAMAGIC_MAXIMIZE) || iBlastFaith))
                nHeal += nExtraDamage;      //extra damage on lower difficulties
        }
        else
            nHeal = d8(nDice) + nExtraDamage;
        // More feat effects
        if((nMetaMagic & METAMAGIC_EMPOWER))
            nHeal += (nHeal / 2);
        if(GetHasFeat(FEAT_AUGMENT_HEALING, oCaster) && bIsCure)
            nHeal += (nSpellLevel * 2);
        // Cure Minor only does 1 - Fox
        if(nDice == 0)
            nHeal = 1;
        //Healing Hands bonus even applies to Cure Minor - Fox
        if(PRCGetLastSpellCastClass() == CLASS_TYPE_HEALER)
            nHeal += GetAbilityModifier(ABILITY_CHARISMA, oCaster);

        // Whether we are supposed to heal or hurt the target
        bHeal = (!bIsCure && (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD || iTombTainted)) || // Undead handling, non-cures heal them
                (bIsCure  && MyPRCGetRacialType(oTarget) != RACIAL_TYPE_UNDEAD && !iTombTainted);    // Undead handling, cures hurt them
                
        if (GetLocalInt(oTarget, "AcererakHealing")) bHeal = TRUE;

        // Healing, assume the caster never wants to heal hostiles and any targeting of such was a misclick
        if(bHeal && !spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster))
        {
            //Warforged are only healed for half, none if they have Improved Fortification
            if(GetIsWarforged(oTarget)) nHeal /= 2;
            if(GetHasFeat(FEAT_IMPROVED_FORTIFICATION, oTarget)) nHeal = 0;

            // Apply healing to the target
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectHeal(nHeal, oTarget),            oTarget));
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nHealVFX), oTarget));

            // Let the AI know
            SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellID, FALSE));

            // Increment the # of affected targets counter
            nHealed++;
        }
        // Harming, assume the caster never wants to hurt non-hostiles and any targeting of such was a misclick
        else if(!bHeal && spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster))
        {
        	nHeal += SpellDamagePerDice(OBJECT_SELF, nDice);
            // Roll touch attack if non-mass spell
            iAttackRoll = bMass ? TRUE : PRCDoMeleeTouchAttack(oTarget);
            if(iAttackRoll > 0)
            {
                // Let the AI know about hostile spell use
                SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellID));

                // Roll SR
                if(!PRCDoResistSpell(oCaster, oTarget, nCasterLevel + SPGetPenetr()))
                {
                    // Save for half
                    if(PRCMySavingThrow(SAVING_THROW_WILL, oTarget,
                                        PRCGetSaveDC(oTarget, oCaster, nSpellID),
                                        bIsCure ? SAVING_THROW_TYPE_POSITIVE : SAVING_THROW_TYPE_NEGATIVE
                                        )
                       )
                    {
                        nHeal /= 2;
                        // Mettle for total avoidance instead
                        if(GetHasMettle(oTarget, SAVING_THROW_WILL))
                            nHeal = 0;
                    }

                    // Apply effects
                    effect eDam = PRCEffectDamage(oTarget, nHeal, nEnergyType);
                    DelayCommand(fDelay + 1.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    DelayCommand(fDelay,       SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(bIsCure ? VFX_IMP_SUNSTRIKE : VFX_IMP_HARM), oTarget));
                }
            }

            // Increment the # of affected targets counter
            nHealed++;
        }

        // Terminate loop if target limit reached
        if(nHealed >= nMaxHealed)
            break;

        // Otherwise get next target
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLoc, TRUE);
    }

    return bMass ? TRUE : iAttackRoll;    //return TRUE if spell charges should be decremented
}

void main()
{
    if (!X2PreSpellCastCode()) return;
    int nSpellID = PRCGetSpellId();
    int bIsCure = IsMassCure(nSpellID) || IsCure(nSpellID);  //whether it is a cure or inflict spell
    int nSchool = bIsCure ? SPELL_SCHOOL_CONJURATION : SPELL_SCHOOL_NECROMANCY;
    PRCSetSchool(nSchool);
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    // Check for holding charge
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {   //can't hold the charge with mass cure/inflict spells
        if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget && IsTouchSpell(nSpellID))
        {   //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges
            return;
        }
        DoSpell(oCaster, oTarget, nCasterLevel, nSpellID, bIsCure);
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            if(DoSpell(oCaster, oTarget, nCasterLevel, nSpellID, bIsCure))
                DecrementSpellCharges(oCaster);
        }
    }
    PRCSetSchool();
}