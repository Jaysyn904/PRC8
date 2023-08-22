//::///////////////////////////////////////////////
//:: Knight - Daunting Challenge
//:: prc_knght_Daunt.nss
//:://////////////////////////////////////////////
//:: Mass Shake Enemies
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: July 1, 2007
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
	//Declare main variables.
	object oPC = OBJECT_SELF;
	object oTarget = PRCGetSpellTargetObject();
	int nRace = MyPRCGetRacialType(oTarget);
	int nClass = GetLevelByClass(CLASS_TYPE_KNIGHT, oPC);
	int nDur = 5 + GetAbilityModifier(ABILITY_CHARISMA, oPC);
	int nDC = 10 + (nClass/2) + GetAbilityModifier(ABILITY_CHARISMA, oPC);
        effect eVis = EffectVisualEffect(VFX_IMP_DOOM);
    	effect eLink = EffectShaken();	
	
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
	
	//Get first target in spell area
	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(100.0), GetLocation(OBJECT_SELF));
	while(GetIsObjectValid(oTarget))
	{
	        // Worthy Targets
	        if ((GetChallengeRating(oTarget) >= IntToFloat(GetHitDice(oPC) - 2)) && GetAbilityScore(oTarget, ABILITY_INTELLIGENCE) >= 5)
	        {
	            if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC))
                    {
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink , oTarget, RoundsToSeconds(nDur));
	            }
	        }
	        
	//Get next target in spell area
	oTarget = GetNextObjectInShape(SHAPE_SPHERE, FeetToMeters(100.0), GetLocation(OBJECT_SELF));
    	}
}
