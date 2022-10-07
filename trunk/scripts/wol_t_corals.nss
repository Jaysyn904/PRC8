//::///////////////////////////////////////////////
//:: Name           Coral's Bite test script
//:: FileName       wol_t_corals
//:://////////////////////////////////////////////
/*
Lore 1 rank
Listen 1 rank
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
        
    if(1 > GetSkillRank(SKILL_LISTEN, oPC, TRUE))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }    
    if(1 > GetSkillRank(SKILL_LORE, oPC, TRUE))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }     
}

