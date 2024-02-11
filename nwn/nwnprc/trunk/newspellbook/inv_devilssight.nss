//::///////////////////////////////////////////////
//:: Name      Devil's Sight
//:: FileName  inv_devilssight.nss
//::///////////////////////////////////////////////
/*

Least Invocation
2nd Level Spell

You gain the visual acuity of a devil. You can see
equally well in light and darkness, whether magical
or nonmagical. This invocation lasts for 24 hours.

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
    effect eVis = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eSight = EffectUltravision();
    effect eLink = EffectLinkEffects(eVis, eSight);
           eLink = EffectLinkEffects(eLink, eDur);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(oCaster, INVOKE_DEVILS_SIGHT, FALSE));

    //Apply the VFX impact and effect
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(24), TRUE, -1, CasterLvl);
    IPSafeAddItemProperty(oSkin, ItemPropertyDarkvision(), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
}
