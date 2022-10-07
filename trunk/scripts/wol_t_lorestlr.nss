//::///////////////////////////////////////////////
//:: Name           Lorestealer test script
//:: FileName       wol_t_lorestlr
//:://////////////////////////////////////////////
/*
Base attack bonus +3
No spellcasting ability
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
       
    if(3 > GetBaseAttackBonus(oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END); 
    }    
    if(GetLocalInt(oPC, "PRC_AllSpell1") == 0 || 
       GetLocalInt(oPC, "PRC_AllSpell2") == 0 || 
       GetLocalInt(oPC, "PRC_AllSpell3") == 0 || 
       GetLocalInt(oPC, "PRC_AllSpell4") == 0 || 
       GetLocalInt(oPC, "PRC_AllSpell5") == 0 || 
       GetLocalInt(oPC, "PRC_AllSpell6") == 0 || 
       GetLocalInt(oPC, "PRC_AllSpell7") == 0 || 
       GetLocalInt(oPC, "PRC_AllSpell8") == 0 || 
       GetLocalInt(oPC, "PRC_AllSpell9") == 0)
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END); 
    }      
}