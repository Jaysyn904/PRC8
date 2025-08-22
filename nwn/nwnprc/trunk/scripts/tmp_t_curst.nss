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
    GetHasTemplate(TEMPLATE_BAELNORN, oPC) ||
	GetHasTemplate(TEMPLATE_CURST, oPC) ||
	GetHasTemplate(TEMPLATE_ARCHLICH, oPC) ||
	GetHasTemplate(TEMPLATE_ALHOON, oPC) ||
	GetHasTemplate(TEMPLATE_NECROPOLITAN, oPC) ||
    GetHasTemplate(TEMPLATE_DEMILICH, oPC) ||
    GetLevelByClass(CLASS_TYPE_BAELNORN, oPC) > 0 ||
    GetLevelByClass(CLASS_TYPE_LICH, oPC) > 0)
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }
    
    // Humanoid only
    if(!PRCAmIAHumanoid(oPC))
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }    
}