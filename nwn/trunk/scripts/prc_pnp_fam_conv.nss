//:://////////////////////////////////////////////
//:: Short description
//:: prc_pnp_fam_conv
//:://////////////////////////////////////////////
/** @file
    @todo Primo: Could you fill in the file comments
                 and TLKify?


    @author Primogenitor
    @date   Created  - yyyy.mm.dd
    @date   Modified - 2005.09.24 - Adapted to new
            DynConvo system - Ornedan
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"
#include "inc_persist_loca"
#include "prc_inc_switch"
#include "inc_2dacache"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_ENTRY  = 0;
const int STAGE_SUMMON = 1;


//////////////////////////////////////////////////
/* Aid functions                                */
//////////////////////////////////////////////////



//////////////////////////////////////////////////
/* Main function                                */
//////////////////////////////////////////////////

void main()
{
    object oPC = GetPCSpeaker();
    int bPnP = GetPRCSwitch(PRC_PNP_FAMILIARS);
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
            if(nStage == STAGE_ENTRY)
            {
                if(bPnP)
                {
                    SetHeader("Please select a familiar.\nAll familiars will cost 100GP to summon.");

                    int i;
                    string sName;
                    for(i = 0; i < 30; i++)
                    {
                        if(Get2DACache("prc_familiar", "BASERESREF", i) != "")
                        {
                            sName = GetStringByStrRef(StringToInt(Get2DACache("prc_familiar", "STRREF", i)));
                            if(sName == "")
                                sName = Get2DACache("prc_familiar", "NAME", i);
                            AddChoice(sName, i, oPC);
                        }
                    }
                }
                else
                {
                    SetHeader("Please select a familiar.");

                    int i;
                    string sName;
                    for(i = 0; i < 30; i++)
                    {
                        if(Get2DACache("hen_familiar", "BASERESREF", i) != "")
                        {
                            sName = GetStringByStrRef(StringToInt(Get2DACache("hen_familiar", "STRREF", i)));
                            if(sName == "")
                                sName = Get2DACache("hen_familiar", "NAME", i);
                            AddChoice(sName, i, oPC);
                        }
                    }
                }

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_SUMMON)
            {
                SetHeader("Familiar selected. Use the feat again to summon your familiar.");
            }
        }

        // Do token setup
        SetupTokens();
        SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
    }
    else if(nValue == DYNCONV_EXITED)
    {
        // End of conversation cleanup
    }
    else if(nValue == DYNCONV_ABORTED)
    {
        // Abort conversation cleanup
    }
    else
    {
        int nChoice = GetChoice(oPC);
        if(nStage == STAGE_ENTRY)
        {
            nStage = STAGE_SUMMON;
            if(bPnP && GetGold(oPC) >= 100)
            {
                SetPersistantLocalInt(oPC, "PnPFamiliarType", nChoice);
                // Take 100 gold - the cost of obtaining a familiar as per PnP
                TakeGoldFromCreature(100, oPC, TRUE);
                //ExecuteScript("nw_s2_familiar", oPC);
            }
            else if(bPnP)
                FloatingTextStringOnCreature("You don't have enough gold to summon familiar.", oPC, FALSE);
            if(!bPnP)
            {
                nChoice++;
                SetPersistantLocalInt(oPC, "FamiliarType", nChoice);
                //ExecuteScript("nw_s2_familiar", oPC);
            }
        }
        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}