//::///////////////////////////////////////////////
//:: Name           Notched Spear test script
//:: FileName       wol_t_notched
//:://////////////////////////////////////////////
/*
Base attack bonus +3
Climb 2
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
    if(2 > GetSkillRank(SKILL_CLIMB, oPC, TRUE))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    }   
}