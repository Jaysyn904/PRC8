//::///////////////////////////////////////////////
//:: Jump Skill
//:://////////////////////////////////////////////
//:: 
//:: Jumps to target if pass check, or fall over if fail
//:: 
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:: Created On: Sept 4, 2004
//:://////////////////////////////////////////////
//#include "prc_alterations"
#include "prc_inc_spells"

void main()
{
	object oPC			= OBJECT_SELF;
	float fSize 		= 14.0f;
	//location lPretarget	= PRCGetSpellTargetLocation();
	//location lPC 		= GetLocation(oPC);
	
	//float fDistance		= GetDistanceBetweenLocations(lPretarget, lPC);
	
    SetEnterTargetingModeData(oPC, SPELL_TARGETING_SHAPE_RECT, fSize, 1.5f, SPELL_TARGETING_FLAGS_ORIGIN_ON_SELF | SPELL_TARGETING_FLAGS_HARMS_ENEMIES, fSize);
    PRCEnterTargetingMode(oPC, OBJECT_TYPE_TILE, MOUSECURSOR_MAGIC, "PRC_JUMP");
	
}