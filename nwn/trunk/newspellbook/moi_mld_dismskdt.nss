/*
1/1/20 by Stratovarius

Disenchanter Mask

Descriptors: Light 
Classes: Totemist
Chakra: Brow (Totem)
Saving Throw: None

You shape incarnum into a silvery mask with a long snout, clubbed protrusions at the crown, and a long, forked tongue. The silver scales of the mask glint and gleam in the light, and the tongue seems to sway of its own accord.

You can use a detect magic effect as the spell, with a range of 10 feet.

Essentia: Every point of essentia invested in this soulmeld increases the range by 10 feet.

Chakra Bind (Brow)

Your disenchanter mask binds to your forehead, and your eyes replace the glassy black eyes in the mask’s sockets. Colors seem somehow more alive to your sight—particularly the colors of spell effects and items that you know to be magical.

When using this soulmeld’s detect magic ability, you can instantly determine the number, strength, and location of each magical aura present as if you had been concentrating for 3 rounds. 
*/

#include "prc_inc_s_det"
#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = OBJECT_SELF;
    float fDuration = TurnsToSeconds(10);
    int nRound = 0;
    float fRange = 10 + (10.0 * GetEssentiaInvested(oMeldshaper, MELD_DISENCHANTER_MASK));
    
    if (GetIsMeldBound(oMeldshaper, MELD_DISENCHANTER_MASK) == CHAKRA_BROW) nRound = 3;

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_DETECT), oMeldshaper, fDuration);

    DetectMagicAura(nRound, GetLocation(oMeldshaper), VFX_BEAM_MIND, FeetToMeters(fRange));
}