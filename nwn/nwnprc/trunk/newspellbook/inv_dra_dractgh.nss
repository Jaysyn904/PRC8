//::///////////////////////////////////////////////
//:: Name      Draconic Toughness
//:: FileName  inv_dra_dractgh.nss
//::///////////////////////////////////////////////
/*

Greater Invocation
5th Level Spell

You gain temporary hit points equal to your caster
level. These hit points last for 24 hours or until
the invocation is cast again, in which case the new
effect replaces the old.

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

    // Spell does not stack with itself
    if(GetHasSpellEffect(INVOKE_DRACONIC_TOUGHNESS,oTarget))
         PRCRemoveSpellEffects(INVOKE_DRACONIC_TOUGHNESS, oCaster, oTarget);

    effect eHP = EffectTemporaryHitpoints(nCasterLevel);
    effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(oCaster, INVOKE_DRACONIC_TOUGHNESS, FALSE));

    //Apply the VFX impact and effects
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, oTarget, HoursToSeconds(24),TRUE,-1,nCasterLevel);
}