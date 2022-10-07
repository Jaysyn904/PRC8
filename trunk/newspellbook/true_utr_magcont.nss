/*
   ----------------
   Magical Contraction

   true_utr_magcont
   ----------------

   3/8/06 by Stratovarius
*/ /** @file

    Magical Contraction
    
    Level: Evolving Mind 4
    Range: 60 feet
    Target: One Creature
    Duration: 5 Round
    Spell Resistance: No
    Save: None
    Metautterances: Extend

    Normal:  You make your target resilient against magical effects.
             Your ally gains SR of 11 + Truenamer level.
    Reverse: A string of complex syllables allows you to enhance the power of an ally's spells for a short time.
             Your ally's spells are automatically Empowered.
*/

#include "true_inc_trufunc"
#include "true_utterhook"
//#include "prc_alterations"

void main()
{
    if(!TruePreUtterCastCode()) return;

    object oTrueSpeaker = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    struct utterance utter = EvaluateUtterance(oTrueSpeaker, oTarget, METAUTTERANCE_EXTEND, LEXICON_EVOLVING_MIND);

    if(utter.bCanUtter)
    {
        // This utterance applies only to friends
        utter.bFriend = TRUE;
        utter.fDur = RoundsToSeconds(5);
        if(utter.bExtend) utter.fDur *= 2;
        // Used to Ignore SR in Speak Unto the Masses for friendly utterances.
        utter.bIgnoreSR = TRUE;
        // This utterance applies only to friends
        utter.bFriend = TRUE;

        // The NORMAL effect of the Utterance goes here
        if(utter.nSpellId == UTTER_MAGICAL_CONTRACTION)
        {
            int nSR = 11 + utter.nTruespeakerLevel;
            // SR
            utter.eLink = EffectLinkEffects(EffectSpellResistanceIncrease(nSR), EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION));
        }
        // The REVERSE effect of the Utterance goes here
        else // UTTER_MAGICAL_CONTRACTION_R
        {
            // Empower
            //SetLocalInt(oTarget, "TrueMagicalContraction", TRUE);
            //DelayCommand(utter.fDur, DeleteLocalInt(oTarget, "TrueMagicalContraction"));
            utter.eLink = EffectVisualEffect(VFX_DUR_SHIELD_OF_LAW);
        }
        // Duration Effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, utter.eLink, oTarget, utter.fDur, TRUE, utter.nSpellId, utter.nTruespeakerLevel);

        // Speak Unto the Masses. Swats an area with the effects of this utterance
        DoSpeakUntoTheMasses(oTrueSpeaker, oTarget, utter);
        // Mark for the Law of Sequence. This only happens if the utterance succeeds, which is why its down here.
        // The utterance isn't active if SR stops it
        DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
    }// end if - Successful utterance    
}
