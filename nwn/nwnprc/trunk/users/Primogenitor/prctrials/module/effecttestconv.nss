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

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_ENTRY                   =  0;
const int STAGE_BIOWARE_VISUAL_EFFECT   = 10;
const int STAGE_SHADEGUY_SCRIPT_EFFECT  = 20;
const int STAGE_GAONENG_SCRIPT_EFFECT   = 30;


//////////////////////////////////////////////////
/* Aid functions                                */
//////////////////////////////////////////////////



//////////////////////////////////////////////////
/* Main function                                */
//////////////////////////////////////////////////

void AddVisualEffectList(int nMin, int nMax, int nInterval);
void AddVisualEffectList(int nMin, int nMax, int nInterval)
{
    int i;
    for(i=nMin; i<nMin+nInterval && i<nMax; i++)
    {
        string sLabel = Get2DACache("visualeffects", "Label", i);
        string sType = Get2DACache("visualeffects", "Type_FD", i);
        if(sType != "")
            AddChoice(sLabel, i);
    }
    if(i<nMax)
        DelayCommand(0.0, AddVisualEffectList(nMin+nInterval, nMax, nInterval));
}    

void DrawScriptedEffect(int nID, object oTarget)
{
    location lLoc       = GetLocation(oTarget);
    int nDurationType   = DURATION_TYPE_INSTANT;
    int nVFX            = VFX_IMP_DOMINATE_S;
    switch(nID)
    {
        case  1: DrawCircle(            nDurationType, nVFX, lLoc, 5.0); break;
        case  2: DrawSpiral(            nDurationType, nVFX, lLoc, 5.0); break;
        case  3: DrawSpring(            nDurationType, nVFX, lLoc, 5.0); break;
        case  4: DrawPolygon(           nDurationType, nVFX, lLoc, 5.0); break;
        case  5: DrawPolygonalSpiral(   nDurationType, nVFX, lLoc, 5.0); break;
        case  6: DrawPolygonalSpring(   nDurationType, nVFX, lLoc, 5.0); break;
        case  7: DrawPentacle(          nDurationType, nVFX, lLoc, 5.0); break;
        case  8: DrawPentaclicSpiral(   nDurationType, nVFX, lLoc, 5.0); break;
        case  9: DrawPentaclicSpring(   nDurationType, nVFX, lLoc, 5.0); break;
        case 10: DrawStar(              nDurationType, nVFX, lLoc, 5.0, 10.0); break;
        case 11: DrawStarSpiral(        nDurationType, nVFX, lLoc, 5.0, 10.0); break;
        case 12: DrawStarSpring(        nDurationType, nVFX, lLoc, 5.0, 10.0); break;
        case 13: DrawHemisphere(        nDurationType, nVFX, lLoc, 5.0); break;
        case 14: DrawSphere(            nDurationType, nVFX, lLoc, 5.0); break;
    }  
}

void ApplyStandardEffect(int nID, object oTarget)
{
    string sType = Get2DACache("visualeffects", "Type_FD", nID);
    //fnf effect
    if(sType == "F")
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(nID), GetLocation(oTarget));
    else if(sType == "D")
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(nID), oTarget, 6.0);
    else if(sType == "P")
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nID), oTarget);
    else if(sType == "B")
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(nID, OBJECT_SELF, BODY_NODE_CHEST), oTarget, 6.0);  
}    

void main()
{
    object oPC = GetPCSpeaker();
    object oTarget = GetObjectByTag("EffectCreature");
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
                SetHeader("Select an effect category:");
                AddChoice("Bioware effects", 1);
                AddChoice("Gaoneng's Pentagrams & Summoning Circles", 2);
                AddChoice("Shadguy's effects", 3);
                AddChoice("apply a random effect", 4);
                AddChoice("clear any lingering effects", -1);
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values            
            }            
            else if(nStage == STAGE_BIOWARE_VISUAL_EFFECT)
            {
                SetHeader("Select an effect:");
                AddVisualEffectList(0, 600, 100);
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }        
            else if(nStage == STAGE_SHADEGUY_SCRIPT_EFFECT)
            {
                SetHeader("Select an effect:");
                AddVisualEffectList(1000, 1400, 100);
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }     
            else if(nStage == STAGE_GAONENG_SCRIPT_EFFECT)
            {
                SetHeader("Select an effect:");
                AddChoice("Circle", 1);
                AddChoice("Spiral", 2);
                AddChoice("Spring", 3);
                AddChoice("Polygon", 4);
                AddChoice("PolygonalSpiral", 5);
                AddChoice("PolygonalSpring", 6);
                AddChoice("Pentacle", 7);
                AddChoice("PentaclicSpiral", 8);
                AddChoice("PentaclicSpring", 9);
                AddChoice("Star", 10);
                AddChoice("StarSpiral", 11);
                AddChoice("StarSpring", 12);
                AddChoice("Hemisphere", 13);
                AddChoice("Sphere", 14);
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
        }

        // Do token setup
        SetupTokens();
    }
    // End of conversation cleanup
    else if(nValue == DYNCONV_EXITED)
    {
        // Add any locals set through this conversation
    }
    // Abort conversation cleanup.
    // NOTE: This section is only run when the conversation is aborted
    // while aborting is allowed. When it isn't, the dynconvo infrastructure
    // handles restoring the conversation in a transparent manner
    else if(nValue == DYNCONV_ABORTED)
    {
        // Add any locals set through this conversation
    }
    // Handle PC responses
    else
    {
        // variable named nChoice is the value of the player's choice as stored when building the choice list
        // variable named nStage determines the current conversation node
        int nChoice = GetChoice(oPC);
        if(nStage == STAGE_ENTRY)
        {
            if(nChoice == 1)
                nStage = STAGE_BIOWARE_VISUAL_EFFECT;
            else if(nChoice == 2)    
                nStage = STAGE_GAONENG_SCRIPT_EFFECT;
            else if(nChoice == 3)    
                nStage = STAGE_SHADEGUY_SCRIPT_EFFECT;
            else if(nChoice == 4)    
            {
                //random
                int nRandom = Random(3);
                if(nRandom == 0
                    || nRandom == 1)
                {   
                    int nVFX;
                    if(nRandom == 0)
                        nVFX = Random(580);
                    else if(nRandom == 1)
                        nVFX = Random(327)+1000;
                    ApplyStandardEffect(Random(14)+1, oTarget); 
                }
                else
                    DrawScriptedEffect(nChoice, oTarget);     
            }
            else if(nChoice == -1)    
                AssignCommand(oTarget, ForceRest(oTarget));
        }
        else if(nStage == STAGE_BIOWARE_VISUAL_EFFECT
            || nStage == STAGE_SHADEGUY_SCRIPT_EFFECT)
        {
            ApplyStandardEffect(nChoice, oTarget);       
        }
        else if(nStage == STAGE_GAONENG_SCRIPT_EFFECT)
        {      
            DrawScriptedEffect(nChoice, oTarget);
        }

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
