/*
31/1/21 by Stratovarius

Psion-Killer Mask
Descriptor: None
Classes: Totemist
Chakra: Brow (totem)
Saving Throw: None

You craft incarnum into a red crystal mask that has sharp edges along its many facets. The crystal has an inner crimson glow that seems to intensify when near psionic energies.

You can use a detect psionics effect as the power, with a range of 10 feet. You can use this ability as often as desired, but no more than once per round (as a standard action).

Essentia: For every point of essentia you invest in your psion-killer mask, the range of the detect psionics effect increases by 10 feet.

Chakra Bind (Brow)

Your psion-killer mask binds to your forehead, and your eyes replace the red glow in the mask's sockets. Colors seem somehow more alive to your sight -- particularly the colors of psionic displays and items you know to be psionic.

When using this soulmeld's detect psionics ability, you can instantly determine the number, strength, and location of each psionic aura present as if you had been concentrating for 3 rounds. 
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-20 08:43:46
//::
//:: Double Chakra Bind support added
//::
//::////////////////////////////////////////////////////////
#include "prc_inc_s_det"
#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = OBJECT_SELF;
    float fDuration = TurnsToSeconds(10);
    int nRound = 0;
    float fRange = 10 + (10.0 * GetEssentiaInvested(oMeldshaper, MELD_PSIONKILLER_MASK));
    
    //if (GetIsMeldBound(oMeldshaper, MELD_PSIONKILLER_MASK) == CHAKRA_BROW) nRound = 3;
	
	int nBoundToBrow = FALSE;  
	if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_BROW)) == MELD_PSIONKILLER_MASK ||  
		GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_BROW)) == MELD_PSIONKILLER_MASK)  
		nBoundToBrow = TRUE;  
	  
	if (nBoundToBrow) nRound = 3;

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_DETECT), oMeldshaper, fDuration);

    DetectMagicAura(nRound, GetLocation(oMeldshaper), VFX_BEAM_MIND, FeetToMeters(fRange));
}