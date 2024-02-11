//::///////////////////////////////////////////////
//:: Name           Ramethene Sword test script
//:: FileName       wol_t_ramthene
//:://////////////////////////////////////////////
/*
Base attack bonus +4
Spellcraft 2 ranks
EWP: Bastard Sword
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
       
    if(4 > GetBaseAttackBonus(oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END); 
    }   
    if(2 > GetSkillRank(SKILL_SPELLCRAFT, oPC, TRUE))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    }   
    if(!GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC) && !GetHasFeat(FEAT_WEAPON_PROFICIENCY_BASTARD_SWORD, oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    }       
}