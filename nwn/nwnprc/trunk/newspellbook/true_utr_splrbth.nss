/*
   ----------------
   Spell Rebirth
   
   true_utr_splrbth
   ----------------

    3/8/06 by Stratovarius
*/ /** @file

    Spell Rebirth

    Level: Evolving Mind 4
    Range: 60 feet
    Target: One Creature
    Duration: Instantaneous
    Spell Resistance: Yes
    Save: None
    Metautterances: None

    Normal:  You briefly unwind time to restore lost magic when you speak this utterance.
             Restore one spell dispelled in the last round.
    Reverse: Your words strip away a magical effect from your target.
             Dispel the highest caster level spell on the target.
*/

#include "true_inc_trufunc"
#include "true_utterhook"
#include "inc_dispel"

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
    
        // The NORMAL effect of the Utterance goes here
        if (utter.nSpellId == UTTER_SPELL_REBIRTH)
        {
        	// Used to Ignore SR in Speak Unto the Masses for friendly utterances.
        	utter.bIgnoreSR = TRUE;
        	// This utterance applies only to friends
        	utter.bFriend = TRUE;
        	// Recast the spell on the target (Yes I know this isn't exact)
        	int nSpell = GetLocalInt(oTarget, "TrueSpellRebirthSpellId");
        	int nCasterLvl = GetLocalInt(oTarget, "TrueSpellRebirthCasterLvl");
        	ActionCastSpell(nSpell, nCasterLvl);
        	
        }
        // The REVERSE effect of the Utterance goes here
        else // UTTER_SPELL_REBIRTH_R
        {
        	// Automatically Dispels the highest caster level spell
        	DispelMagicBestMod(oTarget, 99);
        }
        // Duration Effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, utter.eLink, oTarget, utter.fDur, TRUE, utter.nSpellId, utter.nTruespeakerLevel);
        
        // Speak Unto the Masses. Swats an area with the effects of this utterance
        DoSpeakUntoTheMasses(oTrueSpeaker, oTarget, utter);
    }// end if - Successful utterance    
}
