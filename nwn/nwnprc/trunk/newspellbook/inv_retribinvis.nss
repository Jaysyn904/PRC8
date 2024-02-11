/*
    nw_s0_imprinvis

    Target creature can attack and cast spells while
    invisible

    By: Preston Watamaniuk
    Created: Jan 7, 2002
    Modified: Jun 12, 2006

    Modified for the PRC warlock by ebonfowl
    Dedicated to Edgar, the real Ebonfowl
*/

void ReapplyInvis(object oTarget, effect eInvis, float fDur, int CasterLvl);

#include "prc_sp_func"
#include "inv_inc_invfunc"
#include "inv_invokehook"
#include "inv_invoc_const"

void ReapplyInvis(object oTarget, effect eInvis, float fDur, int CasterLvl)
{
    if(!PRCGetHasEffect(EFFECT_TYPE_INVISIBILITY, oTarget) && GetHasSpellEffect(INVOKE_RETRIBUTIVE_INVISIBILITY))
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvis, oTarget, fDur,TRUE,-1,CasterLvl);
    DelayCommand(1.0, ReapplyInvis(oTarget, eInvis, fDur-1.0, CasterLvl));
}

void main()
{
    if (!PreInvocationCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
    
    object oCaster = OBJECT_SELF;
    int nCasterLvl = GetInvokerLevel(OBJECT_SELF, GetInvokingClass());
    int CasterLvl = nCasterLvl;
    int nDuration = CasterLvl;
    
    object oTarget = PRCGetSpellTargetObject();
    int bBio = GetPRCSwitch(PRC_BIOWARE_INVISIBILITY);
    float fDur = bBio ? TurnsToSeconds(nDuration) : RoundsToSeconds(nDuration);
    
    effect eImpact = EffectVisualEffect(VFX_IMP_HEAD_MIND);
    effect eVis = EffectVisualEffect(VFX_DUR_INVISIBILITY);
    effect eInvis = EffectInvisibility(bBio ? INVISIBILITY_TYPE_NORMAL : INVISIBILITY_TYPE_IMPROVED);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eCover = EffectConcealment(50);
    effect eLink = EffectLinkEffects(eDur, eCover);
    eLink = EffectLinkEffects(eLink, eVis);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, INVOKE_RETRIBUTIVE_INVISIBILITY, FALSE));
    
    //Apply the VFX impact and effects
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);

    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur,TRUE,-1,CasterLvl);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvis, oTarget, fDur,TRUE,-1,CasterLvl);
    SetLocalInt(oTarget, "DangerousInvis", nCasterLvl);
    DelayCommand(1.0, ReapplyInvis(oTarget, eInvis, fDur, CasterLvl));

}