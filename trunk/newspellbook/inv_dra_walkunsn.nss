//::///////////////////////////////////////////////
//:: Name      Walk Unseen
//:: FileName  inv_dra_walkunsn.nss
//::///////////////////////////////////////////////
/*

Lesser Invocation
2nd Level Spell

You gain the ability to fade from view. You become
invisible for 24 hours, or until you perform a
hostile action.

*/
//::///////////////////////////////////////////////

#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    if(!PreInvocationCastCode()) return;

    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLevel = GetInvokerLevel(oCaster, GetInvokingClass());

    effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eInvis, eDur);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(oCaster, INVOKE_WALK_UNSEEN, FALSE));
    //Apply the VFX impact and effects
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(24),TRUE,-1,nCasterLevel);
}