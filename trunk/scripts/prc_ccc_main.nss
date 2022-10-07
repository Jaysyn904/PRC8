//:://////////////////////////////////////////////
//:: Conversation Charactor Creator
//:: prc_ccc.nss
//:://////////////////////////////////////////////
/** @file
    Long description


    @author Primogenitor, modified by fluffyamoeba
    @date   Created  - 2006.09.18
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

// includes

#include "ccc_inc_convo"
#include "prc_inc_spells"

//////////////////////////////////////////////////
/* Constant defintions + functions              */
//////////////////////////////////////////////////

// see includes

//////////////////////////////////////////////////
/* Main function                                */
//////////////////////////////////////////////////

void main()
{
    object oPC = GetPCSpeaker();
    int bBoot; // used by this script to mark if the PC should be booted

    if(!GetIsObjectValid(oPC)) // if no valid speaker, then not part of the convo
    {
        // no valid speaker so need to get the PC properly this time
        oPC = GetEnteringObject();
        //oPC = GetLastUsedBy();
        // if called for a NPC, DM or the switch isn't enabled
        if(!GetIsPC(oPC) || GetIsDM(oPC) || !GetPRCSwitch(PRC_CONVOCC_ENABLE))
            return;
        
        // check letoscript is setup correctly
        // if letoscript can't find the bic, the convoCC won't work. 
        // will boot the PC later if they should go through the convoCC but can't
        // otherwise ignore
        bBoot = DoLetoscriptTest(oPC);
        
        // encryption stuff
        /* TODO proper comment */
        string sEncrypt;
        sEncrypt= Encrypt(oPC);
        
        // reset
        DeleteLocalString(oPC, "CONVOCC_ENTER_BOOT_MESSAGE");
        int nPCStatus = CONVOCC_ENTER_BOOT_PC;
        if(GetPRCSwitch(PRC_CONVOCC_CUSTOM_ENTER_SCRIPT)) // custom entry script stuff here
        {
            DeleteLocalInt(oPC,"CONVOCC_LAST_STATUS");
            /**
             * The custom script must:
             * - be called "ccc_custom_enter"
             * - set the local int "CONVOCC_LAST_STATUS" on the PC (OBJECT_SELF)
             * - include prc_ccc_const (for the constants the local int can be set to)
             * otherwise the PC will always be booted
             *
             * possible values for CONVOCC_LAST_STATUS:
             * CONVOCC_ENTER_BOOT_PC (causes the PC to get kicked)
             * CONVOCC_ENTER_NEW_PC (causes the PC to go through the convoCC)
             * CONVOCC_ENTER_RETURNING_PC (causes the PC to skip the convoCC)
             */
            ExecuteScript("ccc_custom_enter", oPC);
            nPCStatus = GetLocalInt(oPC,"CONVOCC_LAST_STATUS");
            DeleteLocalInt(oPC,"CONVOCC_LAST_STATUS");
        }
        else // default handling of whether to send PCs through the convoCC
        {
            // if a new character...
            if((GetPRCSwitch(PRC_CONVOCC_USE_XP_FOR_NEW_CHAR) && GetXP(oPC) == 0)
            || (!GetPRCSwitch(PRC_CONVOCC_USE_XP_FOR_NEW_CHAR) && GetTag(oPC) != sEncrypt))
            {
                nPCStatus = CONVOCC_ENTER_NEW_PC;
            }
            else // returning PC
            {
                nPCStatus = CONVOCC_ENTER_RETURNING_PC;
            }
        }
        if (DEBUG) { DoDebug("**** nPCStatus: "+ IntToString(nPCStatus));}
        /* Now to deal with some special cases that always override the custom script
         * These only apply if the PC was supposed to be going through the convoCC, ie.
         * where nPCStatus == CONVOCC_ENTER_NEW_PC.
         */
        if(nPCStatus == CONVOCC_ENTER_NEW_PC)
        {
            if(bBoot) // if singleplayer or letoscript not set up correctly
                nPCStatus = CONVOCC_ENTER_BOOT_PC;
            else if (GetIsObjectValid(GetLocalObject(GetModule(), "ccc_active_pc"))) // next see if someone has already started the convo
            {
                nPCStatus = CONVOCC_ENTER_BOOT_PC;
                SetLocalString(oPC, "CONVOCC_ENTER_BOOT_MESSAGE", 
                    "The conversation Character Creator is in use, please try later.");
            }
        }
        if (DEBUG) { DoDebug("**** nPCStatus: "+ IntToString(nPCStatus));}
        // end of decision making

        /* kick the PC */
        if (nPCStatus == CONVOCC_ENTER_BOOT_PC)
        {
            CheckAndBootNicely(oPC);
            return;
        }
        /* new character */
        else if (nPCStatus == CONVOCC_ENTER_NEW_PC)
        {
            // now reserve the conversation slot - only one at a time
            SetLocalObject(GetModule(), "ccc_active_pc", oPC);
            // remove equipped items and clear out inventory
            DoStripPC(oPC);
            //rest them so that they loose cutscene invisible
            //from previous logons
            ForceRest(oPC);
            //Take their Gold
            AssignCommand(oPC,TakeGoldFromCreature(GetGold(oPC),oPC,TRUE));
            //DISABLE FOR DEBUGGING
            if (!DEBUG)
            {
                // start the cutscene
                // off for debugging to see the debug text in the client
                SetCutsceneMode(oPC, TRUE);
            }
            SetCameraMode(oPC, CAMERA_MODE_TOP_DOWN);
            //make sure the PC stays put
            effect eParal = EffectCutsceneImmobilize();
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eParal, oPC, 9999.9);
            //start the ConvoCC conversation
            DelayCommand(10.0, StartDynamicConversation("prc_ccc_main", oPC, FALSE, FALSE, TRUE));
            // sets up the cutscene to the point in the convo at which the player logged out
            DelayCommand(11.0, DoCutscene(oPC, TRUE));
            // mark that stage 1 of the cutscene is set up
            SetLocalInt(oPC, "CutsceneStage", 1);
            SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
        }
        /* returning character */
        else if (nPCStatus == CONVOCC_ENTER_RETURNING_PC)
        {
            // if using XP or your own script for new characters, this sets returning characters' tags 
            // to encrypted then you can turn off using XP after all characters have logged on.
            if((GetPRCSwitch(PRC_CONVOCC_USE_XP_FOR_NEW_CHAR) || GetPRCSwitch(PRC_CONVOCC_CUSTOM_ENTER_SCRIPT))
                && GetTag(oPC) != sEncrypt
                && GetXP(oPC) > 0)
            {
                string sScript = LetoSet("Tag", sEncrypt, "string");
                SetLocalString(oPC, "LetoScript", GetLocalString(oPC, "LetoScript")+sScript);
            }
            SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
        }
        else /* ooops - should never get here */
        {
            if (DEBUG) { DoDebug("Error: invalid value for var nPCStatus");}
            // kick just in case
            SetLocalString(oPC, "CONVOCC_ENTER_BOOT_MESSAGE", "Error:I'm confused.");
            CheckAndBootNicely(oPC);
            return;
        }
    }
    else // in convo
    {
        /* dynamic convo from here*/
        // double check it's a PC
        if(!GetIsPC(oPC) || GetIsDM(oPC) || !GetPRCSwitch(PRC_CONVOCC_ENABLE))
            return;
        // The stage is used to determine the active conversation node.
        // 0 is the entry node.
        int nStage = GetStage(oPC);
        /* Get the value of the local variable set by the conversation script calling
         * this script. Values:
         * DYNCONV_ABORTED     Conversation aborted
         * DYNCONV_EXITED      Conversation exited via the exit node
         * DYNCONV_SETUP_STAGE System's reply turn
         * 0                   The script was called by prc_onenter
         * Other               The user made a choice
         */
        int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
        
        if(DEBUG) DoDebug("prc_ccc running.\n"
                    + "oPC = " + DebugObject2Str(oPC) + "\n"
                    + "nValue = " + IntToString(nValue)
                      );
    
        // Check which of the conversation scripts called the scripts
        if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
            return;
    
        if(nValue == DYNCONV_SETUP_STAGE)
        {
            // Check if this stage is marked as already set up
            // This stops list duplication when scrolling
            if(!GetIsStageSetUp(nStage, oPC))
            {
                // variable named nStage determines the current conversation node
                // this function sets up the text displayed and the response options
                // for the current conversation node
                if(DEBUG)
                {
                    DoDebug("prc_ccc: Stage was not already set up");
                    DoDebug("Pass to DoHeaderAndChoices(): " + IntToString(nStage));
                }
                   // SpawnScriptDebugger();
                DoHeaderAndChoices(nStage);
                if(DEBUG) DoDebug("DoHeaderAndChoices() finished");
            }
    
            // Do token setup
            SetupTokens();
            if(DEBUG) ExecuteScript("prc_ccc_debug", oPC);
        }
        // End of conversation cleanup
        else if(nValue == DYNCONV_EXITED)
        {
            if(DEBUG) DoDebug("prc_ccc: Conversation exited");
            // cleanup is done in prc_ccc_make_pc
            // deletes local variables used to create the character
        }
        // Abort conversation cleanup.
        // NOTE: This section is only run when the conversation is aborted
        // while aborting is allowed. When it isn't, the dynconvo infrastructure
        // handles restoring the conversation in a transparent manner
        else if(nValue == DYNCONV_ABORTED)
        {
            // shouldn't reach this stage as aborting isn't allowed
            AssignCommand(oPC, DelayCommand(1.0, CheckAndBoot(oPC)));
        }
        // Handle PC responses
        else
        {
            // variable named nChoice is the value of the player's choice as stored when building the choice list
            // variable named nStage determines the current conversation node
            int nChoice = GetChoice(oPC);
            
            // check if the second stage of the cutscene needs setting up
            // note: this is an *ugly hack*
            // basically, if the player has made a choice, we know the area has fully loaded
            // so we can set up the camera facing here
            if (GetLocalInt(oPC, "CutsceneStage") == 1)
            {
                // do the camera stuff
                DoRotatingCamera(oPC);
                // mark that stage 2 of the cutscene is set up
                SetLocalInt(oPC, "CutsceneStage", 2);
            }
            
            // get nStage back so SetStage() actually changes the stage
            if(DEBUG) DoDebug("nStage before HandleChoice: " + IntToString(nStage));
            nStage = HandleChoice(nStage, nChoice);
            if(DEBUG) DoDebug("nStage after HandleChoice: " + IntToString(nStage));
    
            // Store the stage value. If it has been changed, this clears out the choices
            SetStage(nStage, oPC);
        }
    }
}
