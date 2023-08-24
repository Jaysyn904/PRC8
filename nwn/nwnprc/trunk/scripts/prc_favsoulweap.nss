//:://////////////////////////////////////////////
//:: Favoured Soul Weapon Conversation
//:: prc_favsoulweap
//:://////////////////////////////////////////////
/** @file
    This allows you to choose the weapon for the diety


    @author Stratovarius
    @date   Created  - 29.10.2005
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_fork"
#include "inc_item_props"
#include "prc_x2_itemprop"
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
                string sHeader1 = "Select your Deity's favoured weapon.\n";
                sHeader1 += "This will grant you weapon focus and, eventually, weapon specialization in that weapon.";
                // Set the header
                SetHeader(sHeader1);
                // Add responses for the PC

                // This reads all of the legal choices from baseitems.2da
                int i;
        	for(i = 0; i < 112; i++) //Total rows in baseitems.2da
        	{
            		// If the selection is a legal weapon
            		if (StringToInt(Get2DACache("baseitems", "WeaponType", i)) > 0)
            		{
                		string sWeaponName = GetStringByStrRef(StringToInt(Get2DACache("baseitems", "Name", i)));
                		// Just in case its a blank entry, don't put it here
                		if (sWeaponName != "")
                		{
                		    AddChoice(sWeaponName, i, oPC);
                		}
            		}
                }

                MarkStageSetUp(STAGE_WEAPON_CHOICE, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_CONFIRMATION)//confirmation
            {
                int nChoice = GetLocalInt(oPC, "FavouredSoulWeapon");
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
        DeleteLocalInt(oPC, "FavouredSoulWeapon");
    }
    // Abort conversation cleanup.
    // NOTE: This section is only run when the conversation is aborted
    // while aborting is allowed. When it isn't, the dynconvo infrastructure
    // handles restoring the conversation in a transparent manner
    else if(nValue == DYNCONV_ABORTED)
    {
        // End of conversation cleanup
        DeleteLocalInt(oPC, "FavouredSoulWeapon");
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
            SetLocalInt(oPC, "FavouredSoulWeapon", nChoice);
        }
        else if(nStage == STAGE_CONFIRMATION)//confirmation
        {
            if(nChoice == TRUE)
            {
                object oSkin = GetPCSkin(oPC);
                int nWeapon = GetLocalInt(oPC, "FavouredSoulWeapon");
        int nWeaponFocus = GetFeatOfWeaponType(nWeapon, FEAT_TYPE_FOCUS);
        int nWFIprop = FeatToIprop(nWeaponFocus);
        int nWeaponSpec = GetFeatOfWeaponType(nWeapon, FEAT_TYPE_SPECIALIZATION);
        int nWSIprop = FeatToIprop(nWeaponSpec);

        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(nWFIprop), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        if (GetLevelByClass(CLASS_TYPE_FAVOURED_SOUL, oPC) >= 12) IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(nWSIprop), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

        // Store the weapon for later reuse
        // The reason we use the weapon is so we can use the GetFeatByWeaponType function to get both Focus and Spec
        SetPersistantLocalInt(oPC, "FavouredSoulDietyWeapon", nWeapon);

                // And we're all done
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);
            }
            else
            {
                nStage = STAGE_WEAPON_CHOICE;
                MarkStageNotSetUp(STAGE_WEAPON_CHOICE, oPC);
                MarkStageNotSetUp(STAGE_CONFIRMATION, oPC);
            }

            DeleteLocalInt(oPC, "FavouredSoulWeapon");
        }

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
