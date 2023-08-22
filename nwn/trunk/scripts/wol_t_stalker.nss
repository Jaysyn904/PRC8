//::///////////////////////////////////////////////
//:: Name           Stalker's Bow test script
//:: FileName       wol_t_stalker
//:://////////////////////////////////////////////
/*
Hide 1 ranks 
Move Silently 1 ranks 
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
       
    if(1 > GetSkillRank(SKILL_HIDE, oPC, TRUE))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }
    if(1 > GetSkillRank(SKILL_MOVE_SILENTLY, oPC, TRUE))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    }    
}