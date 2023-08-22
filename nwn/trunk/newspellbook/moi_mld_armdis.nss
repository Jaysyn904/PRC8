/*
30/12/19 by Stratovarius

Armguards of Disruption

Descriptors: Good 
Classes: Incarnate, Soulborn 
Chakra: Arms
Saving Throw: None

Blue-sheened silver bracers form around your forearms. Blue-white sparks leap from your hand to undead creatures you touch.

While wearing armguards of disruption, you deal 1d6 points of damage to an undead creature with a successful melee touch attack. You can use armguards of disruption only once per round.

Essentia: Every point of essentia invested increases the damage dealt by your armguards of disruption by 1d6 points. 

Chakra Bind (Arms) 

Incarnum flows from the bracers to envelop you and then fades into invisibility. A corona of blue-white energy erupts when an undead creature attacks you, blocking its blows and suppressing its powers.

You gain an insight bonus to your AC and on your saving throws equal to the number of points of essentia invested in your armguards of disruption. These bonuses apply only against attacks made by undead creatures. 
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
    effect eLink;

    if (GetIsMeldBound(oMeldshaper)) eLink = EffectLinkEffects(VersusRacialTypeEffect(EffectACIncrease(nEssentia), RACIAL_TYPE_UNDEAD), VersusRacialTypeEffect(EffectSavingThrowIncrease(SAVING_THROW_ALL, nEssentia), RACIAL_TYPE_UNDEAD));

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_ARMGUARDS_OF_DISRUPTION), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_ARMGUARDS_OF_DISRUPTION_ARMS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
}