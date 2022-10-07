/*
9/7/10 by Stratovarius

Sight of the Eyeless

You gain +2 Spot per point of essentia invested. You also can see invisible.
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nBonus = GetEssentiaInvested(oMeldshaper) * 2;   

	if (nBonus)
	{
    	effect eLink = EffectLinkEffects(EffectSkillIncrease(SKILL_SPOT, nBonus), EffectSeeInvisible());
    		   eLink = EffectLinkEffects(eLink, EffectUltravision());

    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    }	
    else
    	FloatingTextStringOnCreature("You have no essentia invested in "+GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", PRCGetSpellId()))), oMeldshaper, FALSE);    
}