#include "moi_inc_moifunc" 

void main()
{
	object oMeldshaper = OBJECT_SELF;
    if (TakeSwiftAction(oMeldshaper))
    {
		int nEssentia = GetEssentiaInvestedFeat(oMeldshaper, FEAT_HEALING_SOUL);
		if (GetCanBindChakra(oMeldshaper, CHAKRA_SOUL)) nEssentia *= 2;
	
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nEssentia), oMeldshaper);
    }	
}
