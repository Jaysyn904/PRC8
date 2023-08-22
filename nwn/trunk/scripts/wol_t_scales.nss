//::///////////////////////////////////////////////
//:: Name           Scales of Balance test script
//:: FileName       wol_t_scales
//:://////////////////////////////////////////////
/*
Balance 3
Lore 5
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
       
    if(3 > GetSkillRank(SKILL_BALANCE, oPC, TRUE))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    }    
    if(5 > GetSkillRank(SKILL_LORE, oPC, TRUE))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    } 
}