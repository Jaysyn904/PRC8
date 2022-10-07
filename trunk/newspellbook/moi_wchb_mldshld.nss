/*
26/1/21 by Stratovarius

Meldshield: Beginning at 1st level, you can use your
essentia to protect yourself against magical attacks. You
gain an insight bonus equal to the essentia invested in
this ability on all saving throws against spells and spelllike abilities.
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_WITCH_MELDSHIELD); 

    if (nEssentia) 
    {
    	effect eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, nEssentia, SAVING_THROW_TYPE_SPELL));
    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    }	
}