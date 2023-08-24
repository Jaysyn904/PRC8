/*:://////////////////////////////////////////////
//:: Spell Name Obscure Object
//:: Spell FileName PHS_S_ObscureObj
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Abjuration
    Level: Brd 1, Clr 3, Sor/Wiz 2
    Components: V, S, M/DF
    Casting Time: 1 standard action
    Range: Touch
    Target: One item touched of up to 100 lb./level
    Duration: 8 hours (D)
    Saving Throw: Will negates (object)
    Spell Resistance: Yes (object)

    This spell hides an item from location by divination (scrying) effects,
    such as the scrying spell or a crystal ball. Such an attempt automatically
    fails (if the divination is targeted on the object).

    Arcane Material Component: A piece of chameleon skin.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Uses a local variable, as this could be targeted onto an item or placeable.

    Ok, made it item-only.

    Not complete.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_OBSCURE_OBJECT)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nObjectType = GetObjectType(oTarget);
    int nCasterLevel = PHS_GetCasterLevel();

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_FNF_SMOKE_PUFF);

    // Checks
    if(nObjectType == OBJECT_TYPE_ITEM)
    {
        // Check item weight
        if(GetWeight(oTarget) <= nCasterLevel * 10)
        {
            // Apply visual
            PHS_IP_ApplyImactVisualAtItemLocation(eVis, oTarget);
        }
    }
}
