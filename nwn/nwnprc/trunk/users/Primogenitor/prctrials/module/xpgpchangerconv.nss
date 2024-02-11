//:://////////////////////////////////////////////
//:: Short description
//:: filename
//:://////////////////////////////////////////////
/** @file
    Long description


    @author Joe Random
    @date   Created  - yyyy.mm.dd
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_dynconv"
#include "inc_ecl"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_TYPE = 0;
const int STAGE_LEVEL = 1;
const int STAGE_CONFIRM = 2;


//////////////////////////////////////////////////
/* Aid functions                                */
//////////////////////////////////////////////////



//////////////////////////////////////////////////
/* Main function                                */
//////////////////////////////////////////////////

void main()
{
    object oPC = GetPCSpeaker();
    /* Get the value of the local variable set by the conversation script calling
     * this script. Values:
     * DYNCONV_ABORTED     Conversation aborted
     * DYNCONV_EXITED      Conversation exited via the exit node
     * DYNCONV_SETUP_STAGE System's reply turn
     * 0                   Error - something else called the script
     * Other               The user made a choice
     */
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
    // The stage is used to determine the active conversation node.
    // 0 is the entry node.
    int nStage = GetStage(oPC);

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
        return;

    if(nValue == DYNCONV_SETUP_STAGE)
    {
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oPC))
        {
            if(nStage == STAGE_TYPE)
            {
                SetHeader("What do you want to change?");
                AddChoice("XP and GP", 1, oPC);
                AddChoice("GP", 2, oPC);
                AddChoice("XP", 3, oPC);
                MarkStageSetUp(nStage, oPC); 
                SetDefaultTokens();
            }
            else if(nStage == STAGE_LEVEL)
            {
                SetHeader("What level do you want to go to?");
                int i;
                for(i=1;i<=40;i++)
                {
                    AddChoice("Level "+IntToString(i), i, oPC);
                }
                MarkStageSetUp(nStage, oPC); 
                SetDefaultTokens();
            }
            else if(nStage == STAGE_CONFIRM)
            {
                int nLevel = GetLocalInt(OBJECT_SELF, "xpgplevel");
                int nType = GetLocalInt(OBJECT_SELF, "xpgptype");
                string sHeader;
                sHeader = "You have selected ";
                switch(nType)
                {
                    default:
                    case 1: sHeader += "Experience and Gold"; break;
                    case 2: sHeader += "Gold"; break;
                    case 3: sHeader += "Experience"; break;
                }
                sHeader += ".\n";
                sHeader += "You have selected level "+IntToString(nLevel)+".\n";
                sHeader += "Is this correct?";
                SetHeader(sHeader);
                AddChoice("Yes", 1, oPC);
                AddChoice("No", 2, oPC);
                MarkStageSetUp(nStage, oPC); 
                SetDefaultTokens();
            }
        }

        // Do token setup
        SetupTokens();
    }
    // End of conversation cleanup
    else if(nValue == DYNCONV_EXITED)
    {
        DeleteLocalInt(OBJECT_SELF, "xpgplevel");
        DeleteLocalInt(OBJECT_SELF, "xpgptype");
    }
    // Abort conversation cleanup.
    // NOTE: This section is only run when the conversation is aborted
    // while aborting is allowed. When it isn't, the dynconvo infrastructure
    // handles restoring the conversation in a transparent manner
    else if(nValue == DYNCONV_ABORTED)
    {
        DeleteLocalInt(OBJECT_SELF, "xpgplevel");
        DeleteLocalInt(OBJECT_SELF, "xpgptype");
    }
    // Handle PC responses
    else
    {
        // variable named nChoice is the value of the player's choice as stored when building the choice list
        // variable named nStage determines the current conversation node
        int nChoice = GetChoice(oPC);
        if(nStage == STAGE_TYPE)
        {
            SetLocalInt(OBJECT_SELF, "xpgptype", nChoice);
            nStage = STAGE_LEVEL;
        }
        else if(nStage == STAGE_LEVEL)
        {
            SetLocalInt(OBJECT_SELF, "xpgplevel", nChoice);
            nStage = STAGE_CONFIRM;
        }
        else if(nStage == STAGE_CONFIRM)
        {   
            if(nChoice == 1)
            {
                int nLevel = GetLocalInt(OBJECT_SELF, "xpgplevel");
                int nType = GetLocalInt(OBJECT_SELF, "xpgptype");
                int nGold = GetGold(oPC);
                int nTargetGold = StringToInt(Get2DACache("itemvalue", "MAXSINGLEITEMVALUE", nLevel-1))*10;
                switch(nType)
                {
                    default:
                    case 1:
                        SetXP(oPC, nLevel*(nLevel-1)*500);
                        SetPersistantLocalInt(oPC, sXP_AT_LAST_HEARTBEAT, nLevel*(nLevel-1)*500);
                        GiveGoldToCreature(oPC, nTargetGold-nGold);
                        break;
                    case 2:
                        GiveGoldToCreature(oPC, nTargetGold-nGold);
                        break;    
                    case 3:
                        SetXP(oPC, nLevel*(nLevel-1)*500);
                        SetPersistantLocalInt(oPC, sXP_AT_LAST_HEARTBEAT, nLevel*(nLevel-1)*500);
                        break;
                }    
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);            
            }
            else
                nStage = STAGE_TYPE;
        }

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
