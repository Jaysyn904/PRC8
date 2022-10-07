/*:://////////////////////////////////////////////
//:: Spell Name Mage Armor
//:: Spell FileName PHS_S_MageArmor
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Conjuration (Creation) [Force]
    Level: Sor/Wiz 1
    Components: V, S, F
    Casting Time: 1 standard action
    Range: Touch
    Target: Creature touched
    Duration: 1 hour/level (D)
    Saving Throw: Will negates (harmless)
    Spell Resistance: No

    An invisible but tangible field of force surrounds the subject of a mage
    armor spell, providing a +4 armor bonus to AC. Unlike mundane armor, mage
    armor entails no armor check penalty or arcane spell failure chance.

    Focus: A piece of cured leather.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As description (removed incorporal bit though).
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_MAGE_ARMOR)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCasterLevel = PHS_GetCasterLevel();

    // 1 Hour/level
    float fDuration = PHS_GetDuration(PHS_HOURS, nCasterLevel, nMetaMagic);

    // Delcare effects
    effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
    effect eAC = EffectACIncrease(4, AC_ARMOUR_ENCHANTMENT_BONUS);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eAC, eCessate);

    // Remove previous castings
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_MAGE_ARMOR, oTarget);

    // Signal spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_MAGE_ARMOR, FALSE);

    // Apply effects
    PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
}
