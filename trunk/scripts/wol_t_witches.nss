//::///////////////////////////////////////////////
//:: Name           Hammer of Witches test script
//:: FileName       wol_t_witches
//:://////////////////////////////////////////////
/*
Ability to cast 2nd-level divine spells 
Lore 2 ranks 
Cannot have levels in an arcane spellcasting class
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
       
    if(GetLocalInt(oPC, "PRC_DivSpell2"))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    } 
    if(GetLevelByTypeArcane(oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END); 
    }    
    if(2 > GetSkillRank(SKILL_LORE, oPC, TRUE))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }
}