/*
30/12/19 by Stratovarius

Apparition Ribbon Throat Bind

The wispy tendrils of the scarf lengthen and surround you as you appear to become incorporeal.

When you bind apparition ribbon to your throat chakra, you gain the ability to become incorporeal for brief periods of time. Activating this 
ability is a standard action, and your incorporealness lasts for 1 round plus 1 round per point of essentia invested in the soulmeld at the time 
it was activated. Each day, you can spend a total number of rounds incorporeal equal to your meldshaper level. 
*/

#include "moi_inc_moifunc"

void main()
{
	object oMeldshaper = OBJECT_SELF; 
    int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_APPARITION_RIBBON);   
    int nRounds = 1 + nEssentia;
    int nMeldshaperLevel = GetMeldshaperLevel(oMeldshaper, CLASS_TYPE_INCARNATE, MELD_APPARITION_RIBBON);
    int nUsed = GetLocalInt(oMeldshaper, "ApparitionRibbonRounds");
    int nRemaining = nMeldshaperLevel - nUsed;
    
    if (nRounds > nRemaining) nRounds = nRemaining;
    
    if (nRounds > 0)
    {
		SetIncorporeal(oMeldshaper, RoundsToSeconds(nRounds), 1);
		SetLocalInt(oMeldshaper, "ApparitionRibbonRounds", nRounds + nUsed);
	}	
}