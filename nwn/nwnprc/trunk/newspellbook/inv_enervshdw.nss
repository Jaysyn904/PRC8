//::///////////////////////////////////////////////
//:: Name      Enervating Shadow
//:: FileName  inv_enervshdw.nss
//::///////////////////////////////////////////////
/*

Greater Invocation
5th Level Spell

The dark powers cloak you and shield you from harm,
while draining vitality from nearby foes. Any
living creature within 10' of you must make a
fortitude save or take a -4 penalty to Strength for
5 rounds. Creatures can only be affected by this
once every 24 hours. This ability lasts 5 rounds,
and does not work in sunlight or magical bright
light.

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
    int CasterLvl = GetInvokerLevel(oCaster, GetInvokingClass());
    effect eAOE = EffectAreaOfEffect(INVOKE_AOE_ENERVATING_SHADOW);
    effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eDur = EffectVisualEffect(VFX_DUR_INVISIBILITY);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(oCaster, INVOKE_ENERVATING_SHADOW, FALSE));

    //Link Effects
    effect eLink = EffectLinkEffects(eDur2, eAOE);
    eLink = EffectLinkEffects(eDur, eLink);

    //Apply VFX impact and effects
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(5), TRUE, -1, CasterLvl);
}