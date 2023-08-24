#include "nw_i0_generic"

void main()
{
    int nMatch = GetListenPatternNumber();
    object oDisk = OBJECT_SELF;
    object oShouter = GetLastSpeaker();

    if(nMatch == -1)
    {
        // Not a match -- start an ordinary conversation
        if(GetCommandable(oDisk))
        {
            ClearActions(CLEAR_NW_C2_DEFAULT4_29);
            BeginConversation();
        }
    }
    else if(nMatch == ASSOCIATE_COMMAND_INVENTORY)
    {
        OpenInventory(oDisk, oShouter);
    }
}