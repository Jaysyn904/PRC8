//::///////////////////////////////////////////////
//:: Knight - Loyal Beyond Death
//:: prc_knght_loyal.nss
//:://////////////////////////////////////////////
//:: Can't die for one round.
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: July 1, 2007
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
	//Declare main variables.
	object oPC = OBJECT_SELF;
	object oTarget = PRCGetSpellTargetObject();
	int nRace = MyPRCGetRacialType(oTarget);
	int nClass = GetLevelByClass(CLASS_TYPE_KNIGHT, oPC);
	int nDur = 5 + GetAbilityModifier(ABILITY_CHARISMA, oPC);
	int nBonus = 1;

	int nKC = GetLocalInt(oPC, "KnightsChallenge");
	
	if (nKC > 0)
	{
		FloatingTextStringOnCreature("You have " +IntToString(nKC) + " uses of Knight's Challenge remaining", oPC, FALSE);
		// Subtract a use
		SetLocalInt(oPC, "KnightsChallenge", nKC - 1);
	}
	else // Fail, no more uses
	{
		FloatingTextStringOnCreature("You have no more uses of Knight's Challenge remaining", oPC, FALSE);
		return;
	}
            if(!GetImmortal(oPC))
            {
                SetImmortal(oPC, TRUE);
		DelayCommand(6.0, SetImmortal(oPC, FALSE));
            }
}
