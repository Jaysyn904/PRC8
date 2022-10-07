//::///////////////////////////////////////////////
//:: Name           Eventide's Edge test script
//:: FileName       wol_t_eventide
//:://////////////////////////////////////////////
/*
Base attack bonus +3
Weapon Proficiency (Short Sword)
Small or Medium size
Knowledge of at least one Setting Sun maneuver
*/

#include "prc_inc_template"
#include "tob_inc_tobfunc"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
       
    if(!GetHasFeat(FEAT_WEAPON_PROFICIENCY_SHORTSWORD, oPC) && !GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    }  
    if(3 > GetBaseAttackBonus(oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END); 
    }    
    if (PRCGetCreatureSize(oPC) > CREATURE_SIZE_MEDIUM)
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END); 
    }  
    if (!GetManeuverCountByDiscipline(oPC, DISCIPLINE_SETTING_SUN, MANEUVER_TYPE_MANEUVER))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END); 
    }  
}