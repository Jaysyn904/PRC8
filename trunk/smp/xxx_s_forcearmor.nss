/*:://////////////////////////////////////////////
//:: Spell Name Force Armor
//:: Spell FileName XXX_S_ForceArmor
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Conjuration (Creation) [Force]
    Also known as: Muntazea’s Fictive Rope
    Level: Brd 5, Sor/Wiz 4
    Components: V, S, M (F)
    Casting Time: 1 standard action
    Range: Personal
    Target: Caster
    Duration: 1 hour/level (D)
    Saving Throw: Will negates (harmless)
    Spell Resistance: No
    Source: Various (VolkorTheRed)

    An invisible, but tangible field of force surrounds the caster, providing a
    +8 armor bonus to AC. Unlike mundane armor, force armor entails no armor
    check penalty or arcane spell failure chance.

    The spell material focus is a diamond worth at least 250 GP, encased in a
    metal sheet.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As description.

    "Improved Mage Armor"

    Material component, and personal only.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!SMP_SpellHookCheck(SMP_SPELL_FORCE_ARMOR)) return;

    // Check for SMP_ITEM_DIAMOND_IN_METAL,
    // "a diamond worth at least 250 GP, encased in a metal sheet."
    if(!SMP_ComponentExactItem(SMP_ITEM_DIAMOND_IN_METAL, "A diamond worth 250GP, encased in a metal sheet", "Force Armor")) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();// Should be OBJECT_SELF
    int nMetaMagic = SMP_GetMetaMagicFeat();
    int nCasterLevel = SMP_GetCasterLevel();

    // 1 Hour/level
    float fDuration = SMP_GetDuration(SMP_HOURS, nCasterLevel, nMetaMagic);

    // Delcare effects
    effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
    effect eAC = EffectACIncrease(8, AC_ARMOUR_ENCHANTMENT_BONUS);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eAC, eCessate);

    // Remove previous castings
    SMP_RemoveSpellEffectsFromTarget(SMP_SPELL_FORCE_ARMOR, oTarget);

    // Signal spell cast at
    SMP_SignalSpellCastAt(oTarget, SMP_SPELL_FORCE_ARMOR, FALSE);

    // Apply effects
    SMP_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
}
