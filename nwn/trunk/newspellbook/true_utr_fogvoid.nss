/*
   ----------------
   Fog from the Void

   true_utr_fogvoid
   ----------------

    1/9/06 by Stratovarius
*/ /** @file

    Fog from the Void

    Level: Perfected Map 1
    Range: 100 feet
    Area: 20' Radius 
    Duration: 1 Minute
    Spell Resistance: No
    Save: None
    Metautterances: Extend

    At your words, moisture in the air and ground condenses into a thick mist.
    You create a thick, roiling cloud of fog like the fog cloud spell.
    If you add 10 to the DC of your Truespeak check, you can create a solid fog, as the spell.
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
        utter.fDur = TurnsToSeconds(1);
        if(utter.bExtend) utter.fDur *= 2;

        // The NORMAL effect of the Utterance goes here
        if (utter.nSpellId == UTTER_FOG_VOID_CLOUD)
        {
            // eLink is used for Duration Effects (Buff/Penalty to AC)
            utter.eLink = EffectAreaOfEffect(AOE_PER_FOG_VOID_CLOUD);
        }
        // The REVERSE effect of the Utterance goes here
        else /* Effects of UTTER_FOG_VOID_SOLID would be here */
        {
            // eLink is used for Duration Effects (Buff/Penalty to AC)
            utter.eLink = EffectAreaOfEffect(AOE_PER_FOG_VOID_SOLID);
        }
        // If either of these ApplyEffect isn't needed, delete it.
        // Duration Effects
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, utter.eLink, PRCGetSpellTargetLocation(), utter.fDur);

        // Mark for the Law of Sequence. This only happens if the utterance succeeds, which is why its down here.
        DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
    }// end if - Successful utterance
}
