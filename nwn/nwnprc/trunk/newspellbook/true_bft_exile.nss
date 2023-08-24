/*
   ----------------
   Syllable of Exile
   Bereft level 3

   true_bft_exile
   ----------------

   19/7/06 by Stratovarius
*/ /** @file

Type of Feat: Class
Prerequisite: Bereft 3
Specifics: When the Bereft successfully speak this syllable, the target is affected as by the Maze spell, for one round.
Use: Selected.
*/

#include "true_inc_trufunc"
#include "true_utterhook"
//#include "prc_alterations"
#include "spinc_maze"

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
        utter.fDur       = HoursToSeconds(24);

	// If the Spell Penetration fails, don't apply any effects
        if (!PRCDoResistSpell(oTrueSpeaker, oTarget, utter.nPen))
        {
        	// Get the maze area
        	object oMazeArea = GetObjectByTag("prc_maze_01");
	
        	if(DEBUG && !GetIsObjectValid(oMazeArea))
        	    DoDebug("Maze: ERROR: Cannot find maze area!", oTrueSpeaker);
	
        	// Determine which entry to use
        	int nMaxEntry = GetLocalInt(oMazeArea, "PRC_Maze_Entries_Count");
        	int nEntry = Random(nMaxEntry) + 1;
        	object oEntryWP = GetWaypointByTag("PRC_MAZE_ENTRY_WP_" + IntToString(nEntry));
        	location lTarget = GetLocation(oEntryWP);
	
        	// Validity check
        	if(DEBUG && !GetIsObjectValid(oEntryWP))
        	    DoDebug("Maze: ERROR: Selected waypoint does not exist!");
	
        	// Make sure the target can be teleported
        	if(GetCanTeleport(oTarget, lTarget, TRUE))
        	{
        	    // Store the target's current location for return
        	    SetLocalLocation(oTarget, "PRC_Maze_Return_Location", GetLocation(oTarget));
	
        	    // Jump the target to the maze - the maze's scripts will handle the rest
        	    DelayCommand(1.5f, AssignCommand(oTarget, JumpToLocation(lTarget)));
	
        	    // Clear the action queue, so there's less chance of getting to abuse the ghost effect
        	    AssignCommand(oTarget, ClearAllActions());
	
        	    // Make the character ghost for the duration of the maze. Apply here so the effect gets a spellID association
        	    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneGhost(), oTarget, 6.0f);
        	    
		    // Jump the target back out, its only there for a round
        	    DelayCommand(6.0f, AssignCommand(oTarget, JumpToLocation(GetLocalLocation(oTarget, "PRC_Maze_Return_Location"))));        	    
	
        	    // Apply some VFX
        	    DoMazeVFX(GetLocation(oTarget));
        	}
        	else
        	    SendMessageToPCByStrRef(oTrueSpeaker, 16825702); // "The spell fails - the target cannot be teleported."
        }
        // If either of these ApplyEffect isn't needed, delete it.
        // Duration Effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, utter.eLink, oTarget, utter.fDur, TRUE, utter.nSpellId, utter.nTruespeakerLevel);

        // Mark for the Law of Sequence. This only happens if the power succeeds, which is why its down here.
        DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
    }// end if - Successful utterance
}
