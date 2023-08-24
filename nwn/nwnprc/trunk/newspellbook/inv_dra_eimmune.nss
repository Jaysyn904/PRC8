//::///////////////////////////////////////////////
//:: Name      Energy Immunity
//:: FileName  inv_dra_eimmune.nss
//::///////////////////////////////////////////////
/*

Dark Invocation
8th Level Spell

You gain immunity to acid, cold, electricity, fire
or energy, chosen when you cast the invocation.
If you cast this invocation again before the
duration ends, the new effect and duration replace
the old. This invocation lasts for 24 hours.

*/
//::///////////////////////////////////////////////

#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    if (!PreInvocationCastCode()) return;

    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLevel = GetInvokerLevel(oCaster, GetInvokingClass());
    int nSpellID = GetSpellId();
    int nDamageType, nVfx;
    float fDuration = HoursToSeconds(24);

    switch(nSpellID)
    {
        case(INVOKE_ENERGY_IMMUNITY_ACID):
        {
            nDamageType = DAMAGE_TYPE_ACID;
            nVfx = VFX_IMP_ACID_L;
            break;
        }
        case(INVOKE_ENERGY_IMMUNITY_COLD):
        {
            nDamageType = DAMAGE_TYPE_COLD;
            nVfx = VFX_IMP_FROST_L;
            break;
        }
        case(INVOKE_ENERGY_IMMUNITY_ELEC):
        {
            nDamageType = DAMAGE_TYPE_ELECTRICAL;
            nVfx = VFX_IMP_LIGHTNING_M;
            break;
        }
        case(INVOKE_ENERGY_IMMUNITY_FIRE):
        {
            nDamageType = DAMAGE_TYPE_FIRE;
            nVfx = VFX_IMP_FLAME_M;
            break;
        }
        case(INVOKE_ENERGY_IMMUNITY_SONIC):
        {
            nDamageType = DAMAGE_TYPE_SONIC;
            nVfx = VFX_IMP_SONIC;
            break;
        }
    }

    effect eList = EffectDamageImmunityIncrease(nDamageType, 100);
           eList = EffectLinkEffects(eList, EffectVisualEffect(VFX_DUR_PROTECTION_ELEMENTS));
           eList = EffectLinkEffects(eList, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));

    PRCSignalSpellEvent(oTarget, FALSE, SPELL_ENERGY_IMMUNITY);

    // Spell does not stack with itself, even if it is different immunity types
    if(GetHasSpellEffect(INVOKE_ENERGY_IMMUNITY_ACID, oTarget))
        PRCRemoveSpellEffects(INVOKE_ENERGY_IMMUNITY_ACID, oCaster, oTarget);
    if(GetHasSpellEffect(INVOKE_ENERGY_IMMUNITY_COLD, oTarget))
        PRCRemoveSpellEffects(INVOKE_ENERGY_IMMUNITY_COLD, oCaster, oTarget);
    if(GetHasSpellEffect(INVOKE_ENERGY_IMMUNITY_ELEC, oTarget))
        PRCRemoveSpellEffects(INVOKE_ENERGY_IMMUNITY_ELEC, oCaster, oTarget);
    if(GetHasSpellEffect(INVOKE_ENERGY_IMMUNITY_FIRE, oTarget))
        PRCRemoveSpellEffects(INVOKE_ENERGY_IMMUNITY_FIRE, oCaster, oTarget);
    if(GetHasSpellEffect(INVOKE_ENERGY_IMMUNITY_SONIC, oTarget))
        PRCRemoveSpellEffects(INVOKE_ENERGY_IMMUNITY_SONIC, oCaster, oTarget);

    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eList, oTarget, fDuration, TRUE, -1, nCasterLevel);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nVfx), oTarget);
}