//::///////////////////////////////////////////////
//:: Name           Infiltrator test script
//:: FileName       wol_t_infil
//:://////////////////////////////////////////////
/*
Persuade 2 ranks
Listen 2 ranks
Sense Motive 2 ranks
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
       
    if(2 > GetSkillRank(SKILL_PERSUADE, oPC, TRUE))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    } 
    if(2 > GetSkillRank(SKILL_LISTEN, oPC, TRUE))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    } 
    if(2 > GetSkillRank(SKILL_SENSE_MOTIVE, oPC, TRUE))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }     
}