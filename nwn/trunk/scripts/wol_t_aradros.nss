//::///////////////////////////////////////////////
//:: Name           Scarab of Aradros test script
//:: FileName       wol_t_aradros
//:://////////////////////////////////////////////
/*
Ability to cast 2nd-level arcane spells 
Lore 3 ranks
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
       
    if(GetLocalInt(oPC, "PRC_ArcSpell2"))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }
    if(3 > GetSkillRank(SKILL_LORE, oPC, TRUE))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    }    
}