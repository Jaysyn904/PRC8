//::///////////////////////////////////////////////
//:: Name           Caput Mortuum test script
//:: FileName       wol_t_cptmortum
//:://////////////////////////////////////////////
/*
Ability to cast death knell as a divine spell 
Any nongood alignment 
Ability to rebuke undead
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
       
    if(!GetHasFeat(FEAT_TURN_UNDEAD, oPC))
    {
        //DoDebug("wol_t_blackarch doesn't have FE: Elf");
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    }  
    // Can't cast Death Knell as a divine spell
    if(!PRCGetIsRealSpellKnown(SPELL_DEATH_KNELL, oPC) && 3 > GetLevelByClass(CLASS_TYPE_CLERIC, oPC))
    {
        //DoDebug("wol_t_blackarch doesn't have BAB");
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END); 
    }    
    // Can't be good
    if(GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD)
    {
        //DoDebug("wol_t_blackarch doesn't have Drow");
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }   
    
    //DoDebug("wol_t_blackarch end of script");
}