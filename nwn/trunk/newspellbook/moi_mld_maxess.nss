/*
29/12/19 by Stratovarius

Applies the maximum essentia to the calling soulmeld, and resets all other melds
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper  = OBJECT_SELF;
    if (GetLocalInt(oMeldshaper, "PerfectMeldshaper")) return;
    if(TakeSwiftAction(oMeldshaper))
    {
    	if (GetTemporaryEssentia(oMeldshaper))
    	{
    		int nMeld = EssentiaIDToRealID(PRCGetSpellId());
    		SetLocalInt(oMeldshaper, "InvestingTempEssentia", TRUE);
    		InvestEssentia(oMeldshaper, nMeld, GetTemporaryEssentia(oMeldshaper));
    		ShapeSoulmeld(oMeldshaper, nMeld);
    	}
    	else
    	{
			DrainEssentia(oMeldshaper);	
			InvestEssentia(oMeldshaper, EssentiaIDToRealID(PRCGetSpellId()), 99);
			WipeMelds(oMeldshaper);
			ReshapeMelds(oMeldshaper);
		}	
	}	
}