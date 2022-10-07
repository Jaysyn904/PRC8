/*:://////////////////////////////////////////////
//:: Spell Name Spellguard
//:: Spell FileName XXX_S_Spellguard
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Abjuration
    Level: Sor/Wiz 8
    Components: V, S, M
    Casting Time: 1 standard action
    Range: Personal
    Target: Caster
    Duration: 4 rounds
    Saving Throw: None
    Spell Resistance: No
    Source: Various (shadow mage)

    When you cast the spell, a transparent barrier of arcane energy protects you
    from all spells of 6th level or lower which allow a spell resistance check,
    for the duration. Spellcasters casting spells of 7th level or higher at you
    must succeed at a Spellcraft check, DC equal to your spellcaster level + your
    Intelligence or Charisma modifier for wizards and sorcerers respectively.
    Their success indicates you are affected as normal by the spell and their
    failure indicates your spellguard blocked the magical attack.

    Once the spellguard is raised, it lasts for 4 rounds, whenupon it is
    discharged. Only one spellguard may be active for the caster at any one
    time, and spells which do allow or provide harmless spell resistance checks
    are not affected by the barrier.

    Material Components: a small crystal shaped into a shield, worth 500 gp.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    How this is done, its pretty easy:

    1. It alters the SMP_SpellResistanceCheck() function.
    2. It applies the normal immunity: 6 level spells and lower, to the caster
    3. If at any time the function is called, they pass the checks for ResistSpell()
       and it would normally return FALSE, a new check is made (for spellcraft,
       as the description) as it will be a level 7+ spell. The DC is set
       on the caster.

    Easy. Note: This needs testing. It is 4 rounds long, as Guardian Mantal type
    spells are (also made up) to provide some tempoary immunity to spells, or
    at least an expensive one (500GP component, only 4 rounds long is nothing
    compared to other helpful spells, but helpful in short term).
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!SMP_SpellHookCheck(SMP_SPELL_SPELLGUARD)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();// Should always be us.
    int nMetaMagic = SMP_GetMetaMagicFeat();
    int nCasterLevel = SMP_GetCasterLevel();
    int nAbility = SMP_GetAppropriateAbilityBonus();
    // DC for level 7+ spells. Spellcraft check.
    int nDC = nCasterLevel + nAbility;

    // Component check
    if(!SMP_ComponentExactItemRemove(SMP_ITEM_CRYSTALSHIELD, "A small crystal shaped into a Shield, worth 500GP", "Spellguard")) return;

    // Declare effects
    effect eDur = EffectVisualEffect(VFX_DUR_SPELLTURNING);
    effect eImmune = EffectSpellLevelAbsorption(6);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eDur, eImmune);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Duration is 4 rounds
    float fDuration = RoundsToSeconds(4);

    // This will remove the previous ones.
    SMP_RemoveSpellEffectsFromTarget(SMP_SPELL_SPELLGUARD, oTarget);

    // Set the DC of level 7+ spells cast on the caster.
    // * see SMP_INC_RESIST
    SetLocalInt(oCaster, "SMP_SPELL_SPELLGUARD_DC", nDC);

    // Apply effects
    SMP_ApplyDuration(oTarget, eLink, fDuration);
}
