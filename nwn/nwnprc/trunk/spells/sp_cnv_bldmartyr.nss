//:://////////////////////////////////////////////
//:: Blood of the Martyr Conversation
//:: sp_cnv_bldmartyr
//:://////////////////////////////////////////////
/** @file
    This lets you drain your HP to heal the target


    @author Stratovarius
    @date   Created  - 26.2.2006
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "inc_dynconv"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_HEAL_AMOUNT       = 0;
const int STAGE_CONFIRMATION      = 1;

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
	    if(nStage == STAGE_HEAL_AMOUNT)//Stat to burn
            {
               	// Set the header
               	string sAmount = "How much would you like to heal your ally by?\n";
               	sAmount += "The minimum you can heal your ally is 20.\n";
               	sAmount += "You cannot heal more than your current hitpoint total.\n";
               	sAmount += "Your current value is " + IntToString(GetLocalInt(oPC, "BloodMartyrAmount"));
                SetHeader(sAmount);

                AddChoice("Add 1", 1);
                AddChoice("Add 5", 5);
                AddChoice("Add 10", 10);
                AddChoice("Subtract 1", -1);
		AddChoice("Subtract 5", -5);
                AddChoice("Subtract 10", -10);
                AddChoice("Finished", 666);

                MarkStageSetUp(STAGE_HEAL_AMOUNT, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_CONFIRMATION)//confirmation
            {
                int nAmount = GetLocalInt(oPC, "BloodMartyrAmount");
                AddChoice(GetStringByStrRef(4752), TRUE); // "Yes"
                AddChoice(GetStringByStrRef(4753), FALSE); // "No"

                string sText = "You have selected " + IntToString(nAmount) + " as the value to heal.\n";
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
        DeleteLocalInt(oPC, "BloodMartyrAmount");
        DeleteLocalObject(oPC, "BloodMartyrTarget");
    }
    // Abort conversation cleanup.
    // NOTE: This section is only run when the conversation is aborted
    // while aborting is allowed. When it isn't, the dynconvo infrastructure
    // handles restoring the conversation in a transparent manner
    else if(nValue == DYNCONV_ABORTED)
    {
        // End of conversation cleanup
        DeleteLocalInt(oPC, "BloodMartyrAmount");
        DeleteLocalObject(oPC, "BloodMartyrTarget");
    }
    // Handle PC responses
    else
    {
        // variable named nChoice is the value of the player's choice as stored when building the choice list
        // variable named nStage determines the current conversation node
        int nChoice = GetChoice(oPC);
        if(nStage == STAGE_HEAL_AMOUNT)
        {
            // Exit value for this stage
            if (nChoice == 666)
            {
            	nStage = STAGE_CONFIRMATION;
            }
            else
            {
            	int nPFAmount = GetLocalInt(oPC, "BloodMartyrAmount");
            	SetLocalInt(oPC, "BloodMartyrAmount", (nPFAmount + nChoice));
            	nStage = STAGE_HEAL_AMOUNT;
            }
        }
        else if(nStage == STAGE_CONFIRMATION)//confirmation
        {
            // No point in letting them finish if they haven't healed anything
            // Or if they try to exit without healing for at least 20
            if(nChoice == TRUE && GetLocalInt(oPC, "BloodMartyrAmount") >= 20)
            {
            	int nAmount = GetLocalInt(oPC, "BloodMartyrAmount");
            	if (nAmount > GetCurrentHitPoints(oPC)) nAmount = GetCurrentHitPoints(oPC);
            	
            	object oTarget = GetLocalObject(oPC, "BloodMartyrTarget");
		effect eHeal = PRCEffectHeal(nAmount, oTarget);
		effect eDam = PRCEffectDamage(oTarget, nAmount);
    		effect eVis = EffectVisualEffect(VFX_IMP_HEALING_X);
    		effect eVis2 = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    		effect eLinkHeal = EffectLinkEffects(eHeal, eVis);
    		effect eLinkHarm = EffectLinkEffects(eDam, eVis2);

		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLinkHeal, oTarget);
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLinkHarm, oPC);

                // And we're all done
               	AllowExit(DYNCONV_EXIT_FORCE_EXIT);

            }
            else
            {
                nStage = STAGE_HEAL_AMOUNT;
                MarkStageNotSetUp(STAGE_HEAL_AMOUNT, oPC);
                MarkStageNotSetUp(STAGE_CONFIRMATION, oPC);
            }

            DeleteLocalInt(oPC, "BloodMartyrAmount");
            DeleteLocalObject(oPC, "BloodMartyrTarget");
        }

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
