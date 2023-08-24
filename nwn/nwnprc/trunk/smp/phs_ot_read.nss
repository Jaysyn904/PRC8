/*:://////////////////////////////////////////////
//:: Name Read
//:: FileName PHS_OT_Read
//:://////////////////////////////////////////////
//:: Notes
//:://////////////////////////////////////////////
    When activated, as a spell (like Unique Power is) it will start an approprate
    conversation for the book/scroll/whatever.

    Includes "Explosive Runes" check too.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Declare major variables
    object oSelf = OBJECT_SELF;

    // Get conversation based on the item used tag
    object oUsed = GetSpellCastItem();

    if(GetIsObjectValid(oUsed))
    {
        // Get tag and activate "cnv_" + tag
        string sConversastion = "cnv_" + GetTag(oUsed);

        // Stop other things
        ClearAllActions();

        // Play some reading animation if it wasn't a scroll
        if(GetBaseItemType(oUsed) != BASE_ITEM_SCROLL)
        {
            ActionPlayAnimation(ANIMATION_FIREFORGET_READ);
        }
        // See if Explosive Runes explode..
        if(PHS_ExplosiveRunes()) return;

        // Start the conversation with self.
        ActionStartConversation(oSelf, sConversastion, TRUE, FALSE);
    }
}
