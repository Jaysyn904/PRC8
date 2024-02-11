/*
   ----------------
   Conjunctive Gate

   true_utr_congate
   ----------------

    3/9/06 by Stratovarius
*/ /** @file

    Conjuunctive Gate

    Level: Perfected Map 4
    Range: Personal
    Duration: 1 Minute
    Spell Resistance: No
    Save: None
    Metautterances: Extend

    You forge a connection between this plane and another, temporarily linking them together with a swirling portal you speak into being.
    As the Gate spell. 
*/

#include "true_inc_trufunc"
#include "true_utterhook"
//#include "prc_alterations"
#include "inc_dynconv"

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
        if (!GetLocalInt(OBJECT_SELF, "DimAnchor"))
	{
		// This is done so Speak Unto the Masses can read it out of the structure
        	utter.fDur       = RoundsToSeconds(10);
        	if(utter.bExtend) utter.fDur *= 2;
        	SetLocalFloat(oTrueSpeaker, "TrueGateDuration", utter.fDur);
        	
        	StartDynamicConversation("true_gate_conv", oTrueSpeaker, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oTrueSpeaker);
	
        	// Mark for the Law of Sequence. This only happens if the utterance succeeds, which is why its down here.
        	DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
        }
        else
        {
        	FloatingTextStringOnCreature("You are under a Dimensional Anchor. Utterance fails.", OBJECT_SELF, FALSE);
        }
    }// end if - Successful utterance
}
