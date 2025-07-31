//::///////////////////////////////////////////////
//:: Name           Gravetouched Ghoul template test script
//:: FileName       tmp_t_gravetouch
//:: 
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Strat
//:: Created On: 27/1/21
//:://////////////////////////////////////////////

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
    
    int nRace = MyPRCGetRacialType(oPC);

	//:: No undead.
    if(GetHasTemplate(TEMPLATE_LICH, oPC) ||
    GetHasTemplate(TEMPLATE_DEMILICH, oPC) ||
	GetHasTemplate(TEMPLATE_ARCHLICH, oPC) ||
    GetHasTemplate(TEMPLATE_NECROPOLITAN, oPC) ||	
	GetHasTemplate(TEMPLATE_ALHOON, oPC) ||
	GetHasTemplate(TEMPLATE_CURST, oPC) ||
	GetHasTemplate(TEMPLATE_CRYPTSPAWN, oPC) ||
	GetHasTemplate(TEMPLATE_BAELNORN, oPC) ||	
    GetLevelByClass(CLASS_TYPE_BAELNORN, oPC) > 0 ||
    GetLevelByClass(CLASS_TYPE_LICH, oPC) > 0)
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }	
    
    // These are the legal races
    if (nRace != RACIAL_TYPE_HUMANOID_MONSTROUS &&
        nRace != RACIAL_TYPE_GIANT &&
        nRace != RACIAL_TYPE_DWARF &&
        nRace != RACIAL_TYPE_ELF &&
        nRace != RACIAL_TYPE_FEY &&
        nRace != RACIAL_TYPE_GNOME &&
        nRace != RACIAL_TYPE_HUMANOID_GOBLINOID &&
        nRace != RACIAL_TYPE_HALFELF &&
        nRace != RACIAL_TYPE_HALFLING &&
        nRace != RACIAL_TYPE_HALFORC &&
        nRace != RACIAL_TYPE_HUMAN &&
        nRace != RACIAL_TYPE_HUMANOID_MONSTROUS &&
        nRace != RACIAL_TYPE_HUMANOID_ORC &&
        nRace != RACIAL_TYPE_HUMANOID_REPTILIAN &&
        nRace != RACIAL_TYPE_ABERRATION)
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }
}