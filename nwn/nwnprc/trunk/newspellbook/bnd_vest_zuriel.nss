/*
Zuriel, the Bronze God (Epic Vestige, Level 9, DC 43)
*/
#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = PRCGetSpellTargetObject();
    object oSkin = GetPCSkin(oBinder);

    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_PROT_EPIC_ARMOR), EffectPact(oBinder));

    // Bronze Body
    if (!GetIsVestigeExploited(oBinder, VESTIGE_ZURIEL_BRONZE_BODY))
    {
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_ZURIEL_BRONZE_BODY), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }

    // Forceful Speed of Thought
    if (!GetIsVestigeExploited(oBinder, VESTIGE_ZURIEL_FORCEFUL_SPEED))
    {
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_ZURIEL_FORCEFUL_SPEED), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }

    // Ultimate Sacrifice
    if (!GetIsVestigeExploited(oBinder, VESTIGE_ZURIEL_ULTIMATE_SACRIFICE))
    {
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_ZURIEL_SACRIFICE), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }

    SetLocalInt(oBinder, "ZurielBoundActive", TRUE);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, TagEffect(SetEffectSpellId(SupernaturalEffect(eLink), VESTIGE_ZURIEL), "VestigeMain_Zuriel"), oBinder, HoursToSeconds(24));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), oBinder);
}
