//::///////////////////////////////////////////////
//:: Name           Wyrmbane Helm test script
//:: FileName       wol_t_wyrmbane
//:://////////////////////////////////////////////
/*
Ability to cast 2nd-level arcane spells
Base attack bonus +3
Proficient with martial weapons
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
    if(GetLocalInt(oPC, "PRC_ArcSpell2"))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }   
    if(!GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    }    
}