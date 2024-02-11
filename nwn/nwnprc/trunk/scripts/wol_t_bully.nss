//::///////////////////////////////////////////////
//:: Name           Bullybasher's Gauntlets test script
//:: FileName       wol_t_bully
//:://////////////////////////////////////////////
/*
Base attack bonus +2
Knowledge (local) 2 ranks
Improved Unarmed Strike
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
    if(2 > GetSkillRank(SKILL_LORE, oPC, TRUE))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }    
    if (!GetHasFeat(FEAT_IMPROVED_UNARMED_STRIKE, oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END); 
    }    
}

