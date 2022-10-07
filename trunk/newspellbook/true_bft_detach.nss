/*
   ----------------
   Syllable of Detachment
   Bereft level 1

   true_bft_detach
   ----------------

   19/7/06 by Stratovarius
*/ /** @file

Type of Feat: Class
Prerequisite: Bereft 1
Specifics: When the Bereft successfully speak this syllable, the target takes a -2 penalty to skills, AB, and saves for a number of rounds equal to the Bereft's class level.
Use: Selected.
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
    struct utterance utter = EvaluateUtterance(oTrueSpeaker, 
                                               oTarget, 
                                               METAUTTERANCE_NONE/* Use METAUTTERANCE_NONE if it has no Metautterance usable*/, 
                                               LEXICON_EVOLVING_MIND /* Uses the same DC formula*/);

    if(utter.bCanUtter)
    {
        // This is done so Speak Unto the Masses can read it out of the structure
        utter.nPen       = GetTrueSpeakPenetration(oTrueSpeaker);
        utter.fDur       = RoundsToSeconds(GetLevelByClass(CLASS_TYPE_BEREFT, oTrueSpeaker));
        if(utter.bExtend) utter.fDur *= 2;

	// If the Spell Penetration fails, don't apply any effects
        if (!PRCDoResistSpell(oTrueSpeaker, oTarget, utter.nPen))
        {
       		// eLink is used for Duration Effects (Penalty to AB etc)
       		utter.eLink = EffectLinkEffects(EffectAttackDecrease(2), EffectSavingThrowDecrease(SAVING_THROW_ALL, 2));
       		utter.eLink = EffectLinkEffects(utter.eLink, EffectSkillDecrease(SKILL_ALL_SKILLS, 2));
       		utter.eLink = EffectLinkEffects(utter.eLink, EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MAJOR));
        }
        // If either of these ApplyEffect isn't needed, delete it.
        // Duration Effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, utter.eLink, oTarget, utter.fDur, TRUE, utter.nSpellId, utter.nTruespeakerLevel);

        // Mark for the Law of Sequence. This only happens if the power succeeds, which is why its down here.
        DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
    }// end if - Successful utterance
}
