/*
27/1/21 by Stratovarius

Open Soul Chakra
Type of Feat: Incarnum
Prerequisites: Con 21, character level 24th.
Benefit: You can now bind a soulmeld to your soul chakra. In addition, you gain a +2 insight bonus on damage rolls made against creatures whose alignment opposes any component of your alignment. 
For example, a lawful good character would gain this bonus against chaotic creatures and against evil creatures.
Use: Automatic
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
    effect eLink       = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

	if (GetAlignmentGoodEvil(oMeldshaper) == ALIGNMENT_GOOD)    eLink = EffectLinkEffects(eLink, VersusAlignmentEffect(EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_POSITIVE), ALIGNMENT_EVIL));
	if (GetAlignmentLawChaos(oMeldshaper) == ALIGNMENT_LAWFUL)  eLink = EffectLinkEffects(eLink, VersusAlignmentEffect(EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_POSITIVE), ALIGNMENT_CHAOTIC));
	if (GetAlignmentLawChaos(oMeldshaper) == ALIGNMENT_CHAOTIC) eLink = EffectLinkEffects(eLink, VersusAlignmentEffect(EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_POSITIVE), ALIGNMENT_LAWFUL));
	if (GetAlignmentGoodEvil(oMeldshaper) == ALIGNMENT_EVIL)    eLink = EffectLinkEffects(eLink, VersusAlignmentEffect(EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_POSITIVE), ALIGNMENT_GOOD));

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);	
}