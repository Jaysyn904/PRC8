//::///////////////////////////////////////////////
//:: Ninja (Complete Adventurer) Passive Feats
//:: prc_ninja.nss
//:://////////////////////////////////////////////
//:: Check to see which Ninja feats a creature
//:: has and apply the appropriate bonuses.
//:://////////////////////////////////////////////
//:: Created By: Ryan Smith
//:: Created On: July 18, 2005
//:://////////////////////////////////////////////

#include "prc_inc_clsfunc"

void Ninja_GhostSight (object oPC, int bOn=TRUE)
{
	if (bOn)
	{
		effect eSeeInvis = SupernaturalEffect(EffectSeeInvisible());
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSeeInvis, oPC);
	}
	else
	{
		effect eCheck = GetFirstEffect(oPC);
		while(GetIsEffectValid(eCheck))
		{

			if ((GetEffectCreator(eCheck) == oPC) &&
				(GetEffectType(eCheck) == EFFECT_TYPE_SEEINVISIBLE) &&
				(GetEffectSubType(eCheck) == SUBTYPE_SUPERNATURAL))
			{
			// Remove the effect as it was created by us and is hopefully the right one
				RemoveEffect(oPC, eCheck);
				break;
			}
			eCheck = GetNextEffect(oPC);
		}
	}	
}

void main()
{
	object oPC = OBJECT_SELF;
	object oSkin = GetPCSkin(oPC);
	// all Ki powers will not function when wearing armor or encumbered
	int bEnabled = Ninja_AbilitiesEnabled(oPC);
		
	// determine which passive Ninja feats the char has
	int bKiPower = GetHasFeat(FEAT_KI_POWER, oPC) && bEnabled;
	int bAcro  = GetHasFeat(FEAT_ACROBATICS_2, oPC) ? 2 : 0;
	bAcro  = GetHasFeat(FEAT_ACROBATICS_4, oPC) ? 4 : bAcro;
	bAcro  = GetHasFeat(FEAT_ACROBATICS_6, oPC) ? 6 : bAcro;
	bAcro  = GetHasFeat(FEAT_EPIC_ACROBATICS_8, oPC) ? 8 : bAcro;
	bAcro  = GetHasFeat(FEAT_EPIC_ACROBATICS_10, oPC) ? 10 : bAcro;
	bAcro  = GetHasFeat(FEAT_EPIC_ACROBATICS_12, oPC) ? 12 : bAcro;
	if (!bEnabled)
		SendMessageToPC(oPC, "Your Ninja abilities are disabled because of encumbrance or armor.");
	
	Ninja_GhostSight(oPC, GetHasFeat(FEAT_GHOST_SIGHT, oPC));
	if (bKiPower)
		SetCompositeBonus(oSkin, "KiPowerWillBonus", 2, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_WILL);
	else
		SetCompositeBonus(oSkin, "KiPowerWillBonus", 0, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_WILL);

	if ((GetLevelByClass(CLASS_TYPE_MONK, oPC) > 0) || !bEnabled)
	{
		SetCompositeBonus(oSkin, "NinjaACBonus", 0, ITEM_PROPERTY_AC_BONUS);
	//	SendMessageToPC(oPC, "Setting to 0. Disabled.");
	}
	else
	{
		SetCompositeBonus(oSkin, "NinjaACBonus", GetAbilityModifier(ABILITY_WISDOM, oPC), ITEM_PROPERTY_AC_BONUS);
	//	SendMessageToPC(oPC, "Setting to "+IntToString(GetAbilityModifier(ABILITY_WISDOM, oPC)));
	}
	if (bAcro)
	{
		SetCompositeBonus(oSkin, "AcroJumpBonus", bAcro, ITEM_PROPERTY_SKILL_BONUS, SKILL_JUMP);
		SetCompositeBonus(oSkin, "AcroTumbBonus", bAcro, ITEM_PROPERTY_SKILL_BONUS, SKILL_TUMBLE);
	}
	else
	{
		SetCompositeBonus(oSkin, "AcroJumpBonus", 0, ITEM_PROPERTY_SKILL_BONUS, ITEM_PROPERTY_SKILL_BONUS);
		SetCompositeBonus(oSkin, "AcroTumbBonus", 0, ITEM_PROPERTY_SKILL_BONUS, ITEM_PROPERTY_SKILL_BONUS);
	}
}