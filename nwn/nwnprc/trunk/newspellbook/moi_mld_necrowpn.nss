/*
20/1/20 by Stratovarius

Necrocarnum Weapon

Descriptors: Evil, necrocarnum
Classes: Incarnate, soulborn
Chakra: Hands
Saving Throw: None

Shadowy threads of necrocarnum bind to your melee weapon. This dark energy seems to ripple beneath the surface of the weapon, pulsing irregularly from your hands to the tip of the weapon and back again.

When you shape this soulmeld, your melee weapons bypass damage reduction of +3 or less

Essentia: For every point of essentia you invest in your necrocarnum weapon, you gain a +1.5 profane bonus on damage. This bonus applies only when the weapon is used against a living creature.

Chakra Bind (Hands)
When you have a necrocarnum weapon soulmeld bound to your hands chakra and you successfully make a critical hit with the weapon on a living creature, you gain temporary 
essentia equal to the number of points of essentia invested in this soulmeld. You can use this essentia normally, but it fades after 10 rounds. (Multiple uses of this ability don’t stack.)
*/

#include "moi_inc_moifunc"

effect NecrocarnumWeapon(int nEssentia)
{
	int nDam = IPGetDamageBonusConstantFromNumber(FloatToInt(nEssentia*1.5));
	effect eLink = EffectLinkEffects(VersusRacialTypeEffect(EffectDamageIncrease(nDam, DAMAGE_TYPE_NEGATIVE), RACIAL_TYPE_ABERRATION), VersusRacialTypeEffect(EffectDamageIncrease(nDam, DAMAGE_TYPE_NEGATIVE), RACIAL_TYPE_ANIMAL));
		   eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(EffectDamageIncrease(nDam, DAMAGE_TYPE_NEGATIVE), RACIAL_TYPE_BEAST));
		   eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(EffectDamageIncrease(nDam, DAMAGE_TYPE_NEGATIVE), RACIAL_TYPE_DRAGON));
		   eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(EffectDamageIncrease(nDam, DAMAGE_TYPE_NEGATIVE), RACIAL_TYPE_DWARF));
		   eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(EffectDamageIncrease(nDam, DAMAGE_TYPE_NEGATIVE), RACIAL_TYPE_ELEMENTAL));
		   eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(EffectDamageIncrease(nDam, DAMAGE_TYPE_NEGATIVE), RACIAL_TYPE_ELF));
		   eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(EffectDamageIncrease(nDam, DAMAGE_TYPE_NEGATIVE), RACIAL_TYPE_FEY));
		   eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(EffectDamageIncrease(nDam, DAMAGE_TYPE_NEGATIVE), RACIAL_TYPE_GIANT));
		   eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(EffectDamageIncrease(nDam, DAMAGE_TYPE_NEGATIVE), RACIAL_TYPE_GNOME));
		   eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(EffectDamageIncrease(nDam, DAMAGE_TYPE_NEGATIVE), RACIAL_TYPE_HALFELF));
		   eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(EffectDamageIncrease(nDam, DAMAGE_TYPE_NEGATIVE), RACIAL_TYPE_HALFLING));
		   eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(EffectDamageIncrease(nDam, DAMAGE_TYPE_NEGATIVE), RACIAL_TYPE_HALFORC));
		   eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(EffectDamageIncrease(nDam, DAMAGE_TYPE_NEGATIVE), RACIAL_TYPE_HUMAN));
		   eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(EffectDamageIncrease(nDam, DAMAGE_TYPE_NEGATIVE), RACIAL_TYPE_HUMANOID_GOBLINOID));
		   eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(EffectDamageIncrease(nDam, DAMAGE_TYPE_NEGATIVE), RACIAL_TYPE_HUMANOID_MONSTROUS));
		   eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(EffectDamageIncrease(nDam, DAMAGE_TYPE_NEGATIVE), RACIAL_TYPE_HUMANOID_ORC));
		   eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(EffectDamageIncrease(nDam, DAMAGE_TYPE_NEGATIVE), RACIAL_TYPE_HUMANOID_REPTILIAN));
		   eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(EffectDamageIncrease(nDam, DAMAGE_TYPE_NEGATIVE), RACIAL_TYPE_MAGICAL_BEAST));
		   eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(EffectDamageIncrease(nDam, DAMAGE_TYPE_NEGATIVE), RACIAL_TYPE_OOZE));
		   eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(EffectDamageIncrease(nDam, DAMAGE_TYPE_NEGATIVE), RACIAL_TYPE_OUTSIDER));
		   eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(EffectDamageIncrease(nDam, DAMAGE_TYPE_NEGATIVE), RACIAL_TYPE_SHAPECHANGER));
		   eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(EffectDamageIncrease(nDam, DAMAGE_TYPE_NEGATIVE), RACIAL_TYPE_VERMIN));
		   
	return eLink;
}

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nEssentia      = GetEssentiaInvested(oMeldshaper);

    effect eLink = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    if (nEssentia) eLink = EffectLinkEffects(eLink, NecrocarnumWeapon(nEssentia));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);      
    
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_NECROCARNUM_WEAPON), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
}