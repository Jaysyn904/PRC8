//::///////////////////////////////////////////////
//:: Name           Bow of the Black Archer test script
//:: FileName       wol_t_blackarch
//:://////////////////////////////////////////////
/*
Cannot be drow
Base attack bonus +3 
Hide 2 ranks 
Move Silently 2 ranks 
Favored enemy elves +2 
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
       
    if(GetLocalInt(oPC, "PRC_PsiPower2"))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }
    if(2 > GetSkillRank(SKILL_CONCENTRATION, oPC, TRUE))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    }    
    if(!GetHasFeat(FEAT_ZEN_ARCHERY, oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    }    
    if(3 > GetBaseAttackBonus(oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END); 
    }    
}