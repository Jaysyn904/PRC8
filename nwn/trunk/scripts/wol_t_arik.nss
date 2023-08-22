//::///////////////////////////////////////////////
//:: Name           Arik's Vengeance test script
//:: FileName       wol_t_arik
//:://////////////////////////////////////////////
/*
Base attack bonus +3 
Able to manifest 2nd level powers
Must be a Psychic Warrior
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
    if(!GetLevelByClass(CLASS_TYPE_PSYWAR, oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    }    
    if(3 > GetBaseAttackBonus(oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END); 
    }    
}