/*:://////////////////////////////////////////////
//:: Spell Name Bless Water
//:: Spell FileName phs_s_blesswater
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Target: Bottle of Water touched
    Duration: Instantaneous

    This transmutation imbues a flask of water with positive energy, turning it
    into holy water.

    Material Component: 5 pounds of powdered silver (worth 25 gp).
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This takes 1 lot of silver, and 1 bottle of water, and creates a holy
    grenade.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck()) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    string sTag = GetTag(oTarget);

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);

    // Signal spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_BLESS_WATER, FALSE);

    // Check if sTag is a water bottle tag
    if(sTag == PHS_ITEM_WATER)
    {
        // Make sure the caster has the right items
        // - Silver
        if(PHS_ComponentExactItemRemove(PHS_ITEM_SPELL_5LS_SILVER, "5lbs of silver", "Bless Water")) return;

        // Apply effects
        PHS_ApplyVFX(oTarget, eVis);

        // Remove one holy wayer
        PHS_ComponentItemRemoveBy1(oTarget);

        // Create new item - Holy Water
        PHS_ComponentActionCreateObject(PHS_ITEM_RESREF_HOLY_WATER, 1);
    }
}
