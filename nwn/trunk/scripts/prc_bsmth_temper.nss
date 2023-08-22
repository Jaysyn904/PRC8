
//#include "prc_alterations"

void main()
{
    object oPC = OBJECT_SELF;
    effect eLink = EffectLinkEffects(EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, 50), EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING, 50));
    eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 50));
    eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 6.0);
}
