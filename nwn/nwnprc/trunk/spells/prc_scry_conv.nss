//:://////////////////////////////////////////////
//:: Scry Conversation
//:: prc_scry_conv
//:://////////////////////////////////////////////
/** @file
    This lets you choose which creature or PC to target


    @author Stratovarius
    @date   Created  - 30.04.2007
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_dynconv"
#include "prc_inc_scry"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_CHOOSE_TARGET     = 0;
const int STAGE_CONFIRMATION      = 1;

//////////////////////////////////////////////////
/* Aid functions                                */
//////////////////////////////////////////////////
void StorePCForRecovery(object oPC, object oChoice, int nChoice)
{
    SetLocalObject(oPC, "ScryTarget" + IntToString(nChoice), oChoice);
}

object RetrievePC(object oPC, int nChoice)
{
    return GetLocalObject(oPC, "ScryTarget" + IntToString(nChoice));
}

void AddLegalTargets(object oPC)    
{    
    // This reads all of the legal choices    
    int nSpellId = GetLocalInt(oPC, "ScrySpellId");    
    int nChoice = 1;    
    int nDebugCounter = 0; // Add debug counter for frequency limiting    
        
    if (nSpellId == SPELL_LOCATE_OBJECT)    
    {    
        // First, get all objects in the area you're in    
        object oObject = GetFirstObjectInArea(GetArea(oPC));    
        while (GetIsObjectValid(oObject) == TRUE)    
        {    
            if(DEBUG && (++nDebugCounter % 10 == 0))    
                DoDebug("prc_scry_conv: Processed " + IntToString(nDebugCounter) + " objects");    
            // Don't target PCs using this    
            if (GetObjectType(oObject) == OBJECT_TYPE_PLACEABLE || GetObjectType(oObject) ==  OBJECT_TYPE_ITEM)    
            {    
                // Check if object's area blocks scrying  
                if(!GetLocalInt(GetArea(oObject), "SCRY_AREA_BLOCKED"))  
                {  
                    // If its a legal object, target it for locating    
                    AddChoice(GetName(oObject), nChoice, oPC);    
                    StorePCForRecovery(oPC, oObject, nChoice);    
                }  
            }    
            nChoice += 1;    
            oObject = GetNextObjectInArea(GetArea(oPC));    
        }    
    }    
    else    
    {    
        // First, get all creatures in the area you're in    
        object oCreature = GetFirstObjectInArea(GetArea(oPC));    
        while (GetIsObjectValid(oCreature) == TRUE)    
        {    
            if(DEBUG && (++nDebugCounter % 10 == 0))    
                DoDebug("prc_scry_conv: Processed " + IntToString(nDebugCounter) + " creatures");    
            // Don't target PCs using this    
            if (GetObjectType(oCreature) == OBJECT_TYPE_CREATURE)    
            {    
                // Check if creature's area blocks scrying  
                if(!GetLocalInt(GetArea(oCreature), "SCRY_AREA_BLOCKED"))  
                {  
                    // This can target PCs in the area, but not in other areas    
                    if ((nSpellId == SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE ||    
                         nSpellId == SPELL_LOCATE_CREATURE ||    
                         nSpellId == MYST_TRAIL_OF_HAZE ||    
                         nSpellId == POWER_CLAIRVOYANT_SENSE) &&    
                         oPC != oCreature &&    
                         !GetIsDM(oCreature))    
                    {    
                        AddChoice(GetName(oCreature), nChoice, oPC);    
                        StorePCForRecovery(oPC, oCreature, nChoice);    
                    }    
                    // Normally, the second part takes care of all PCs    
                    else if ((!GetIsPC(oCreature) && !GetIsDM(oCreature)))    
                    {    
                        AddChoice(GetName(oCreature), nChoice, oPC);    
                        StorePCForRecovery(oPC, oCreature, nChoice);    
                    }    
                }  
            }    
            nChoice += 1;    
            oCreature = GetNextObjectInArea(GetArea(oPC));    
        }    
        // These only target in their own areas    
        if (nSpellId != SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE &&    
            nSpellId != SPELL_LOCATE_CREATURE &&    
            nSpellId != MYST_TRAIL_OF_HAZE &&    
            nSpellId != POWER_CLAIRVOYANT_SENSE)    
        {    
            // Now, loop through all of the PCs    
            object oPCTarget = GetFirstPC();    
            // Don't target yourself    
            while (GetIsObjectValid(oPCTarget))    
            {    
                if(oPCTarget != oPC && !GetIsDM(oPCTarget))    
                {    
                    if(DEBUG && (++nDebugCounter % 10 == 0))    
                        DoDebug("prc_scry_conv: Processed " + IntToString(nDebugCounter) + " PC targets");    
                      
                    // Check if PC's area blocks scrying  
                    if(!GetLocalInt(GetArea(oPCTarget), "SCRY_AREA_BLOCKED"))  
                    {  
                        AddChoice(GetName(oPCTarget), nChoice, oPC);    
                        StorePCForRecovery(oPC, oPCTarget, nChoice);    
                    }  
    
                    nChoice += 1;    
                }    
                oPCTarget = GetNextPC();    
            }    
        }    
    }    
}

/* void AddLegalTargets(object oPC)  
{  
    // This reads all of the legal choices  
    int nSpellId = GetLocalInt(oPC, "ScrySpellId");  
    int nChoice = 1;  
    int nDebugCounter = 0; // Add debug counter for frequency limiting  
      
    if (nSpellId == SPELL_LOCATE_OBJECT)  
    {  
        // First, get all objects in the area you're in  
        object oObject = GetFirstObjectInArea(GetArea(oPC));  
        while (GetIsObjectValid(oObject) == TRUE)  
        {  
            if(DEBUG && (++nDebugCounter % 10 == 0))  
                DoDebug("prc_scry_conv: Processed " + IntToString(nDebugCounter) + " objects");  
            // Don't target PCs using this  
            if (GetObjectType(oObject) == OBJECT_TYPE_PLACEABLE || GetObjectType(oObject) ==  OBJECT_TYPE_ITEM)  
            {  
                // If its a legal object, target it for locating  
                AddChoice(GetName(oObject), nChoice, oPC);  
                StorePCForRecovery(oPC, oObject, nChoice);  
            }  
            nChoice += 1;  
            oObject = GetNextObjectInArea(GetArea(oPC));  
        }  
    }  
    else  
    {  
        // First, get all creatures in the area you're in  
        object oCreature = GetFirstObjectInArea(GetArea(oPC));  
        while (GetIsObjectValid(oCreature) == TRUE)  
        {  
            if(DEBUG && (++nDebugCounter % 10 == 0))  
                DoDebug("prc_scry_conv: Processed " + IntToString(nDebugCounter) + " creatures");  
            // Don't target PCs using this  
            if (GetObjectType(oCreature) == OBJECT_TYPE_CREATURE)  
            {  
                // This can target PCs in the area, but not in other areas  
                if ((nSpellId == SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE ||  
                     nSpellId == SPELL_LOCATE_CREATURE ||  
                     nSpellId == MYST_TRAIL_OF_HAZE ||  
                     nSpellId == POWER_CLAIRVOYANT_SENSE) &&  
                     oPC != oCreature &&  
                     !GetIsDM(oCreature))  
                {  
                    AddChoice(GetName(oCreature), nChoice, oPC);  
                    StorePCForRecovery(oPC, oCreature, nChoice);  
                }  
                // Normally, the second part takes care of all PCs  
                else if ((!GetIsPC(oCreature) && !GetIsDM(oCreature)))  
                {  
                    AddChoice(GetName(oCreature), nChoice, oPC);  
                    StorePCForRecovery(oPC, oCreature, nChoice);  
                }  
            }  
            nChoice += 1;  
            oCreature = GetNextObjectInArea(GetArea(oPC));  
        }  
        // These only target in their own areas  
        if (nSpellId != SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE &&  
            nSpellId != SPELL_LOCATE_CREATURE &&  
            nSpellId != MYST_TRAIL_OF_HAZE &&  
            nSpellId != POWER_CLAIRVOYANT_SENSE)  
        {  
            // Now, loop through all of the PCs  
            object oPCTarget = GetFirstPC();  
            // Don't target yourself  
            while (GetIsObjectValid(oPCTarget))  
            {  
                if(oPCTarget != oPC && !GetIsDM(oPCTarget))  
                {  
                    if(DEBUG && (++nDebugCounter % 10 == 0))  
                        DoDebug("prc_scry_conv: Processed " + IntToString(nDebugCounter) + " PC targets");  
                    AddChoice(GetName(oPCTarget), nChoice, oPC);  
                    StorePCForRecovery(oPC, oPCTarget, nChoice);  
  
                    nChoice += 1;  
                }  
                oPCTarget = GetNextPC();  
            }  
        }  
    }  
}
 */
/* void AddLegalTargets(object oPC)
{
    // This reads all of the legal choices
    int nSpellId = GetLocalInt(oPC, "ScrySpellId");
    int nChoice = 1;
    if (nSpellId == SPELL_LOCATE_OBJECT)
    {
        // First, get all objects in the area you're in
        object oObject = GetFirstObjectInArea(GetArea(oPC));
        while (GetIsObjectValid(oObject) == TRUE)
        {
            if(DEBUG) DoDebug("prc_scry_conv: Looping Object Targets");
            // Don't target PCs using this
            if (GetObjectType(oObject) == OBJECT_TYPE_PLACEABLE || GetObjectType(oObject) ==  OBJECT_TYPE_ITEM)
            {
                // If its a legal object, target it for locating
                AddChoice(GetName(oObject), nChoice, oPC);
                StorePCForRecovery(oPC, oObject, nChoice);
            }
            nChoice += 1;
            oObject = GetNextObjectInArea(GetArea(oPC));
        }
    }
    else
    {
        // First, get all creatures in the area you're in
        object oCreature = GetFirstObjectInArea(GetArea(oPC));
        while (GetIsObjectValid(oCreature) == TRUE)
        {
            if(DEBUG) DoDebug("prc_scry_conv: Looping Monster Targets");
            // Don't target PCs using this
            if (GetObjectType(oCreature) == OBJECT_TYPE_CREATURE)
            {
                // This can target PCs in the area, but not in other areas
                if ((nSpellId == SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE ||
                     nSpellId == SPELL_LOCATE_CREATURE ||
                     nSpellId == MYST_TRAIL_OF_HAZE ||
                     nSpellId == POWER_CLAIRVOYANT_SENSE) &&
                     oPC != oCreature &&
                     !GetIsDM(oCreature))
                {
                    AddChoice(GetName(oCreature), nChoice, oPC);
                    StorePCForRecovery(oPC, oCreature, nChoice);
                }
                // Normally, the second part takes care of all PCs
                else if ((!GetIsPC(oCreature) && !GetIsDM(oCreature)))
                {
                    AddChoice(GetName(oCreature), nChoice, oPC);
                    StorePCForRecovery(oPC, oCreature, nChoice);
                }
            }
            nChoice += 1;
            oCreature = GetNextObjectInArea(GetArea(oPC));
        }
        // These only target in their own areas
        if (nSpellId != SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE &&
            nSpellId != SPELL_LOCATE_CREATURE &&
            nSpellId != MYST_TRAIL_OF_HAZE &&
            nSpellId != POWER_CLAIRVOYANT_SENSE)
        {
            // Now, loop through all of the PCs
            object oPCTarget = GetFirstPC();
            // Don't target yourself
            while (GetIsObjectValid(oPCTarget))
            {
                if(oPCTarget != oPC && !GetIsDM(oPCTarget))
                {
                    if(DEBUG) DoDebug("prc_scry_conv: Looping PC Targets");
                    AddChoice(GetName(oPCTarget), nChoice, oPC);
                    StorePCForRecovery(oPC, oPCTarget, nChoice);

                    nChoice += 1;
                }
                oPCTarget = GetNextPC();
            }
        }
    }
}
 */
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
        if(nStage == STAGE_CHOOSE_TARGET)
            {
                // Set the header
                string sAmount = "Which creature would you like to scry?";
                SetHeader(sAmount);

        AddLegalTargets(oPC);

                MarkStageSetUp(STAGE_CHOOSE_TARGET, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_CONFIRMATION)//confirmation
            {
                object oChoice = RetrievePC(oPC, GetLocalInt(oPC, "ScryChoice"));
                AddChoice(GetStringByStrRef(4752), TRUE); // "Yes"
                AddChoice(GetStringByStrRef(4753), FALSE); // "No"

                string sText = "You have selected " + GetName(oChoice) + " as the creature to scry.\n";
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
        DeleteLocalObject(oPC, "ScryTarget" + IntToString(GetLocalInt(oPC, "ScryChoice")));
        DeleteLocalInt(oPC, "ScryChoice");
    }
    // Abort conversation cleanup.
    // NOTE: This section is only run when the conversation is aborted
    // while aborting is allowed. When it isn't, the dynconvo infrastructure
    // handles restoring the conversation in a transparent manner
    else if(nValue == DYNCONV_ABORTED)
    {
        // End of conversation cleanup
        DeleteLocalObject(oPC, "ScryTarget" + IntToString(GetLocalInt(oPC, "ScryChoice")));
        DeleteLocalInt(oPC, "ScryChoice");
    }
    // Handle PC responses
    else
    {
        // variable named nChoice is the value of the player's choice as stored when building the choice list
        // variable named nStage determines the current conversation node
        int nChoice = GetChoice(oPC);
        if(nStage == STAGE_CHOOSE_TARGET)
        {
            SetLocalInt(oPC, "ScryChoice", nChoice);
                nStage = STAGE_CONFIRMATION;
        }
        else if(nStage == STAGE_CONFIRMATION)//confirmation
        {
            // Scry and Exit
            if(nChoice == TRUE)
            {
                object oChoice = RetrievePC(oPC, GetLocalInt(oPC, "ScryChoice"));
                
                // This is only used by See the Named, otherwise it should fail to fire.
                if(GetLocalInt(oPC, "SeeTheNamed"))
                {
                	int nDC = 15 + (2 * FloatToInt(GetChallengeRating(oChoice)));
                	if (GetIsSkillSuccessful(oPC, SKILL_TRUESPEAK, nDC))
                	{	// The function will take it from here
                		ScryMain(oPC, oChoice);

                	}
                	else // Clean up effects
                	{
                		PRCRemoveSpellEffects(TRUE_SEE_THE_NAMED, oPC, oPC);
                	}
                }
                else 
                {
                	// The function will take it from here
                	ScryMain(oPC, oChoice);

                }

                // And we're all done
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);

            }
            else
            {
                nStage = STAGE_CHOOSE_TARGET;
                MarkStageNotSetUp(STAGE_CHOOSE_TARGET, oPC);
                MarkStageNotSetUp(STAGE_CONFIRMATION, oPC);
            }
            DeleteLocalObject(oPC, "ScryTarget" + IntToString(GetLocalInt(oPC, "ScryChoice")));
            DeleteLocalInt(oPC, "ScryChoice");
        }

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
