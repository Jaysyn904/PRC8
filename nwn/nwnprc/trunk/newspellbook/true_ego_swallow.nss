/*
   ----------------
   Cadence of the Swallowed Spell
   Acolyte of the Ego level 2+

   true_ego_fright
   ----------------

   25/8/18 by Stratovarius
*/ /** @file

Type of Feat: Class
Prerequisite: Acolye of the Ego 2+
Specifics: You gain spell resistance equal to 15 + 2 * the number of Morphic Cadences you know.
Use: Selected.
*/

#include "true_inc_trufunc"
#include "true_utterhook"

void main()
{
/*
  Spellcast Hook Code
  Added 2006-7-19 by Stratovarius
  If you want to make changes to all utterances
  check true_utterhook to find out more

*/

    if (!TruePreUtterCastCode())
    {
    // If code within the PreUtterCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    object oTrueSpeaker = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    // Cadences always use personal truenames, even when targeting another creature
    struct utterance utter = EvaluateUtterance(oTrueSpeaker, 
                                               oTrueSpeaker, 
                                               METAUTTERANCE_NONE/* Use METAUTTERANCE_NONE if it has no Metautterance usable*/, 
                                               LEXICON_EVOLVING_MIND /* Uses the same DC formula*/);

    if(utter.bCanUtter)
    {
    	int nClass = GetLevelByClass(CLASS_TYPE_ACOLYTE_EGO, oTrueSpeaker);
        // This is done so Speak Unto the Masses can read it out of the structure
        utter.fDur       = RoundsToSeconds(nClass);
        int nCadence = GetCadenceCount(oTrueSpeaker);
        int nSR = 15 + (2 * nCadence);
        effect eSR;
        
        int nCurrentSR = GetSpellResistance(oTarget);
	if (nSR > nCurrentSR)
	{
		eSR = EffectSpellResistanceIncrease(nSR - nCurrentSR); //It overwrites, doesn't stack with other SR
        }

    	effect eMind = EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION);
    	float fDelay;
    	//Link the fear and mind effects
    	utter.eLink = EffectLinkEffects(eSR, eMind);
    	
	// Duration Effects
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, utter.eLink, oTrueSpeaker, utter.fDur, TRUE, utter.nSpellId, utter.nTruespeakerLevel);

        // Mark for the Law of Sequence. This only happens if the cadence succeeds, which is why its down here.
        DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
    }// end if - Successful utterance
}
