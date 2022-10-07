/*
7/1/20 by Stratovarius

Lucky Dice

Descriptors: None  
Classes: Incarnate, Soulborn 
Chakra: Hands
Saving Throw: None

With a flick of your wrist, you send two cubes spinning out of your open palm. With a flash, the dice disappear a moment after they stop rolling, and you sense that your luck is changing.

You can use your lucky dice as a swift action, choosing an aspect of yourself to which to apply extra luck. You gain a +1 luck bonus on one of the following, at your option: attack rolls and damage rolls, saving throws, or skill and ability checks. This bonus lasts until the start of your next turn. When using this meld, roll 2d6. If the result is any combination of numbers that add up to 7, the luck bonus applies to all of the listed types of rolls. 

Essentia: Every point of essentia invested in the lucky dice at the time you activate its special ability increases the duration of the luck bonus by 1 round. Because lucky dice can be rolled every round, it’s possible for the soulmeld to provide bonuses to more than one type of check during a given round. 
 
Chakra Bind (Hands)

Your comrades fight better when luck is on their side.

Your lucky dice provide their bonus to all allies who are within 30 feet of you when you gain the bonus. 
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);

    effect eLink       = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_LUCKY_DICE), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_LUCKY_DICE_LUCK), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
}