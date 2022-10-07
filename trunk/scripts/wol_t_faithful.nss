//::///////////////////////////////////////////////
//:: Name           Faithful Avenger test script
//:: FileName       wol_t_faithful
//:://////////////////////////////////////////////
/*
Base attack bonus +5
Weapon Proficiency (Greatsword)
Good alignment
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
       
    if(!GetHasFeat(FEAT_WEAPON_PROFICIENCY_GREATSWORD, oPC) && !GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    }  
    if(5 > GetBaseAttackBonus(oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END); 
    }    
    if(GetAlignmentGoodEvil(oPC) != ALIGNMENT_GOOD)
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }
}