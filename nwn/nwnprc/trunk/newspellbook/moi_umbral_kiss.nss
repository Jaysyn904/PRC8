/*
9/7/20 by Stratovarius

Umbral Disciple Kiss of the Shadows

Your reach increases by 5 feet for every point of essentia invested in this class feature.  
You must use the provided feat for this ability to function.
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nEssentia = GetEssentiaInvested(oMeldshaper); 
    if (nEssentia)
    {
	    effect eLink  = EffectVisualEffect(VFX_DUR_RESISTANCE);

    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    	IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_PRC_ATTACK), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }
    else
    	FloatingTextStringOnCreature("You have no essentia invested in "+GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", PRCGetSpellId()))), oMeldshaper, FALSE);
}