//:://////////////////////////////////////////////
//:: FileName: "sc_runmartyr"
/*   Purpose: This sets a CUSTOM TOKEN to be used in the conversation.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
//:://////////////////////////////////////////////
int StartingConditional()
{
    string sName = GetLocalString(GetPCSpeaker(), "sAllyForMyMartyrdom");
    SendMessageToPC(GetPCSpeaker(), "The name is " + sName + ".");
    SetCustomToken(3000, sName); // For conv.
    return TRUE;
}
