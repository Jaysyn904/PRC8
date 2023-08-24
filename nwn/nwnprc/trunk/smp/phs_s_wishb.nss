/*:://////////////////////////////////////////////
//:: Spell Name Wish - On Conversation of Djinni
//:: Spell FileName PHS_S_WishB
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Listening script of the Djinni.

    Must be in parameters - need to sort this out!

    Add the things to do in the PHS_INC_WISH include, which can execute from a
    DM wand if needed :-D
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_WISH"

void main()
{
    // Get the speaker, and the thing spoken
    object oSelf = OBJECT_SELF;
    object oPC = GetLastSpeaker();
    // * Get upperstring case!
    string sSaid = GetStringUpperCase(GetMatchedSubstring(0));

    // oPC must be who is wishing!
    if(GetLocalObject(oSelf, "PHS_WISHER") != oPC) return;

    // If they say

    if(sSaid == "exit")
    {
        PHS_CompletelyDestroyObject(oSelf);
    }


    // Teleport placeholder



    // Curing placeholder

}
