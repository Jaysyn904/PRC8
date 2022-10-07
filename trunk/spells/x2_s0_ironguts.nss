/*
    x2_s0_ironguts

    When touched the target creature gains a +4
    circumstance bonus on Fortitude saves against
    all poisons.

    By: Andrew Nobbs
    Created: Nov 22, 2002
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
    nCasterLvl *= 10;
    float fDuration = TurnsToSeconds(nCasterLvl);
    int nMetaMagic = PRCGetMetaMagicFeat();
    //Check for metamagic extend
    if(nMetaMagic & METAMAGIC_EXTEND)
        fDuration *= 2;

    //Set the bonus save effect
    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE),
                   EffectSavingThrowIncrease(SAVING_THROW_FORT, 4, SAVING_THROW_TYPE_POISON));
    effect eVis  = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
    effect eVis2 = EffectVisualEffect(VFX_IMP_HEAD_ACID);

    //Stacking Spellpass, 2003-07-07, Georg
    PRCRemoveEffectsFromSpell(oTarget, SPELL_IRONGUTS);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_IRONGUTS, FALSE));

    //Apply the bonus effect and VFX impact
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
    DelayCommand(0.3f, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));

    return TRUE;    //return TRUE if spell charges should be decremented
}

void main()
{
    if (!X2PreSpellCastCode()) return;
    PRCSetSchool(SPELL_SCHOOL_ABJURATION);
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