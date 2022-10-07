//::///////////////////////////////////////////////
//:: Name           Bright Evening Star test script
//:: FileName       wol_t_btevstar
//:://////////////////////////////////////////////
//:: By ebonfowl for the PRC
//:: Dedicated to Edgar, the real Ebonfowl
//:://////////////////////////////////////////////
/*
Ability to cast 1st level arcane spells
Skills: Lore 3
Alignment: any nonevil
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
       
    if(GetLocalInt(oPC, "PRC_ArcSpell1"))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);   
    }
    if(3 > GetSkillRank(SKILL_LORE, oPC, TRUE))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END); 
    }      
    if(GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL)
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END); 
    }    
}