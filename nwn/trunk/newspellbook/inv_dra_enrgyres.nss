//::///////////////////////////////////////////////
//:: Name      Energy Resistance
//:: FileName  inv_dra_enrgyres.nss
//::///////////////////////////////////////////////
/*

Lesser Invocation
3rd Level Spell

You gain resistance 10 to acid, cold, electricity,
fire or energy, chosen when you cast the invocation.
If you cast this invocation again before the
duration ends, the new effect and duration replace
the old. This invocation lasts for 24 hours.

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
    int nSpellID = PRCGetSpellId();
    int nDamageType, nVfx;
    float fDuration = HoursToSeconds(24);

    switch(nSpellID)
    {
        case INVOKE_ENERGY_RESISTANCE_ACID:
        {
            nDamageType = DAMAGE_TYPE_ACID;
            nVfx = VFX_IMP_ACID_L;
            break;
        }
        case INVOKE_ENERGY_RESISTANCE_COLD:
        {
            nDamageType = DAMAGE_TYPE_COLD;
            nVfx = VFX_IMP_FROST_L;
            break;
        }
        case INVOKE_ENERGY_RESISTANCE_ELEC:
        {
            nDamageType = DAMAGE_TYPE_ELECTRICAL;
            nVfx = VFX_IMP_LIGHTNING_M;
            break;
        }
        case INVOKE_ENERGY_RESISTANCE_FIRE:
        {
            nDamageType = DAMAGE_TYPE_FIRE;
            nVfx = VFX_IMP_FLAME_M;
            break;
        }
        case INVOKE_ENERGY_RESISTANCE_SONIC:
        {
            nDamageType = DAMAGE_TYPE_SONIC;
            nVfx = VFX_IMP_SONIC;
            break;
        }
    }

    effect eList = EffectDamageResistance(nDamageType, 10);
           eList = EffectLinkEffects(eList, EffectVisualEffect(VFX_DUR_PROTECTION_ELEMENTS));
           eList = EffectLinkEffects(eList, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));

    PRCSignalSpellEvent(oTarget, FALSE, INVOKE_ENERGY_RESISTANCE);

    // Spell does not stack with itself, even if it is different immunity types
    if(GetHasSpellEffect(INVOKE_ENERGY_RESISTANCE_ACID, oTarget))
        PRCRemoveSpellEffects(INVOKE_ENERGY_RESISTANCE_ACID, oCaster, oTarget);
    if(GetHasSpellEffect(INVOKE_ENERGY_RESISTANCE_COLD, oTarget))
        PRCRemoveSpellEffects(INVOKE_ENERGY_RESISTANCE_COLD, oCaster, oTarget);
    if(GetHasSpellEffect(INVOKE_ENERGY_RESISTANCE_ELEC, oTarget))
        PRCRemoveSpellEffects(INVOKE_ENERGY_RESISTANCE_ELEC, oCaster, oTarget);
    if(GetHasSpellEffect(INVOKE_ENERGY_RESISTANCE_FIRE, oTarget))
        PRCRemoveSpellEffects(INVOKE_ENERGY_RESISTANCE_FIRE, oCaster, oTarget);
    if(GetHasSpellEffect(INVOKE_ENERGY_RESISTANCE_SONIC, oTarget))
        PRCRemoveSpellEffects(INVOKE_ENERGY_RESISTANCE_SONIC, oCaster, oTarget);

    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eList, oTarget, fDuration, TRUE, -1, nCasterLevel);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nVfx), oTarget);
}