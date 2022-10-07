//::///////////////////////////////////////////////
//:: Name           Shishi-O test script
//:: FileName       wol_t_shishio
//:://////////////////////////////////////////////
/*
Base attack bonus +3 
Any nonchaotic alignment 
Proficiency with katana
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
    if(GetAlignmentLawChaos(oPC) == ALIGNMENT_CHAOTIC)
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    } 
    if(!GetHasFeat(FEAT_WEAPON_PROFICIENCY_KATANA, oPC) && !GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }     
}

