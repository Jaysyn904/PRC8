/*:://////////////////////////////////////////////
//:: Spell Name Wood Shape
//:: Spell FileName PHS_S_WoodShape
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Drd 2
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: Touch
    Target: One touched piece of wood
    Duration: Instantaneous
    Saving Throw: Will negates (object)
    Spell Resistance: Yes (object)

    Wood shape enables you to form one existing piece of wood into different
    shapes. By doing this, you can turn a piece of wood into any one of the
    items on the list below. This cannot be dispelled as it is an instantaneous
    effect. Also note that none of these items would be sellable, as they are
    too simple by a blacksmiths or shopkeepers standards, although they act the
    same in combat or otherwise.

    Items you can transform the wood into include:
    - Club
    - Quarterstaff
    - Simple Box with no lid
    -
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Easily, removes the wood targeted, and replaces it with a brand spanking
    new item.

    All items are custom-pallet, and plotted, with a nice description about
    how they look (nice and plain!)
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_WOOD_SHAPE)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject(); // Should be an item!
    object oPossessor = GetItemPossessor(oTarget);
    string sTag = GetTag(oTarget);
    int nSpellId = GetSpellId();

    // Visual effects. Need it to work on the ground really too.
    effect eWoodImp = EffectVisualEffect(VFX_IMP_HEAD_NATURE);

    if(GetIsObjectValid(oPossessor))
    {
        // VFX impact
        PHS_ApplyVFX(oPossessor, eWoodImp);

        // Signal event
        PHS_SignalSpellCastAt(oPossessor, PHS_SPELL_WOOD_SHAPE, FALSE);
    }

    // Should target the projectiles to change
    if(GetIsObjectValid(oTarget) &&
       sTag == PHS_ITEM_WOOD &&
       GetPlotFlag(oTarget) == FALSE)
    {
        // Remove the wood
        FloatingTextStringOnCreature("*You warp the wood into a new shape*", oCaster, FALSE);
        DestroyObject(oTarget);

        // Change the item depending on what spell was chosen
        if(nSpellId == PHS_SPELL_WOOD_SHAPE_CLUB)
        {
            // - Club
            CreateItemOnObject(PHS_ITEM_RESREF_WS_CLUB);
        }
        else if(nSpellId == PHS_SPELL_WOOD_SHAPE_STAFF)
        {
            // - Staff
            CreateItemOnObject(PHS_ITEM_RESREF_WS_STAFF);
        }
        else if(nSpellId == PHS_SPELL_WOOD_SHAPE_BOX)
        {
            // - Box
            CreateItemOnObject(PHS_ITEM_RESREF_WS_BOX);
        }
        else if(nSpellId == PHS_SPELL_WOOD_SHAPE_4)
        {
            // - (Temp) Box
            CreateItemOnObject(PHS_ITEM_RESREF_WS_BOX);
        }
        else if(nSpellId == PHS_SPELL_WOOD_SHAPE_5)
        {
            // - (Temp) Box
            CreateItemOnObject(PHS_ITEM_RESREF_WS_BOX);
        }
        else
        {
            // Invalid
        }
    }
}
