//::///////////////////////////////////////////////
//:: Power Attack NUI
//:: hp_pa_chatscript
//:://////////////////////////////////////////////
/*
    A OnChat script that parses what is said and opens the power attack NUI
    if provided /pa. Otherwise if /pa x is provided run the command directly
*/
//:://////////////////////////////////////////////
//:: Created By: Rakiov
//:: Created On: 22.05.2005
//:://////////////////////////////////////////////

#include "nw_inc_nui"
#include "hp_pa_view"
#include "hp_string_util"

void main()
{
    // Get current player
    object oPlayer = GetPCChatSpeaker();
    if (!GetIsPC(oPlayer))
    {
        return;
    }

    // get current player message and split it up into a list
    string sCommand = GetPCChatMessage();
    json sCommandSplit = StringSplit(sCommand);

    if(JsonGetLength(sCommandSplit) > 0)
    {
        string firstWord = JsonGetString(JsonArrayGet(sCommandSplit, 0));

        // if first word is /pa we are using the power attack interface
        if(firstWord == "/pa")
        {
            if(JsonGetLength(sCommandSplit) >= 2)
            {
                //if a parameter is given then run the power attack command directly.
                string param1 = JsonGetString(JsonArrayGet(sCommandSplit, 1));
                int paAmount = StringToInt(param1);
                SetLocalInt(oPlayer, "PRC_PowerAttack_Level", paAmount);
                ExecuteScript("hp_pa_script", oPlayer);

                // update the NUI so it is in sync
                int nToken = NuiFindWindow(oPlayer, NUI_PRC_POWER_ATTACK_WINDOW);
                if (nToken != 0)
                {
                    NuiSetBind(oPlayer, nToken, NUI_PRC_PA_TEXT_BIND, JsonString(IntToString(paAmount)));
                }
            }
            else
            {
                // if no param is given then open the NUI
                NuiPRCPowerAttackView(oPlayer);
            }

            // clear message from chat
            SetPCChatMessage();
        }
    }
}