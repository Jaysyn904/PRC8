//::///////////////////////////////////////////////
//:: Name           Fiendkiller's Flail test script
//:: FileName       wol_t_fiendkll
//:://////////////////////////////////////////////
/*
Base attack bonus +3 
Sense Motive 2 ranks 
Weapon Focus (heavy flail)
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
       
    if(2 > GetSkillRank(SKILL_SENSE_MOTIVE, oPC, TRUE) && 2 > GetSkillRank(SKILL_PERSUADE, oPC, TRUE))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    }    
    if(!GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_FLAIL, oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    }    
    if(3 > GetBaseAttackBonus(oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END); 
    }    
}