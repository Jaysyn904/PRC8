/*
30/12/19 by Stratovarius

Basilisk Mask Totem Bind

Behind the mask, your eyes glow with a pale green radiance that is clearly visible through the eyes of the basilisk. There is a sense of weight in your forehead, but it is not entirely unpleasant—more like a power anxious to be exercised.

By directing your gaze on a creature within 30 feet, you can temporarily turn that creature to stone (as the flesh to stone spell, except that the duration is only 1 round). A successful Fortitude save negates this effect.
*/

#include "moi_inc_moifunc"
#include "prc_inc_sp_tch"

void main()
{
	object oMeldshaper = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject(); 
    int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_BASILISK_MASK); 
	int nMeldshaperLvl;
    int nDC = GetMeldshaperDC(oMeldshaper, CLASS_TYPE_TOTEMIST, MELD_BASILISK_MASK);
    
    // Only creatures, and PvP check.
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        // Check Spell Resistance
        if(!PRCDoResistSpell(oMeldshaper, oTarget, nMeldshaperLvl))
        {                
			if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
			{
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectPetrify(), oTarget, 6.0);
			}
        }    
    }
}