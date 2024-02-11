//::///////////////////////////////////////////////
//:: Name           Tiger Fang test script
//:: FileName       wol_t_tigerfng
//:://////////////////////////////////////////////
/*
Base attack bonus +3
Weapon Proficiency (Kukri)
Jump 5 ranks
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
       
    if(!GetHasFeat(FEAT_WEAPON_PROFICIENCY_KUKRI, oPC) && !GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    }  
    if(3 > GetBaseAttackBonus(oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END); 
    }    
    if(5 > GetSkillRank(SKILL_JUMP, oPC, TRUE))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    } 
}