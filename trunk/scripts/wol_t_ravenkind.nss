//::///////////////////////////////////////////////
//:: Name           Holy Symbol of Ravenkind test script
//:: FileName       wol_t_ravenkind
//:://////////////////////////////////////////////
/*
Any good alignment 
Turn Undead
Lore 4
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
       
    if(!GetHasFeat(FEAT_TURN_UNDEAD, oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    }  
    if(GetAlignmentGoodEvil(oPC) != ALIGNMENT_GOOD)
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }   
    if(4 > GetSkillRank(SKILL_LORE, oPC, TRUE))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }  
}