//::///////////////////////////////////////////////
//:: Name           Devious and Vicious test script
//:: FileName       wol_t_Devious
//:://////////////////////////////////////////////
/*
Base attack bonus +2 
Persuasive
Intimidate 2
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
       
    if(!GetHasFeat(FEAT_PERSUASIVE, oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    } 
    if(2 > GetSkillRank(SKILL_INTIMIDATE, oPC, TRUE))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    }    
    if(2 > GetBaseAttackBonus(oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END); 
    }    
}