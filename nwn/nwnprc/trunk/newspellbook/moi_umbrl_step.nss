/*
9/7/10 by Stratovarius

Step of the Bodiless

Beginning at 1st level, you gain a +2 enhancement bonus on Balance, Climb, Jump, and Tumble checks for every
point of essentia you invest in this class feature.
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nBonus = GetEssentiaInvested(oMeldshaper) * 2;   

	if (nBonus)
	{
    	effect eLink = EffectLinkEffects(EffectSkillIncrease(SKILL_TUMBLE, nBonus), EffectSkillIncrease(SKILL_BALANCE, nBonus));
    	       eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_JUMP, nBonus));
    	       eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_CLIMB, nBonus));

    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    }	
    else
    	FloatingTextStringOnCreature("You have no essentia invested in "+GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", PRCGetSpellId()))), oMeldshaper, FALSE);    
}