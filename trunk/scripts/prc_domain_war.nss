//:://////////////////////////////////////////////
//:: War Domain Conversation
//:: prc_domain_war
//:://////////////////////////////////////////////
/** @file
    This allows you to choose the weapon for the diety


    @author Stratovarius
    @date   Created  - 29.10.2005
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"
#include "prc_inc_wpnrest"

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
                string sHeader1 = "Select your Deity's favoured weapon.\n";
                sHeader1 += "This will grant you proficiency and weapon focus in that weapon.";
                // Set the header
                SetHeader(sHeader1);
                // Add responses for the PC

                // This reads all of the legal choices from baseitems.2da
                int i;
                for(i = 0; i < GetPRCSwitch(FILE_END_BASEITEMS); i++) //Total rows in baseitems.2da
                {
                    // If the selection is a legal weapon
                    if (StringToInt(Get2DACache("baseitems", "WeaponType", i)) > 0)
                    {
                        // If the selection is a martial weapon
                        // Everything that needs Martial weapon pro has it in this column
                        if(IsWeaponMartial(i, oPC))
                        {
                            string sWeaponName = GetStringByStrRef(StringToInt(Get2DACache("baseitems", "Name", i)));
                            // Just in case its a blank entry, don't put it here
                            if (sWeaponName != "")
                            {
                                AddChoice(sWeaponName, i, oPC);
                            }
                        }
                    }
                }

                MarkStageSetUp(STAGE_WEAPON_CHOICE, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_CONFIRMATION)//confirmation
            {
                int nChoice = GetLocalInt(oPC, "WarDomainWeapon");
                AddChoice(GetStringByStrRef(4752), TRUE); // "Yes"
                AddChoice(GetStringByStrRef(4753), FALSE); // "No"

                string sName = GetStringByStrRef(StringToInt(Get2DACache("baseitems", "Name", nChoice)));
                string sText = "You have selected " + sName + " as your deity's chosen weapon.\n";
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
        DeleteLocalInt(oPC, "WarDomainWeapon");
    }
    // Abort conversation cleanup.
    // NOTE: This section is only run when the conversation is aborted
    // while aborting is allowed. When it isn't, the dynconvo infrastructure
    // handles restoring the conversation in a transparent manner
    else if(nValue == DYNCONV_ABORTED)
    {
        // End of conversation cleanup
        DeleteLocalInt(oPC, "WarDomainWeapon");
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
            SetLocalInt(oPC, "WarDomainWeapon", nChoice);
        }
        else if(nStage == STAGE_CONFIRMATION)//confirmation
        {
            if(nChoice == TRUE)
            {
                object oSkin = GetPCSkin(oPC);
                int nWeapon = GetLocalInt(oPC, "WarDomainWeapon");
                int nWeaponFocus = GetFeatOfWeaponType(nWeapon, FEAT_TYPE_FOCUS);
                int nWFIprop = FeatToIprop(nWeaponFocus);

                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(nWFIprop), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_MARTIAL), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

                // Store the weapon feat for later reuse
                // The reason we use the feat and not the iprop constant is so we can check using GetHasFeat whether to reapply
                SetPersistantLocalInt(oPC, "WarDomainWeaponPersistent", nWeaponFocus);

                // And we're all done
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);
            }
            else
            {
                nStage = STAGE_WEAPON_CHOICE;
                MarkStageNotSetUp(STAGE_WEAPON_CHOICE, oPC);
                MarkStageNotSetUp(STAGE_CONFIRMATION, oPC);
            }

            DeleteLocalInt(oPC, "WarDomainWeapon");
        }

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
