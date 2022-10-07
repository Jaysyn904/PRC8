//::///////////////////////////////////////////////
//:: Name           Full Moon's Trick test script
//:: FileName       wol_t_fullmoon
//:://////////////////////////////////////////////
/*
Base attack bonus +2 
Hide 2 ranks
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
    if(2 > GetSkillRank(SKILL_HIDE, oPC, TRUE))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    }    
}