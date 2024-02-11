//::///////////////////////////////////////////////
//:: Name           Crimson Ruination test script
//:: FileName       wol_t_crimruin
//:://////////////////////////////////////////////
/*
Base attack bonus +3 
Any nonchaotic alignment
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
    if(!GetHasFeat(FEAT_ARMOR_PROFICIENCY_MEDIUM, oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    }
    if(4 > GetSkillRank(SKILL_CRAFT_ARMOR, oPC, TRUE))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    }    
}