/*:://////////////////////////////////////////////
//:: Spell Name Purify Food and Drink
//:: Spell FileName PHS_S_PurifyFood
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Clr 0, Drd 0
    Components: V, S
    Casting Time: 1 standard action
    Range: Food touched
    Target: One portion of contaminated food or water
    Duration: Instantaneous
    Saving Throw: Will negates (object)
    Spell Resistance: Yes (object)

    This spell makes spoiled, rotten, poisonous, or otherwise contaminated
    food and water pure and suitable for eating and drinking. Unholy water
    and similar food and drink of significance is spoiled by purify food and
    drink, but the spell has no effect on creatures of any type nor upon magic
    potions.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Easily done:

    Replaces 1 set of items targeted with another.

    Targeted ones will be tagged "PHS_SPOILED_FOOD" and "PHS_SPOILED_WATER",
    and will create "clean" or new versions of them instead.

    If targeted against anthing else, well, if it is holy or unholy water, it
    will also replace it with an normal water bottle.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_PURIFY_FOOD_AND_DRINK)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    object oPossessor = GetItemPossessor(oTarget);
    string sTag = GetTag(oTarget);
    int nSize;


    // Check if bad water
    if(sTag == PHS_ITEM_SPOILED_WATER ||
       sTag == PHS_ITEM_HOLY_WATER ||
       sTag == PHS_ITEM_CURSED_WATER)
    {
        // Purify water
        FloatingTextStringOnCreature("*You purify the targeted water*", oCaster, FALSE);

        // Get stack size
        nSize = GetItemStackSize(oTarget);

        // Delete old ones
        DestroyObject(oTarget);

        // Create amount of new ones.
        PHS_ComponentActionCreateObject(PHS_ITEM_RESREF_WATER, nSize, oPossessor);
    }
    else if(sTag == PHS_ITEM_SPOILED_FOOD)
    {
        // Purify food
        FloatingTextStringOnCreature("*You purify the targeted food*", oCaster, FALSE);

        // Get stack size
        nSize = GetItemStackSize(oTarget);

        // Delete old ones
        DestroyObject(oTarget);

        // Create amount of new ones.
        PHS_ComponentActionCreateObject(PHS_ITEM_RESREF_FOOD, nSize, oPossessor);
    }
    else
    {
        // Nothing to purify
        FloatingTextStringOnCreature("*Nothing found to purify*", oCaster, FALSE);
        return;
    }

    // Do effects
    if(!GetIsObjectValid(oPossessor))
    {
        // Make the possessor the caster
        oPossessor = oCaster;
    }
    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_NATURE);
    // Apply VFX
    PHS_ApplyVFX(oPossessor, eVis);
    // Signal spell cast at
    PHS_SignalSpellCastAt(oPossessor, PHS_SPELL_PURIFY_FOOD_AND_DRINK, FALSE);
}
