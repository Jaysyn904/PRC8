//:://////////////////////////////////////////////
//:: FileName: "at_runmymartyr"
/*   Purpose: This is an ActionTaken script, intended for use as a positive
        answer in the 'Allied Martyr' spell's conversation.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
//:://////////////////////////////////////////////
void main()
{
    ExecuteScript("run_all_martyr", GetPCSpeaker());
}
