//::///////////////////////////////////////////////
//:: Name           Alhoon template test script
//:: FileName       tmp_t_alhoon
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creating An Alhoon

An alhoon conforms to all the normal rules for adding the lich template to a humanoid, except asnoted below.

	Size and Type: The creature's type changes to undead (augmented aberration). Do not recalculate base attack bonus, saves, or skill points. Size is unchanged.
	
	Armor Class: An alhoon's natural armor bonus improves from +3 to +5.

*/
//:://////////////////////////////////////////////
//:: Created By: Jaysyn
//:: Created On: 24/08/06
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    string sString = "Alhoon template: ";
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);

    int nAlignment = GetAlignmentGoodEvil(oPC);
    if(nAlignment != ALIGNMENT_EVIL && GetLevelByClass(CLASS_TYPE_DREAD_NECROMANCER) < 20)
    {
        SendMessageToPC(oPC, sString+"Not evil");
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }
    else if(GetLevelByClass(CLASS_TYPE_DREAD_NECROMANCER, oPC) >= 20 && nAlignment == ALIGNMENT_GOOD)
    {
        SendMessageToPC(oPC, sString+"Can't be a good Dread Necromancer");
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }

    int nArcCasterLevel = GetPrCAdjustedCasterLevelByType(TYPE_ARCANE, oPC, TRUE);
    int nDivCasterLevel = GetPrCAdjustedCasterLevelByType(TYPE_DIVINE, oPC, TRUE);
    if(nArcCasterLevel < 11 && nDivCasterLevel < 11)
    {
        SendMessageToPC(oPC, sString+"Arcane Caster Level = "+IntToString(nArcCasterLevel));
        SendMessageToPC(oPC, sString+"Divine Caster Level = "+IntToString(nDivCasterLevel));
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }

    if(!GetHasFeat(FEAT_CRAFT_WONDROUS))
    {
        SendMessageToPC(oPC, sString+"No craft wondrous items");
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }

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
	
    // Illithid only
    int nRace = GetRacialType(oPC);
    
    if (nRace != RACIAL_TYPE_ILLITHID)
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }  
}