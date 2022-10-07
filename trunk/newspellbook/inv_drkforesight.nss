//::///////////////////////////////////////////////
//:: Name      Dark Foresight
//:: FileName  inv_drkforesight.nss
//::///////////////////////////////////////////////
/*

Dark Invocation
9th Level Spell

You gain foresight, as the spell. You gain a +2
insight bonus to Reflex saves and AC, and are never
surprised or flatfooted. This lasts 10 minutes per
level.

*/
//::///////////////////////////////////////////////

#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    if(!PreInvocationCastCode()) return;

    object oPC = OBJECT_SELF;
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    int nCasterLvl = GetInvokerLevel(oPC, GetInvokingClass());
    float fDur = (600.0f * nCasterLvl);

    itemproperty iDodge = PRCItemPropertyBonusFeat(FEAT_UNCANNY_DODGE_1);
    effect eLink = EffectLinkEffects(EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK), EffectACIncrease(2, AC_DODGE_BONUS, AC_VS_DAMAGE_TYPE_ALL));
           eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_REFLEX, 2, SAVING_THROW_TYPE_ALL));

	PRCRemoveSpellEffects(PRCGetSpellId(), oPC, oPC);
	GZPRCRemoveSpellEffects(PRCGetSpellId(), oPC, FALSE);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDur);
    IPSafeAddItemProperty(oArmor, iDodge, fDur);
}