//::///////////////////////////////////////////////
//:: Name      Cold Comfort
//:: FileName  inv_coldcomfort.nss
//::///////////////////////////////////////////////
/*

Lesser Invocation
2nd Level Spell

You radiate an unnatural aura that protects you and
those around you to some small extent from the
ravages of the elements. This invocation acts like
the Endure Elements spell, and lasts for 24 hours
or until the caster takes more than 20 points of
elemental damage.

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
    effect eAOE = EffectAreaOfEffect(INVOKE_AOE_COLD_COMFORT);
    int nAmount = 20;
    int nResistance = 10;
    effect eCold = EffectDamageResistance(DAMAGE_TYPE_COLD, nResistance, nAmount);
    effect eFire = EffectDamageResistance(DAMAGE_TYPE_FIRE, nResistance, nAmount);
    effect eAcid = EffectDamageResistance(DAMAGE_TYPE_ACID, nResistance, nAmount);
    effect eSonic = EffectDamageResistance(DAMAGE_TYPE_SONIC, nResistance, nAmount);
    effect eElec = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, nResistance, nAmount);
    effect eDur = EffectVisualEffect(VFX_DUR_PROTECTION_ELEMENTS);
    effect eVis = EffectVisualEffect(VFX_IMP_ELEMENTAL_PROTECTION);
    effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(oCaster, INVOKE_COLD_COMFORT, FALSE));

    //Link Effects
    effect eLink = EffectLinkEffects(eCold, eFire);
           eLink = EffectLinkEffects(eLink, eAcid);
           eLink = EffectLinkEffects(eLink, eSonic);
           eLink = EffectLinkEffects(eLink, eElec);
           eLink = EffectLinkEffects(eLink, eDur);
           eLink = EffectLinkEffects(eLink, eDur2);
           eLink = EffectLinkEffects(eLink, eAOE);

    //Apply VFX impact and effects
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(24),TRUE,-1,CasterLvl);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}
