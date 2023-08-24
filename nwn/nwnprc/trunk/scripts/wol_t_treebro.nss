//::///////////////////////////////////////////////
//:: Name           Treebrother test script
//:: FileName       wol_t_treebro
//:://////////////////////////////////////////////
/*
Able to cast Barkskin as a divine spell
Lore 6
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
       
    if(!PRCGetIsRealSpellKnown(SPELL_BARKSKIN, oPC) && 3 > GetLevelByClass(CLASS_TYPE_DRUID, oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END); 
    }    
    if(6 > GetSkillRank(SKILL_LORE, oPC, TRUE))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }
}