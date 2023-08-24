//::///////////////////////////////////////////////
//:: Name           Caladbolg test script
//:: FileName       wol_t_calad
//:://////////////////////////////////////////////
/*
Base attack bonus +3 
Perform 1 ranks 
Power Attack
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
       
    if(!GetHasFeat(FEAT_POWER_ATTACK, oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    }  
    if(3 > GetBaseAttackBonus(oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END); 
    }    
    if(1 > GetSkillRank(SKILL_PERFORM, oPC, TRUE))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }
}