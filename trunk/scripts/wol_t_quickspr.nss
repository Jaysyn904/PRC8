//::///////////////////////////////////////////////
//:: Name           Quickspur's Ally test script
//:: FileName       wol_t_quickspr
//:://////////////////////////////////////////////
/*
Shield proficiency
Improved Shield Bash
Craft (any) 5 ranks
Ride 2 ranks
Any nonevil alignment
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
       
    if(!GetHasFeat(FEAT_IMPROVED_SHIELD_BASH, oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    }  
    if(!GetHasFeat(FEAT_SHIELD_PROFICIENCY, oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    }     
    if(GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL)
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }   
    if(2 > GetSkillRank(SKILL_RIDE, oPC, TRUE))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }
    if(5 > GetSkillRank(SKILL_CRAFT_TRAP, oPC, TRUE) &&
       5 > GetSkillRank(SKILL_CRAFT_ARMOR, oPC, TRUE) &&
       5 > GetSkillRank(SKILL_CRAFT_WEAPON, oPC, TRUE) &&
       5 > GetSkillRank(SKILL_CRAFT_ALCHEMY, oPC, TRUE) &&
       5 > GetSkillRank(SKILL_CRAFT_POISON, oPC, TRUE) &&
       5 > GetSkillRank(SKILL_CRAFT_GENERAL, oPC, TRUE))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }    
}