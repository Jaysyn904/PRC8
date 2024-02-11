//::///////////////////////////////////////////////
//:: Name           Blackrazor test script
//:: FileName       wol_t_blackrazor
//:://////////////////////////////////////////////
/*
Base attack bonus +3
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
       
    if(4 > GetBaseAttackBonus(oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END); 
    }    
}