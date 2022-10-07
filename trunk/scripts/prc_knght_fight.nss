//::///////////////////////////////////////////////
//:: Knight - Fighting Challenge
//:: prc_knght_fightc.nss
//:://////////////////////////////////////////////
//:: Applies a temporary Dam, Will and Attack bonus vs
//:: monsters of the targets racial type
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: July 1, 2007
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_class_const"

int GetIntToDamage(int nCheck)
{
    int IntToDam = -1;

    if (nCheck == 1)
    {
        IntToDam = DAMAGE_BONUS_1;
    }
    else if (nCheck == 2)
    {
        IntToDam = DAMAGE_BONUS_2;
    }
    else if (nCheck == 3)
    {
        IntToDam = DAMAGE_BONUS_3;
    }
    else if (nCheck == 4)
    {
        IntToDam = DAMAGE_BONUS_4;
    }
    else if (nCheck == 5)
    {
        IntToDam = DAMAGE_BONUS_5;
    }
    else if (nCheck == 6)
    {
        IntToDam = DAMAGE_BONUS_6;
    }
    else if (nCheck == 7)
    {
        IntToDam = DAMAGE_BONUS_7;
    }
    else if (nCheck == 8)
    {
        IntToDam = DAMAGE_BONUS_8;
    }
    else if (nCheck == 9)
    {
        IntToDam = DAMAGE_BONUS_9;
    }
    else if (nCheck == 10)
    {
        IntToDam = DAMAGE_BONUS_10;
    }
    else if (nCheck == 11)
    {
        IntToDam = DAMAGE_BONUS_11;
    }
    else if (nCheck == 12)
    {
        IntToDam = DAMAGE_BONUS_12;
    }
    else if (nCheck == 13)
    {
        IntToDam = DAMAGE_BONUS_13;
    }
    else if (nCheck == 14)
    {
        IntToDam = DAMAGE_BONUS_14;
    }
    else if (nCheck == 15)
    {
        IntToDam = DAMAGE_BONUS_15;
    }
    else if (nCheck == 16)
    {
        IntToDam = DAMAGE_BONUS_16;
    }
    else if (nCheck == 17)
    {
        IntToDam = DAMAGE_BONUS_17;
    }
    else if (nCheck == 18)
    {
        IntToDam = DAMAGE_BONUS_18;
    }
    else if (nCheck == 19)
    {
        IntToDam = DAMAGE_BONUS_19;
    }
    else if (nCheck >= 20)
    {
        IntToDam = DAMAGE_BONUS_20;
    }

    return IntToDam;
}

void main()
{
	//Declare main variables.
	object oPC = OBJECT_SELF;
	object oTarget = PRCGetSpellTargetObject();
	int nRace = MyPRCGetRacialType(oTarget);
	int nClass = GetLevelByClass(CLASS_TYPE_KNIGHT, oPC);
	int nDur = 5 + GetAbilityModifier(ABILITY_CHARISMA, oPC);
	int nBonus = 1;
	
	// Bonus grows at these levels.
	if (nClass >= 19) nBonus = 4;
	else if (nClass >= 13) nBonus = 3;
	else if (nClass >= 7) nBonus = 2;
	
	
	if(GetHasSpellEffect(SPELL_FIGHT_CHALLENGE, oPC))
	{
		IncrementRemainingFeatUses(oPC, FEAT_FIGHT_CHALLENGE);
		return;
	}
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
	// CR check
	if ((IntToFloat(GetHitDice(oPC) - 2)) >= GetChallengeRating(oTarget) || 5 > GetAbilityScore(oTarget, ABILITY_INTELLIGENCE)) // Fail, unworthy
	{
		FloatingTextStringOnCreature(GetName(oTarget) + " is not worthy of a Knight's Challenge", oPC, FALSE);
		return;
	}
	
	effect eAttack = EffectAttackIncrease(nBonus);
	effect eSave = EffectSavingThrowIncrease(SAVING_THROW_WILL, nBonus);
	effect eDam  = EffectDamageIncrease(GetIntToDamage(nBonus));
	
	effect eLink = EffectLinkEffects(eAttack, eSave);
	eLink = EffectLinkEffects(eLink, eDam);

	eLink = VersusRacialTypeEffect(eLink, nRace);
	
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds(nDur));
}
