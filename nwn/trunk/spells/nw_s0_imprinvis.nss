/*
    nw_s0_imprinvis

    Target creature can attack and cast spells while
    invisible

    By: Preston Watamaniuk
    Created: Jan 7, 2002
    Modified: Jun 12, 2006
*/

void ReapplyInvis(object oTarget, effect eInvis, float fDur, int CasterLvl);

#include "prc_sp_func"

void ReapplyInvis(object oTarget, effect eInvis, float fDur, int CasterLvl)
{
    if(!PRCGetHasEffect(EFFECT_TYPE_INVISIBILITY, oTarget) && GetHasSpellEffect(SPELL_IMPROVED_INVISIBILITY))
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvis, oTarget, fDur,TRUE,-1,CasterLvl);
    DelayCommand(1.0, ReapplyInvis(oTarget, eInvis, fDur-1.0, CasterLvl));
}

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    int bBio = GetPRCSwitch(PRC_BIOWARE_INVISIBILITY);
    float fDur;
    effect eImpact = EffectVisualEffect(VFX_IMP_HEAD_MIND);
    effect eVis = EffectVisualEffect(VFX_DUR_INVISIBILITY);
    effect eInvis = EffectInvisibility(bBio ? INVISIBILITY_TYPE_NORMAL : INVISIBILITY_TYPE_IMPROVED);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eCover = EffectConcealment(50);
    effect eLink = EffectLinkEffects(eDur, eCover);
    eLink = EffectLinkEffects(eLink, eVis);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_IMPROVED_INVISIBILITY, FALSE));
    int CasterLvl = nCasterLevel;
    int nDuration = CasterLvl;
    if (GetHasFeat(FEAT_INSIDIOUSMAGIC,OBJECT_SELF) && GetHasFeat(FEAT_SHADOWWEAVE,oTarget))
       nDuration = nDuration*2;
    int nMetaMagic = PRCGetMetaMagicFeat();
    //Enter Metamagic conditions
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        nDuration = nDuration *2; //Duration is +100%
    }
    fDur = bBio ? TurnsToSeconds(nDuration) : RoundsToSeconds(nDuration);
    //Apply the VFX impact and effects
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);

    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur,TRUE,-1,CasterLvl);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvis, oTarget, fDur,TRUE,-1,CasterLvl);
    DelayCommand(1.0, ReapplyInvis(oTarget, eInvis, fDur, CasterLvl));

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