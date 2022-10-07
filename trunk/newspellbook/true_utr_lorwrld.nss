/*
   ----------------
   Lore of the World

   true_utr_lorwrld
   ----------------

    2/9/06 by Stratovarius
*/ /** @file

    Lore of the World

    Level: Perfected Map 3
    Range: Personal
    Duration: 1 Minute
    Spell Resistance: No
    Save: None
    Metautterances: Extend

    The world around you comes alive at your words, willing to share its ancient knowledge with you.
    You gain a Lore bonus equal to your Truenamer level.
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
    struct utterance utter = EvaluateUtterance(oTrueSpeaker, oTarget, METAUTTERANCE_EXTEND, LEXICON_PERFECTED_MAP);

    if(utter.bCanUtter)
    {
        // This is done so Speak Unto the Masses can read it out of the structure
        utter.fDur       = RoundsToSeconds(10);
        if(utter.bExtend) utter.fDur *= 2;
        utter.eLink = EffectLinkEffects(EffectSkillIncrease(SKILL_LORE, utter.nTruespeakerLevel), EffectVisualEffect(VFX_DUR_CROWN_OF_GLORY));
        utter.eLink2 = EffectVisualEffect(VFX_CONJ_MIND);
        
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, utter.eLink, oTarget, utter.fDur, TRUE, utter.nSpellId, utter.nTruespeakerLevel);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, utter.eLink2, oTarget);

        // Mark for the Law of Sequence. This only happens if the utterance succeeds, which is why its down here.
        DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
    }// end if - Successful utterance
}
