//::///////////////////////////////////////////////
//:: Name           Supernal Clarity test script
//:: FileName       wol_t_supernal
//:://////////////////////////////////////////////
/*
Base attack bonus +3
Weapon Proficiency (Rapier)
Concentration 4 ranks
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
       
    if(!GetHasFeat(FEAT_WEAPON_PROFICIENCY_RAPIER, oPC) && !GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC) && !GetHasFeat(FEAT_WEAPON_PROFICIENCY_ELF, oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    }  
    if(3 > GetBaseAttackBonus(oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END); 
    }    
    if(4 > GetSkillRank(SKILL_CONCENTRATION, oPC, TRUE))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    } 
}