/*
    x2_s0_stnbones

    Gives the target +3 AC Bonus to Natural Armor.
    Only if target creature is undead.

    By: Andrew Nobbs
    Created: Nov 25, 2002
    Modified: Jun 30, 2006
*/

#include "prc_sp_func"

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLvl, int nEvent)
{
    int nDur = nCasterLvl * 10;
    float fDuration  = TurnsToSeconds(nDur);
    int nMetaMagic = PRCGetMetaMagicFeat();

    //Check for metamagic extend
    if(nMetaMagic & METAMAGIC_EXTEND) //Duration is +100%
        fDuration *= 2;

    //Set the one unique armor bonuses
    effect eLink = EffectLinkEffects(EffectACIncrease(3, AC_NATURAL_BONUS),
                   EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
    effect eVis  = EffectVisualEffect(VFX_IMP_AC_BONUS);

    //Stacking Spellpass, 2003-07-07, Georg
    PRCRemoveEffectsFromSpell(oTarget, SPELL_STONE_BONES);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_STONE_BONES, FALSE));

    //Apply the armor bonuses and the VFX impact
    if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD
    && !GetLocalInt(oTarget, "X2_L_IS_INCORPOREAL") && !GetHasFeat(FEAT_INCORPOREAL, oTarget))// Must be corporeal
    {
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
    else
    {
        FloatingTextStrRefOnCreature(85390, oCaster, FALSE); // only affects undead;
    }

    return TRUE;    //return TRUE if spell charges should be decremented
}

void main()
{
    if (!X2PreSpellCastCode()) return;
    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)
        {   //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges
            return;
        }
        DoSpell(oCaster, oTarget, nCasterLevel, nEvent);
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            if(DoSpell(oCaster, oTarget, nCasterLevel, nEvent))
                DecrementSpellCharges(oCaster);
        }
    }
    PRCSetSchool();
}