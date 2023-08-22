//::///////////////////////////////////////////////
//:: Name           Kamate test script
//:: FileName       wol_t_kamate
//:://////////////////////////////////////////////
/*
Base attack bonus +4
Weapon Proficiency (Bastard Sword)
Balance 4 ranks
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
       
    if(!GetHasFeat(FEAT_WEAPON_PROFICIENCY_BASTARD_SWORD, oPC) && !GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    }  
    if(4 > GetBaseAttackBonus(oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END); 
    }    
    if(4 > GetSkillRank(SKILL_BALANCE, oPC, TRUE))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    } 
}