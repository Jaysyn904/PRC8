//::///////////////////////////////////////////////
//:: Name           Flamcaster's Bolt test script
//:: FileName       wol_t_flmcaster
//:://////////////////////////////////////////////
/*
Base attack bonus +3 
Persuade 2 ranks 
Weapon Focus (Light Crossbow)
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
    if(!GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_CROSSBOW, oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    }    
    if(3 > GetBaseAttackBonus(oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END); 
    }    
}