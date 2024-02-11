/*
    x0_s0_amplify

    The caster or target is able to hear sounds better.
    Listen skill increases by 20.
    DURATION: 1 round/level

    By: Brent Knowles
    Created: July 30, 2002
    Modified: Jun 29, 2006
*/

#include "prc_sp_func"

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel)
{
    int nMetaMagic = PRCGetMetaMagicFeat();
    float fDuration = RoundsToSeconds(nCasterLevel);
    if(nMetaMagic & METAMAGIC_EXTEND)
        fDuration *= 2;

    effect eLink = EffectSkillIncrease(SKILL_LISTEN, 20);
           eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));

    SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_AMPLIFY, FALSE));

    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE), oTarget);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, SPELL_AMPLIFY, nCasterLevel);

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
        DoSpell(oCaster, oTarget, nCasterLevel);
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            if(DoSpell(oCaster, oTarget, nCasterLevel))
                DecrementSpellCharges(oCaster);
        }
    }
    PRCSetSchool();
}