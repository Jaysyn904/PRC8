/*
7/1/20 by Stratovarius

Lucky Dice

Descriptors: None  
Classes: Incarnate, Soulborn 
Chakra: Hands
Saving Throw: None

With a flick of your wrist, you send two cubes spinning out of your open palm. With a flash, the dice disappear a moment after they stop rolling, and you sense that your luck is changing.

You can use your lucky dice as a swift action, choosing an aspect of yourself to which to apply extra luck. You gain a +1 luck bonus on one of the following, at your option: 
attack rolls and damage rolls, saving throws, or skill and ability checks. This bonus lasts until the start of your next turn. 
When using this meld, roll 2d6. If the result is any combination of numbers that add up to 7, the luck bonus applies to all of the listed types of rolls. 

Essentia: Every point of essentia invested in the lucky dice at the time you activate its special ability increases the duration of the luck bonus by 1 round. 
Because lucky dice can be rolled every round, it’s possible for the soulmeld to provide bonuses to more than one type of check during a given round. 
 
Chakra Bind (Hands)

Your comrades fight better when luck is on their side.

Your lucky dice provide their bonus to all allies who are within 30 feet of you when you gain the bonus. 
*/

#include "moi_inc_moifunc"

void LuckyDice(object oMeldshaper, int nMeld, int nLuck)
{
	int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_LUCKY_DICE); 
	float fDur = RoundsToSeconds(nEssentia);
	effect eLink;
	if (nMeld == MELD_LUCKY_DICE_ATTACK || nLuck)
	{
		eLink = EffectLinkEffects(eLink, EffectAttackIncrease(1));
		eLink = EffectLinkEffects(eLink, EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_BASE_WEAPON));
	}
	if (nMeld == MELD_LUCKY_DICE_SAVING_THROWS || nLuck)
		eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, 1));	
	if (nMeld == MELD_LUCKY_DICE_SKILLS || nLuck)
	{
		eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_ALL_SKILLS, 1));	
		SetLocalInt(oMeldshaper, "LuckyDiceAbility", TRUE);
		DelayCommand(fDur, DeleteLocalInt(oMeldshaper, "LuckyDiceAbility"));
	}	
}

void main()
{
	object oMeldshaper = OBJECT_SELF; 
    int nMeld = PRCGetSpellId();
    int nLuck = FALSE;
    if (d6(2) == 7) nLuck = TRUE;
    
    LuckyDice(oMeldshaper, nMeld, nLuck);

	if (GetIsMeldBound(oMeldshaper, MELD_LUCKY_DICE) == CHAKRA_HANDS)
	{
		location lTarget = GetLocation(oMeldshaper);
		float fRange = FeetToMeters(30.0);
	    object oSecondaryTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        while(GetIsObjectValid(oSecondaryTarget))
    	{
    		if(GetIsFriend(oMeldshaper, oSecondaryTarget))
    		{
    			LuckyDice(oSecondaryTarget, nMeld, nLuck);
			}
            oSecondaryTarget = GetNextObjectInShape(SHAPE_SPHERE, fRange, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    	}// end while - loop through all potential targets
    }	
}