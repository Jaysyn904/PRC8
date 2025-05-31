//::///////////////////////////////////////////////
//:: OnPlayerChat eventscript
//:: prc_onplayerchat
//:://////////////////////////////////////////////
/*
    A OnChat script that parses what is said and 
	uses any commands or NUI associated with
	commands.
*/
//:://////////////////////////////////////////////
//:: Updated By: Rakiov
//:: Created On: 22.05.2005
//:://////////////////////////////////////////////

/*
PRC Chat Command Format:
~~command arg1 arg2 arg3 arg4 arg5
OR:
..command arg1 arg2 arg3 arg4 arg5
*/

#include "prc_alterations"
#include "prc_inc_chat"
#include "prc_inc_chat_dm"
#include "prc_inc_chat_pow"
#include "prc_inc_chat_shf"
#include "nw_inc_nui"
#include "prc_string_inc"
#include "prc_nui_sb_inc"
#include "prc_nui_consts"

const string CHAT_COMMAND_INDICATOR_1 = "~~";
const string CHAT_COMMAND_INDICATOR_2 = "..";
const int CHAT_COMMAND_INDICATOR_LENGHT = 2;

int GetIsChatCommand(string sString)
{
    string sTest = GetStringLeft(sString, CHAT_COMMAND_INDICATOR_LENGHT);
    if(sTest == CHAT_COMMAND_INDICATOR_1
    || sTest == CHAT_COMMAND_INDICATOR_2)
        return TRUE;
    return FALSE;
}

string RemoveChatCommandIndicator(string sString)
{
    return GetStringRight(sString, GetStringLength(sString) - CHAT_COMMAND_INDICATOR_LENGHT);
}

void main()
{
    object oPC = GetPCChatSpeaker();
    string sChat = GetPCChatMessage();

    if(GetIsChatCommand(sChat))
    {
        sChat = RemoveChatCommandIndicator(sChat);
        SetPCChatVolume(TALKVOLUME_TELL); //Set volume for all chat commands

        if(GetStringWord(sChat, 1) == "help")
        {
            if(GetStringWord(sChat, 2) == "")
            {
                HelpText(oPC, "=== HELP SUMMARY");
                HelpText(oPC, "");
                HelpText(oPC, "Chat commands start with ~~ or .. followed by the command name and then any parameters.");
                HelpText(oPC, "   For example '~~execute test_script' will run the script named 'test_script'.");
                HelpText(oPC, "");
                HelpText(oPC, "A hyphen in a command name indicates that the word may be abbreviated as short as the point where the hyphen is.");
                HelpText(oPC, "   For example, 'exec-ute' may be entered as 'execute', 'execu', or 'exec', but not as 'exe'.");
                HelpText(oPC, "");
                HelpText(oPC, "Typing '~~help' displays a summary of the available commands (what you're reading now).");
                HelpText(oPC, "Typing '~~help <command-name>' displays more detailed information about the specified command.");
                HelpText(oPC, "");
            }

            if (Debug_ProcessChatCommand_Help(oPC, sChat))
                {}
            else if (PowerAttack_ProcessChatCommand_Help(oPC, sChat))
                {}
            else if (PnPShifter_ProcessChatCommand_Help(oPC, sChat))
                {}
        }
        else
        {
            if (Debug_ProcessChatCommand(oPC, sChat))
                {}
            else if (PowerAttack_ProcessChatCommand(oPC, sChat))
                {}
            else if (PnPShifter_ProcessChatCommand(oPC, sChat))
                {}
            else
                SendMessageToPC(oPC, "Unrecognized chat command: " + sChat);
        }
    }
    else if(GetLocalInt(oPC, PRC_CHAT_HOOK_ACTIVE))
    {
        SetPCChatVolume(TALKVOLUME_TELL);
        SetLocalString(oPC, PRC_PLAYER_RESPONSE, sChat);
        ExecuteScript(GetLocalString(oPC, PRC_CHAT_HOOK_SCRIPT), oPC);
        _clear_chat_vars(oPC);
    }

    // get current player message and split it up into a list
    string sCommand = GetPCChatMessage();
    json sCommandSplit = StringSplit(sChat);

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
                SetLocalInt(oPC, "PRC_PowerAttack_Level", paAmount);
                ExecuteScript("prc_nui_pa_trggr", oPC);

                // update the NUI so it is in sync
                int nToken = NuiFindWindow(oPC, NUI_PRC_POWER_ATTACK_WINDOW);
                if (nToken != 0)
                {
                    NuiSetBind(oPC, nToken, NUI_PRC_PA_TEXT_BIND, JsonString(IntToString(paAmount)));
                }
            }
            else
            {
                // if no param is given then open the NUI
                ExecuteScript("prc_nui_pa_view", oPC);
            }

            // clear message from chat
            SetPCChatMessage();
        }
        // If the first word is /sb then we open the Spellbook NUI
        if(firstWord == "/sb")
        {
            ExecuteScript("prc_nui_sb_view", oPC);

            // clear message from chat
            SetPCChatMessage();
        }
    }



    // Execute scripts hooked to this event for the player triggering it
    ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONPLAYERCHAT);
}