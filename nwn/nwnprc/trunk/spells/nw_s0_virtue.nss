/*
    nw_s0_virtue

    Target gains 1 temporary HP

    By: Preston Watamaniuk
    Created: Sept 6, 2001
    Modified: Jun 28, 2006

    Cleaned up
*/

#include "prc_sp_func"

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    int nDuration = nCasterLevel;
    int nMetaMagic = PRCGetMetaMagicFeat();
    effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);
    effect eLink = EffectLinkEffects(EffectTemporaryHitpoints(1), EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND)) nDuration *= 2; //Duration is +100%
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_VIRTUE, FALSE));
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration),TRUE,-1,nCasterLevel);
    return TRUE;    //return TRUE if spell charges should be decremented
}

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    PRCSetSchool(GetSpellSchool(PRCGetSpellId()));
    if (!X2PreSpellCastCode()) return;
    object oTarget = PRCGetSpellTargetObject();
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