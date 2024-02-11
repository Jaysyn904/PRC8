/*
    Witchwood Step
*/

#include "prc_sp_func"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    
    if (!PreInvocationCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
    
    object oCaster = OBJECT_SELF;
    int CasterLvl = GetInvokerLevel(OBJECT_SELF, GetInvokingClass());
    object oTarget = PRCGetSpellTargetObject();
    
    effect eWeb = EffectImmunity(IMMUNITY_TYPE_ENTANGLE);
    effect eVis = EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eWeb, eDur);

    int nDuration = CasterLvl;

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, INVOKE_WITCHWOOD_STEP, FALSE));
    
    //Apply VFX impact and immunity effect
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(24),TRUE,-1,CasterLvl);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}