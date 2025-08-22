//::///////////////////////////////////////////////
//:: Name           Necropolitan template test script
//:: FileName       tmp_t_necropol
//:: 
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 5/6/28
//:://////////////////////////////////////////////

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);

    //if it's already undead, it can't become undead again
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
    
    // Humanoid only
    int nRace = MyPRCGetRacialType(oPC);
    if(nRace == RACIAL_TYPE_ABERRATION ||
       nRace == RACIAL_TYPE_ANIMAL ||
       nRace == RACIAL_TYPE_BEAST ||
       nRace == RACIAL_TYPE_CONSTRUCT ||
       nRace == RACIAL_TYPE_DRAGON ||
       nRace == RACIAL_TYPE_ELEMENTAL ||
       nRace == RACIAL_TYPE_FEY ||
       nRace == RACIAL_TYPE_GIANT ||
       nRace == RACIAL_TYPE_MAGICAL_BEAST ||
       nRace == RACIAL_TYPE_PLANT ||
       nRace == RACIAL_TYPE_OOZE ||
       nRace == RACIAL_TYPE_OUTSIDER ||
       nRace == RACIAL_TYPE_SHAPECHANGER ||
       nRace == RACIAL_TYPE_UNDEAD ||
       nRace == RACIAL_TYPE_VERMIN)
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }    
}