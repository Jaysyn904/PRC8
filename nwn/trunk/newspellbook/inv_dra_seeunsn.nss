//::///////////////////////////////////////////////
//:: Name      See the Unseen
//:: FileName  inv_dra_seeunsn.nss
//::///////////////////////////////////////////////
/*

Least Invocation
2nd Level Spell

You grant yourself great powers of vision, allowing
you to see invisible creatures and objects. You
also gain darkvision. This invocation lasts for
24 hours.

*/
//::///////////////////////////////////////////////

#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    if(!PreInvocationCastCode()) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    object oSkin = GetPCSkin(oTarget);
    int CasterLvl = GetInvokerLevel(oCaster, GetInvokingClass());
    float fDuration = HoursToSeconds(24);
    effect eVis = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eSight = EffectSeeInvisible();
    effect eLink = EffectLinkEffects(eVis, eSight);
           eLink = EffectLinkEffects(eLink, eDur);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(oCaster, INVOKE_SEE_THE_UNSEEN, FALSE));

    //Apply the VFX impact and effects
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, -1, CasterLvl);
    IPSafeAddItemProperty(oSkin, ItemPropertyDarkvision(), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
}
