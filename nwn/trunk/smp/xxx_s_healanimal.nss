/*:://////////////////////////////////////////////
//:: Spell Name Heal Animal Companion
//:: Spell FileName XXX_S_HealAnimal
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Heal Animal Companion
    Conjuration (Healing)
    Level: Drd 5, Rgr 3
    Components: V, S
    Casting Time: 1 standard action
    Range: Touch
    Target: Caster's animal companion touched
    Duration: Instantaneous
    Saving Throw: None
    Spell Resistance: Yes (Harmless)
    Source: Various (WotC)

    Heal animal companion enables the caster to wipe away disease and injury in
    their own animal companions. It completely cures all diseases, blindness, or
    deafness of the animal companion, cures all points of damage suffered due to
    wounds or injury, and repairs temporary ability damage. It cures mental
    disorders caused by spells or injury to the brain.

    Heal animal companion does not remove negative levels, restore drained
    levels, or restore drained ability scores.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This is pretty good, and is wizards spell from thier archive spellbook.

    Removes:
    - Bindness
    - Deafness
    - Diseases
    - All damage (full heal)
    - All ability damage

    The mental things:
    - Removes the insanity spell effect
    - Confusion effects
    - Charming, Domination.

    Oh, dammit, lets just use what heal does!
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!SMP_SpellHookCheck(SMP_SPELL_HEAL_ANIMAL_COMPANION)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nSpellSaveDC = SMP_GetSpellSaveDC();
    int nCasterLevel = SMP_GetCasterLevel();
    int nTargetHP = GetCurrentHitPoints(oTarget);

    // Declare effects
    effect eHeal = EffectHeal(nTargetHP);
    effect eHealVis = EffectVisualEffect(VFX_IMP_HEALING_X);

    // Signal spell cast at
    SMP_SignalSpellCastAt(oTarget, SMP_SPELL_HEAL_ANIMAL_COMPANION);

    // Must be animal companion to heal
    if(GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION) == oTarget)
    {
        // We remove all the things in a effect loop.
        SMP_HealSpellRemoval(oTarget);

        // Remove fatige
        SMP_RemoveFatigue(oTarget);

        // We heal damage after
        SMP_ApplyInstantAndVFX(oTarget, eHealVis, eHeal);
    }
}
