/*
    prc_pyro_nimbus

    Cloud that protects pyro and allows touch attack

    By: Flaming_Sword
    Created: Dec 7, 2007
    Modified: Dec 7, 2007
*/

#include "prc_alterations"
#include "prc_x2_itemprop"

void main()
{
    object oPC = OBJECT_SELF;
    int nLevel = (GetLevelByClass(CLASS_TYPE_PYROKINETICIST, oPC));
    float fDur = IntToFloat(nLevel * 60);
    effect eNimbus = EffectAbilityIncrease(ABILITY_CHARISMA, 4);
    eNimbus = EffectLinkEffects(EffectDamageReduction(5, DAMAGE_POWER_PLUS_ONE), eNimbus);
    eNimbus = EffectLinkEffects(EffectVisualEffect(VFX_DUR_ELEMENTAL_SHIELD), eNimbus);
    eNimbus = EffectLinkEffects(EffectVisualEffect(VFX_DUR_LIGHT_WHITE_20), eNimbus);
    eNimbus = EffectLinkEffects(EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE), eNimbus);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eNimbus, oPC, fDur);
    IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC), ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
}
