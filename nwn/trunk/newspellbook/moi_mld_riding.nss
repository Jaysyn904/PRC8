/*
11/1/20 by Stratovarius

Riding Bracers

Descriptors: None  
Classes: Incarnate, Soulborn, Totemist 
Chakra: Arms (totem) 
Saving Throw: None

You form incarnum into a pair of hard leather bracers that encircle your wrists. They smell noticeably of horse and hay.

Wearing the riding bracers grants you a +4 insight bonus on Animal Empathy and Ride checks. 

Essentia: Every point of essentia invested in the riding bracers increases the insight bonus on Animal Empathy and Ride checks by 2.

Chakra Bind (Arms) 

Your riding bracers clench tight around your wrists. When you mount a steed, your bracers almost seem to guide your hands on the reins. When you draw a weapon while mounted, you, your mount, and your weapon all seem to move in a coordinated, deadly dance.

When mounted, you gain a +2 insight bonus on melee damage rolls and a +2 dodge bonus to Armor Class. 

Chakra Bind (Totem) 

There is no change in the appearance of your riding bracers, but when you mount a steed, you feel a close connection with the animal. It almost seems to respond to your mental commands as much as to your hands on the reins.

When mounted, you gain evasion. 
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
	int nBonus         = 4+(nEssentia*2);
    effect eLink       = EffectLinkEffects(EffectSkillIncrease(SKILL_ANIMAL_EMPATHY, nBonus), EffectSkillIncrease(SKILL_RIDE, nBonus));

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_RIDING_BRACERS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING); 
}