/*
9/7/10 by Stratovarius

Embrace of Shadow

While you are thus cloaked in shadow, each attack made against you has a 10% miss chance per point of essentia invested in this ability. This miss chance does
not stack with miss chances provided by any other ability or effect.

If the miss chance granted by this ability is 20% or higher, you also gain the ability to hide in plain sight
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nBonus = GetEssentiaInvested(oMeldshaper) * 10;   

	if (nBonus)
	{
    	effect eLink = EffectLinkEffects(EffectConcealment(nBonus), EffectVisualEffect(PSI_DUR_SHADOW_BODY));

    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    	if (nBonus >= 20) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_HIDE_IN_PLAIN_SIGHT), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }	
    else
    	FloatingTextStringOnCreature("You have no essentia invested in "+GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", PRCGetSpellId()))), oMeldshaper, FALSE);    
}