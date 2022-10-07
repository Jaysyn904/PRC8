/*:://////////////////////////////////////////////
//:: Spell Name Wish - On Heartbeat of Djinni
//:: Spell FileName PHS_S_WishC
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Heartbeat script of the Djinni.

    Just checks for timestop. If none is applied, it destroys ourself, if we
    have been here for 2 seconds or more.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_WISH"

void main()
{
    // Get us
    object oSelf = OBJECT_SELF;

    // Gets set after 2 seconds to allow this to check properly.
    if(!GetLocalInt(oSelf, "PHS_HEARTBEAT_VALID")) return;

    // Check for time stop, if we havn't got it, we go, because something has
    // removed it somehow (DM maybe?)
    // * Also checks if wisher is still valid (not logged out etc.)
    if(PHS_GetHasEffect(EFFECT_TYPE_TIMESTOP, oSelf) ||
      !GetIsObjectValid(GetLocalObject(oSelf, "PHS_WISHER")))
    {
        PHS_CompletelyDestroyObject(oSelf);
    }
}
