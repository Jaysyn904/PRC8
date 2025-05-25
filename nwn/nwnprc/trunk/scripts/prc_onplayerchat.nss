//::///////////////////////////////////////////////
//:: OnPlayerChat eventscript
//:: prc_onplayerchat
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
	
	ExecuteScript("hp_pa_chatscript", oPC);
    // Execute scripts hooked to this event for the player triggering it
    ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONPLAYERCHAT);
}