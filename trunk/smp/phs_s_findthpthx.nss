/*:://////////////////////////////////////////////
//:: Spell Name Find the Path
//:: Spell FileName phs_s_findthpthX
//:://////////////////////////////////////////////
    Spawn file

    This makes the creature ghostly - can move through other creatures.

    Adds light (blue) to the creature.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

void main()
{
    // Ghost
    effect eGhost = EffectCutsceneGhost();
    // Light
    effect eLight = EffectVisualEffect(VFX_DUR_LIGHT_BLUE_20);
    // Link
    effect eLink = EffectLinkEffects(eGhost, eLight);
    // No dispel
    eLink = SupernaturalEffect(eLink);

    // Apply effects
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, OBJECT_SELF);
}
