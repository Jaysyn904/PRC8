/*:://////////////////////////////////////////////
//:: Spell Name Curse Water
//:: Spell FileName PHS_S_CurseWater
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Range: Touch
    Target: Bottle of Water touched
    Duration: Instantaneous

    This spell imbues a flask of water with negative energy, turning it
    into unholy water. Unholy water damages good outsiders the way holy water
    damages undead and evil outsiders.

    Material Component: 5 pounds of powdered silver (worth 25 gp).
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This takes 1 lot of silver, and 1 bottle of water, and creates a cursed
    grenade.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_CURSE_WATER)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    string sTag = GetTag(oTarget);

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_EVIL_HELP);

    // Signal spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_CURSE_WATER, FALSE);

    // Check if sTag is a water bottle tag
    if(sTag == PHS_ITEM_WATER)
    {
        // Make sure the caster has the right items
        // - Silver
        if(PHS_ComponentExactItemRemove(PHS_ITEM_SPELL_5LS_SILVER, "5lbs of silver", "Curse Water")) return;

        // Apply effects
        PHS_ApplyVFX(oTarget, eVis);

        // Remove one holy wayer
        PHS_ComponentItemRemoveBy1(oTarget);

        // Create new item - Cursed Water
        PHS_ComponentActionCreateObject(PHS_ITEM_RESREF_CURSED_WATER, 1);
    }
}
