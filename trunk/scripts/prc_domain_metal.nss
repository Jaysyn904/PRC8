//:://////////////////////////////////////////////
//:: Metal Domain Conversation
//:: prc_domain_metal
//:://////////////////////////////////////////////
/** @file
    This allows you to choose weapon focus in a hammer


    @author Stratovarius
    @date   Created  - 29.10.2005
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_wpnrest"
//#include "prc_inc_fork" // for GetFeatByWeaponType()
#include "inc_dynconv"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_WEAPON_CHOICE = 0;
const int STAGE_CONFIRMATION  = 1;

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
            // variable named nStage determines the current conversation node
            // Function SetHeader to set the text displayed to the PC
            // Function AddChoice to add a response option for the PC. The responses are show in order added
            if(nStage == STAGE_WEAPON_CHOICE)
            {
                string sHeader1 = "You may choose one hammer.\n";
                sHeader1 += "This will grant you proficiency and weapon focus in that weapon.";
                // Set the header
                SetHeader(sHeader1);
                // Add responses for the PC
        // Response numbers are baseitems.2da row
        AddChoice("Warhammer", 5, oPC);
        AddChoice("Light Hammer", 37, oPC);

                MarkStageSetUp(STAGE_WEAPON_CHOICE, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_CONFIRMATION)//confirmation
            {
                int nChoice = GetLocalInt(oPC, "MetalDomainWeapon");
                AddChoice(GetStringByStrRef(4752), TRUE); // "Yes"
                AddChoice(GetStringByStrRef(4753), FALSE); // "No"

                string sName = GetStringByStrRef(StringToInt(Get2DACache("baseitems", "Name", nChoice)));
                string sText = "You have selected " + sName + " as your chosen hammer.\n";
                sText += "Is this correct?";

                SetHeader(sText);
                MarkStageSetUp(STAGE_CONFIRMATION, oPC);
            }
        }

        // Do token setup
        SetupTokens();
    }
    // End of conversation cleanup
    else if(nValue == DYNCONV_EXITED)
    {
        // End of conversation cleanup
        DeleteLocalInt(oPC, "MetalDomainWeapon");
    }
    // Abort conversation cleanup.
    // NOTE: This section is only run when the conversation is aborted
    // while aborting is allowed. When it isn't, the dynconvo infrastructure
    // handles restoring the conversation in a transparent manner
    else if(nValue == DYNCONV_ABORTED)
    {
        // End of conversation cleanup
        DeleteLocalInt(oPC, "MetalDomainWeapon");
    }
    // Handle PC responses
    else
    {
        // variable named nChoice is the value of the player's choice as stored when building the choice list
        // variable named nStage determines the current conversation node
        int nChoice = GetChoice(oPC);
        if(nStage == STAGE_WEAPON_CHOICE)
        {
            // Go to this stage next
            nStage = STAGE_CONFIRMATION;
            SetLocalInt(oPC, "MetalDomainWeapon", nChoice);
        }
        else if(nStage == STAGE_CONFIRMATION)//confirmation
        {
            if(nChoice == TRUE)
            {
                object oSkin = GetPCSkin(oPC);
                int nWeapon = GetLocalInt(oPC, "MetalDomainWeapon");
        int nWeaponFocus = GetFeatOfWeaponType(nWeapon, FEAT_TYPE_FOCUS);
        int nWFIprop = FeatToIprop(nWeaponFocus);

        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(nWFIprop), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_MARTIAL), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

        // Store the weapon feat for later reuse
        // The reason we use the feat and not the iprop constant is so we can check using GetHasFeat whether to reapply
        SetPersistantLocalInt(oPC, "MetalDomainWeaponPersistent", nWeaponFocus);

                // And we're all done
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);
            }
            else
            {
                nStage = STAGE_WEAPON_CHOICE;
                MarkStageNotSetUp(STAGE_WEAPON_CHOICE, oPC);
                MarkStageNotSetUp(STAGE_CONFIRMATION, oPC);
            }

            DeleteLocalInt(oPC, "MetalDomainWeapon");
        }

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
