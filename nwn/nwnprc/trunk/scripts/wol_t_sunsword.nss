//::///////////////////////////////////////////////
//:: Name           Sunsword test script
//:: FileName       wol_t_sunsword
//:://////////////////////////////////////////////
/*
Base attack bonus +2
Any good alignment 
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
       
    if(3 > GetBaseAttackBonus(oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END); 
    }    
    if(GetAlignmentGoodEvil(oPC) != ALIGNMENT_GOOD)
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }   
}