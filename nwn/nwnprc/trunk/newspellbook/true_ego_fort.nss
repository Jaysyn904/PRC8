/*
   ----------------
   Cadence of the Living Fortress
   Acolyte of the Ego level 10+

   true_ego_fort
   ----------------

   25/8/18 by Stratovarius
*/ /** @file

Type of Feat: Class
Prerequisite: Acolye of the Ego 10+
Specifics: You gain a measure of resistance against critical hits for 1 round per class level. When a critical hit or sneak attack is scored against you, there is a 20% chance per morphic cadence you know (maximum 100% if you know five morphic cadences) that the critical hit or sneak attack is negated, and damage is rolled normally instead.
Use: Selected.

This feat can be taken at 10th level only because it's the only way to be sure that the critical hit protection is 100%.
*/

#include "true_inc_trufunc"
#include "true_utterhook"
//#include "prc_alterations"

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
        int nDR = 2 * GetCadenceCount(oTrueSpeaker);
        
        effect eDR = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
    	effect eMind = EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION);
    	
    	//Link the effects
    	utter.eLink = EffectLinkEffects(eDR, eMind);
    	
	// Duration Effects
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, utter.eLink, oTrueSpeaker, utter.fDur, TRUE, utter.nSpellId, utter.nTruespeakerLevel);

        // Mark for the Law of Sequence. This only happens if the cadence succeeds, which is why its down here.
        DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
    }// end if - Successful utterance
}
