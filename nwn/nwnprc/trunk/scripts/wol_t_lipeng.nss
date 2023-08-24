//::///////////////////////////////////////////////
//:: Name           Bones of Li Peng test script
//:: FileName       wol_t_lipeng
//:://////////////////////////////////////////////
/*
Wisdom 13
Base attack bonus +2
Balance 6 ranks
Any nonchaotic alignment
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
    if(GetAlignmentLawChaos(oPC) == ALIGNMENT_CHAOTIC)
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    } 
    if(6 > GetSkillRank(SKILL_BALANCE, oPC, TRUE))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }    
    if (13 > GetAbilityScore(oPC, ABILITY_WISDOM, TRUE))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END); 
    }    
}

