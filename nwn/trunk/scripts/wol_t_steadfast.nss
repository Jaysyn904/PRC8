//::///////////////////////////////////////////////
//:: Name           Steadfast test script
//:: FileName       wol_t_steadfast
//:://////////////////////////////////////////////
/*
Base attack bonus +3 
Weapon Focus (Scimitar)
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
       
    if(!GetHasFeat(FEAT_WEAPON_FOCUS_SCIMITAR, oPC))
    {
        //DoDebug("wol_t_blackarch doesn't have FE: Elf");
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    }    
    if(3 > GetBaseAttackBonus(oPC))
    {
        //DoDebug("wol_t_blackarch doesn't have BAB");
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END); 
    }    
}