//::///////////////////////////////////////////////
//:: Name           Thaas test script
//:: FileName       wol_t_thaas
//:://////////////////////////////////////////////
/*
Weapon Focus (Longbow)
Base attack bonus +3
Any nonchaotic, nonevil alignment
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
       
    if(!GetHasFeat(FEAT_WEAPON_FOCUS_LONGBOW, oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    }  
    if(3 > GetBaseAttackBonus(oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END); 
    }    
    if(GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL)
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }    
    if(GetAlignmentLawChaos(oPC) == ALIGNMENT_CHAOTIC)
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }     
}