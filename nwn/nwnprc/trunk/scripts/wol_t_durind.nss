//::///////////////////////////////////////////////
//:: Name           Durindana test script
//:: FileName       wol_t_durind
//:://////////////////////////////////////////////
/*
Ability to cast 1st-level divine spells 
BAB +2
Any nonevil alignment
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
       
    if(GetLocalInt(oPC, "PRC_DivSpell1"))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }
    if(2 > GetBaseAttackBonus(oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END); 
    }    
    if(GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL)
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }    
}