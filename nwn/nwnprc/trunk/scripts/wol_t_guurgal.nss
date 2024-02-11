//::///////////////////////////////////////////////
//:: Name           Guurgal test script
//:: FileName       wol_t_guurgal
//:://////////////////////////////////////////////
/*
Must be Orc or Half-Orc
Base attack bonus +3 
Intimidate 2 ranks 
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
       
    if(2 > GetSkillRank(SKILL_INTIMIDATE, oPC, TRUE))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }
    if(3 > GetBaseAttackBonus(oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END); 
    }    
        
    int nRace = MyPRCGetRacialType(oPC);
    if(nRace != RACIAL_TYPE_HUMANOID_ORC && nRace != RACIAL_TYPE_HALFORC)
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }   
}