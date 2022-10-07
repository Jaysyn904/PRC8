//::///////////////////////////////////////////////
//:: Name           Hillcrusher test script
//:: FileName       wol_t_hillcrus
//:://////////////////////////////////////////////
/*
Base attack bonus +4
Constitution 13
Size Medium or smaller
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
    
    if (13 > GetAbilityScore(oPC, ABILITY_CONSTITUTION, TRUE))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END); 
    }
    
    if(4 > GetBaseAttackBonus(oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END); 
    } 
    
    if (PRCGetCreatureSize(oPC) > CREATURE_SIZE_MEDIUM)
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END); 
    }    
}