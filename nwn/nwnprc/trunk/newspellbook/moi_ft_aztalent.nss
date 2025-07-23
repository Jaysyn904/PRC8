#include "moi_inc_moifunc" 
#include "psi_inc_psifunc"

void main()
{
	object oMeldshaper = OBJECT_SELF;
	int nEssentia = GetEssentiaInvestedFeat(oMeldshaper, FEAT_AZURE_TALENT);
	if (GetCanBindChakra(oMeldshaper, CHAKRA_CROWN)) nEssentia += 2;
	
	GainPowerPoints(oMeldshaper, nEssentia, TRUE, TRUE);
}