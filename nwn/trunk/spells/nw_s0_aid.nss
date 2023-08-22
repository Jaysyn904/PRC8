//::///////////////////////////////////////////////
//:: Name      Aid/Mass Aid
//:: FileName  nw_s0_aid.nss
/*:://////////////////////////////////////////////
Aid
Enchantment (Compulsion) [Mind-Affecting]
Level:            Clr 2, Good 2, Luck 2
Components:       V, S, DF
Casting Time:     1 standard action
Range:            Touch
Target:           Living creature touched
Duration:         1 min./level
Saving Throw:     None
Spell Resistance: Yes (harmless)

Aid grants the target a +1 morale bonus on attack
rolls and saves against fear effects, plus
temporary hit points equal to 1d8 + caster level
(to a maximum of 1d8 + 10 temporary hit points at
caster level 10th).

Mass Aid
Enchantment (Compulsion) [Mind-Affecting]
Level:            Clr 3
Range:            Close (25 ft. + 5 ft./2 levels)
Targets:          One or more creatures within a 30 ft. range.
Components:       V, S, DF
Casting Time:     1 standard action
Duration:         1 min./level
Saving Throw:     None
Spell Resistance: Yes (harmless)

Subjects gain +1 morale bonus on attack rolls and
saves against fear effects, plus temporary hit
points equal to 1d8 + caster level (to a maximum
of 1d8 + 15 at caster level 15).
//::*/////////////////////////////////////////////

#include "prc_sp_func"

void StripBuff(object oTarget, int nBuffSpellID, int nMassBuffSpellID)
{
    effect eEffect = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eEffect))
    {
        int nSpellID = GetEffectSpellId(eEffect);
        if (nBuffSpellID == nSpellID || nMassBuffSpellID == nSpellID)
            RemoveEffect(oTarget, eEffect);
        eEffect = GetNextEffect(oTarget);
    }
}

int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nSpellID)
{
    //Declare major variables
    location lTarget;
    int nMetaMagic = PRCGetMetaMagicFeat();
    int bMass = nSpellID == SPELL_MASS_AID;
    int nBonusLimit = bMass ? 15 : 10;
    float fDuration = TurnsToSeconds(nCasterLevel);
    if(nMetaMagic & METAMAGIC_EXTEND) fDuration *= 2;

    effect eVis    = EffectVisualEffect(VFX_IMP_HOLY_AID);
    effect eAttack = EffectAttackIncrease(1);
    effect eSave   = EffectSavingThrowIncrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_FEAR);
    effect eDur    = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink   = EffectLinkEffects(eAttack, eSave);
           eLink   = EffectLinkEffects(eLink, eDur);

    if(bMass)
    {
        lTarget = PRCGetSpellTargetLocation();
        oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
    while(GetIsObjectValid(oTarget))
    {
        if(((!bMass) || (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster))) && PRCGetIsAliveCreature(oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellID, FALSE));

            int nBonus = d8(1);
            if(nMetaMagic & METAMAGIC_MAXIMIZE) nBonus = 8;
            if(nMetaMagic & METAMAGIC_EMPOWER) nBonus += (nBonus / 2);
            nBonus += nBonusLimit > nCasterLevel ? nCasterLevel : nBonusLimit;

            effect eHP  = EffectTemporaryHitpoints(nBonus);

            // Remove pervious castings of it
            StripBuff(oTarget, SPELL_AID, SPELL_MASS_AID);

            //Apply the VFX impact and effects
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, nSpellID, nCasterLevel, oCaster);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, oTarget, fDuration);
        }
        if(!bMass) break;
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }

    return TRUE;    //return TRUE if spell charges should be decremented
}

void main()
{
    if (!X2PreSpellCastCode()) return;
    PRCSetSchool(SPELL_SCHOOL_ENCHANTMENT);
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nSpellID = PRCGetSpellId();
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget && IsTouchSpell(nSpellID))
        {   //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges
            return;
        }
        DoSpell(oCaster, oTarget, nCasterLevel, nSpellID);
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            if(DoSpell(oCaster, oTarget, nCasterLevel, nSpellID))
                DecrementSpellCharges(oCaster);
        }
    }
    PRCSetSchool();
}