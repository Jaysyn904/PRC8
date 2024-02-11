//::///////////////////////////////////////////////
//:: Name           Umbral Awn test script
//:: FileName       wol_t_umbral
//:://////////////////////////////////////////////
/*
Base attack bonus +3
Weapon Proficiency (Dagger)
Hide 4 ranks
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
    if(4 > GetSkillRank(SKILL_HIDE, oPC, TRUE))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    } 
}