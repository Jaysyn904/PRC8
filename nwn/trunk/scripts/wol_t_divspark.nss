//::///////////////////////////////////////////////
//:: Name           Divine Spark test script
//:: FileName       wol_t_divspark
//:://////////////////////////////////////////////
/*
Ability to cast 1st-level divine spells 
Persuade 2 ranks 
Any nonevil alignment
Ability to turn undead
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
       
    if(GetLocalInt(oPC, "PRC_DivSpell1"))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }
    if(2 > GetSkillRank(SKILL_PERSUADE, oPC, TRUE))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    }    
    if(!GetHasFeat(FEAT_TURN_UNDEAD, oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    }    
    if(GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL)
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }    
}