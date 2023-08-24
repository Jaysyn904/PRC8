//::///////////////////////////////////////////////
//:: Name           Mindsplinter test script
//:: FileName       wol_t_mndsplntr
//:://////////////////////////////////////////////
/*
Base attack bonus +2
Any nongood alignment 
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
       
    if(2 > GetBaseAttackBonus(oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END); 
    }    
    if(GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD)
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }   
}