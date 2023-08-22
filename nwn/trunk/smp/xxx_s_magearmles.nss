/*:://////////////////////////////////////////////
//:: Spell Name Mage Armor, Lesser
//:: Spell FileName XXX_S_MageArmLes
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Conjuration (Creation) [Force]
    Level: Sor/Wiz 0
    Components: V, S
    Casting Time: 1 standard action
    Range: Touch
    Target: Creature touched
    Duration: 3 rounds + 1 round/level (D)
    Saving Throw: Will Negates (Harmless)
    Spell Resistance: Yes (Harmless)
    Source: Various (Capn Charlie)

    An invisible but tangible field of force surrounds the subject of a
    lesser mage armor spell, providing a +1 armor bonus to AC. Unlike mundane
    armor, mage armor entails no armor check penalty or arcane spell failure
    chance.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    A lesser version, a cantrip, +1 AC instead of +4, and a much lower duration.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!SMP_SpellHookCheck(SMP_SPELL_MAGE_ARMOR_LESSER)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = SMP_GetMetaMagicFeat();
    int nCasterLevel = SMP_GetCasterLevel();

    // 3 + 1 Round/level
    float fDuration = SMP_GetDuration(SMP_ROUNDS, nCasterLevel + 3, nMetaMagic);

    // Delcare effects
    effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
    effect eAC = EffectACIncrease(1, AC_ARMOUR_ENCHANTMENT_BONUS);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eAC, eCessate);

    // Remove previous castings
    SMP_RemoveSpellEffectsFromTarget(SMP_SPELL_MAGE_ARMOR_LESSER, oTarget);

    // Signal spell cast at
    SMP_SignalSpellCastAt(oTarget, SMP_SPELL_MAGE_ARMOR_LESSER, FALSE);

    // Apply effects
    SMP_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
}
