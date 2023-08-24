//::///////////////////////////////////////////////
//:: Name           Blade of the Last Citadel test script
//:: FileName       wol_t_lastcit
//:://////////////////////////////////////////////
/*
Any nonevil alignment
Base attack bonus +3
Weapon Proficiency (longsword)
Persuade 4 ranks
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
       
    if(!GetHasFeat(FEAT_WEAPON_PROFICIENCY_LONGSWORD, oPC) && !GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC) && !GetHasFeat(FEAT_WEAPON_PROFICIENCY_ELF, oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    }  
    if(3 > GetBaseAttackBonus(oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END); 
    }    
    if(GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL)
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }   
    if(4 > GetSkillRank(SKILL_PERSUADE, oPC, TRUE))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }
}