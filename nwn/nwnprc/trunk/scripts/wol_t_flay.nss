//::///////////////////////////////////////////////
//:: Name           Flay test script
//:: FileName       wol_t_flay
//:://////////////////////////////////////////////
/*
Base attack bonus +2 
Bluff or Diplomacy 2 ranks 
Exotic Weapon Proficiency (whip)
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
       
    if(2 > GetSkillRank(SKILL_BLUFF, oPC, TRUE) && 2 > GetSkillRank(SKILL_PERSUADE, oPC, TRUE))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    }    
    if(!GetHasFeat(FEAT_WEAPON_PROFICIENCY_WHIP, oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    }    
    if(2 > GetBaseAttackBonus(oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END); 
    }    
}