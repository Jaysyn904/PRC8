/*
20/1/20 by Stratovarius

Duskling Speed

Duskling base speed is 30 feet. However, a duskling can invest essentia to improve this speed. 
For every point of essentia invested in this racial trait, the duskling’s speed improves by 5 feet. 
This enhancement bonus only applies when the duskling is wearing light or no armor and carrying no more than a light load. 
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
    effect eLink       = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
}