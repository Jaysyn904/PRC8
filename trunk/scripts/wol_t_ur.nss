//::///////////////////////////////////////////////
//:: Name           Ur test script
//:: FileName       wol_t_ur
//:://////////////////////////////////////////////
/*
Base attack bonus +4
Hide 2
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
    if(2 > GetSkillRank(SKILL_HIDE, oPC, TRUE))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    }   
}