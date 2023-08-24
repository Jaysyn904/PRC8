/*
   ----------------
   Essence of Lifespark

   true_utr_esslife
   ----------------

    4/8/06 by Stratovarius
*/ /** @file

    Essence of Lifespark

    Level: Evolving Mind 5
    Range: 60 feet
    Target: One Creature
    Duration: Instantaneous
    Spell Resistance: Yes
    Save: None
    Metautterances: None

    Normal:  With soothing words, you revitalize an ally and restore some of his lost vitality. 
             You clean your target of negative levels.
    Reverse: You instruct the universe to sap some of the life force of a target creature.
             Your target gains a negative level.
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
    struct utterance utter = EvaluateUtterance(oTrueSpeaker, oTarget, METAUTTERANCE_NONE, LEXICON_EVOLVING_MIND);

    if(utter.bCanUtter)
    {
	// This is done so Speak Unto the Masses can read it out of the structure
        utter.nPen       = GetTrueSpeakPenetration(oTrueSpeaker); 	
        int nSRCheck;
        
        // The NORMAL effect of the Utterance goes here
        if (utter.nSpellId == UTTER_ESSENCE_LIFESPARK)
        {
        	// Used to Ignore SR in Speak Unto the Masses for friendly utterances.
        	utter.bIgnoreSR = TRUE;
        	// This utterance applies only to friends
        	utter.bFriend = TRUE;
        	
            	effect eFear = GetFirstEffect(oTarget);
            	//Get the first effect on the current target
            	while(GetIsEffectValid(eFear))
            	{
            	    if (GetEffectType(eFear) == EFFECT_TYPE_NEGATIVELEVEL)
            	    {
            	        //Remove any fear effects and apply the VFX impact
            	        RemoveEffect(oTarget, eFear);
            	    }
            	    //Get the next effect on the target
            	    eFear = GetNextEffect(oTarget);
            	}
        	utter.eLink2 = EffectVisualEffect(VFX_IMP_REMOVE_CONDITION);
        }
        // The REVERSE effect of the Utterance goes here
        else // UTTER_ESSENCE_LIFESPARK_R
        {
        	// If the Spell Penetration fails, don't apply any effects
        	// Its done this way so the law of sequence is applied properly
        	nSRCheck = PRCDoResistSpell(oTrueSpeaker, oTarget, utter.nPen);
        	if (!nSRCheck)
        	{
			utter.eLink2 = EffectLinkEffects(EffectNegativeLevel(1), EffectVisualEffect(VFX_IMP_NEGBLAST_ENERGY));
        	}
        }
        // Impact Effects
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, utter.eLink2, oTarget);
        
        // Speak Unto the Masses. Swats an area with the effects of this utterance
        DoSpeakUntoTheMasses(oTrueSpeaker, oTarget, utter);
        // Mark for the Law of Sequence. This only happens if the utterance succeeds, which is why its down here.
        // The utterance isn't active if SR stops it
        if (!nSRCheck) DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
    }// end if - Successful utterance    
}