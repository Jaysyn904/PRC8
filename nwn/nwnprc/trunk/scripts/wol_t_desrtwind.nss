//::///////////////////////////////////////////////
//:: Name           Desert Wind test script
//:: FileName       wol_t_desrtwind
//:://////////////////////////////////////////////
/*
Base attack bonus +3 
Weapon Focus Scimitar
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
       
    if(!GetHasFeat(FEAT_WEAPON_FOCUS_SCIMITAR, oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    }    
    if(3 > GetBaseAttackBonus(oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END); 
    }    
}