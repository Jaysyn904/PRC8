//::////////////////////////////////////////////////////////
//:: Name      Epic Repulsion
//:: FileName  ss_ep_repulsion.nss
//::////////////////////////////////////////////////////////
/** @file Epic Repulsion
School: Abjuration
Components: V,S
Range: Touch
Target: Creature or object touched
Duration: 24 hours
Saving Throw: None
Spell Resistance: Yes, see text

You can create a ward against a specific type of creature for 
the duration. Any creature of the specific type cannot come 
within the aura of the warded creature or object. Spell 
resistance can allow a creature to overcome this protection 
and enter the aura of the warded subject.

Dynamic conversation script
**/
//::////////////////////////////////////////////////////////
//::
//:: Author: Jaysyn
//:: Date: 2026-09-20 18:21:40
//::
//::////////////////////////////////////////////////////////
#include "prc_inc_spells"  
#include "inc_dynconv"  
#include "inc_2dacache"  
  
const int STAGE_ENTRY = 0;  
  
void main()  
{  
    object oPC = GetPCSpeaker();  
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);  
    int nStage = GetStage(oPC);  
  
    if (nValue == 0)  
        return;  
  
    if (nValue == DYNCONV_SETUP_STAGE)  
    {  
        if (!GetIsStageSetUp(nStage, oPC))  
        {  
            if (nStage == STAGE_ENTRY)  
            {  
                SetHeader("Choose the creature type to repel.");  
                int racialType;  
                for (racialType = 0; racialType <= 52; racialType++)  
                {  
                    string sName = Get2DACache("racialtypes", "Constant", racialType);  
                    if (sName != "")  
                        AddChoice(sName, racialType, oPC);  
                }  
                MarkStageSetUp(nStage, oPC);  
                SetDefaultTokens();  
            }  
        }  
        SetupTokens();  
    }  
    else if (nValue == DYNCONV_EXITED)  
    {  
        // End of conversation cleanup  
        DeleteLocalObject(oPC, "oRepulsionTarget");  
    }  
    else if (nValue == DYNCONV_ABORTED)  
    {  
        DeleteLocalObject(oPC, "oRepulsionTarget");  
    }  
    else  
    {  
        int nChoice = GetChoice(oPC);  
        if (nStage == STAGE_ENTRY)  
        {  
            object oTarget = GetLocalObject(oPC, "oRepulsionTarget");  
            if (GetIsObjectValid(oTarget))  
            {  
                effect eAoE = EffectAreaOfEffect(AOE_PER_REPULSION, "ss_ep_repulsiona", "ss_ep_repulsionc", "ss_ep_repulsionb"); 				
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAoE, oTarget, HoursToSeconds(24));  
  
                object oAoE = GetAreaOfEffectObject(GetLocation(oTarget), "AOE_PER_REPULSION");  
                SetLocalInt(oAoE, "EpicRepulsionRace", nChoice);  
            }  
            DeleteLocalObject(oPC, "oRepulsionTarget");  
        }  
  
        // Store the stage value. If it has been changed, this clears out the choices  
        SetStage(nStage, oPC);  
    }  
}