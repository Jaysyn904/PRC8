/*
   ----------------
   Transform the Landscape

   true_utr_trnlnd
   ----------------

    2/9/06 by Stratovarius
*/ /** @file

    Transform the Landscape

    Level: Perfected Map 2
    Range: 100 feet
    Area: 20' Radius
    Duration: 1 Minute
    Spell Resistance: No
    Save: None
    Metautterances: Extend

    You cause the grouns to crack and split beneath your enemies' feet, impeding their progress.
    All enemies in the area are affected by difficult terrain (50% movement speed reduction).
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
        
       	// eLink is used for Duration Effects (Buff/Penalty to AC)
      	utter.eLink = EffectAreaOfEffect(AOE_PER_TRANSFORM_LANDSCAPE);
      	
        // Duration Effects
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, utter.eLink, PRCGetSpellTargetLocation(), utter.fDur);

        // Mark for the Law of Sequence. This only happens if the utterance succeeds, which is why its down here.
        DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
    }// end if - Successful utterance
}
