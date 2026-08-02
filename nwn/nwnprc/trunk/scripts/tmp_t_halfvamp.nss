//::///////////////////////////////////////////////  
//:: Name           Half-Vampire template test script  
//:: FileName       tmp_t_halfvamp.nss  
//::///////////////////////////////////////////////  
/*  
"Half-vampire" is an inherited template that can be  
added to any humanoid or monstrous humanoid (referred  
to hereafter as the base creature). The creature's  
size and type do not change.  
*/  
//::///////////////////////////////////////////////  
  
#include "prc_inc_template"  
  
void main()  
{  
    object oPC = OBJECT_SELF;  
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);  
  
    int nRace = MyPRCGetRacialType(oPC);  
    if(nRace != RACIAL_TYPE_DWARF  
        && nRace != RACIAL_TYPE_ELF  
        && nRace != RACIAL_TYPE_GNOME  
        && nRace != RACIAL_TYPE_HALFLING  
        && nRace != RACIAL_TYPE_HALFELF  
        && nRace != RACIAL_TYPE_HALFORC  
        && nRace != RACIAL_TYPE_HUMAN  
        && nRace != RACIAL_TYPE_HUMANOID_GOBLINOID  
        && nRace != RACIAL_TYPE_HUMANOID_MONSTROUS  
        && nRace != RACIAL_TYPE_HUMANOID_ORC  
        && nRace != RACIAL_TYPE_HUMANOID_REPTILIAN  
        )  
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);  
  
    // Can't already be a half-vampire  
    if(GetHasTemplate(TEMPLATE_HALF_VAMPIRE))  
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);  
}