/*
   ----------------
   Master the Four Winds

   true_utr_mstwnds
   ----------------

    2/9/06 by Stratovarius
*/ /** @file

    Master the Four Winds

    Level: Perfected Map 3
    Range: 100 feet
    Area: 20' Radius
    Duration: Instantaneous
    Spell Resistance: No
    Save: None
    Metautterances: None

    The air reacts to your utterance, obeying your every command.
    The area is affected as if by the Gust of Wind spell.
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
    struct utterance utter = EvaluateUtterance(oTrueSpeaker, oTarget, METAUTTERANCE_NONE, LEXICON_PERFECTED_MAP);

    if(utter.bCanUtter)
    {
        // This is done so Speak Unto the Masses can read it out of the structure
        utter.fDur       = RoundsToSeconds(10);
        if(utter.bExtend) utter.fDur *= 2;
        utter.nPen       = GetTrueSpeakPenetration(oTrueSpeaker);
	float fDelay;
	effect eExplode = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
	effect eVis = EffectVisualEffect(VFX_IMP_PULSE_WIND);
	
	//Get the spell target location as opposed to the spell target.
	location lTarget = PRCGetSpellTargetLocation();
	
	//Apply the fireball explosion at the location captured above.
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
	
	
	//Declare the spell shape, size and the location.  Capture the first target object in the shape.
	object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(20.0), lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_AREA_OF_EFFECT);
	
	
	//Cycle through the targets within the spell shape until an invalid object is captured.
	while (GetIsObjectValid(oTarget))
	{
	    if (GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT)
	    {
	        DestroyObject(oTarget);
	    }
	    else
	    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	    {
	        {
	            //Fire cast spell at event for the specified target
	            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, PRCGetSpellId()));
	            //Get the distance between the explosion and the target to calculate delay
	            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
	
	            // * unlocked doors will reverse their open state
	            if (GetObjectType(oTarget) == OBJECT_TYPE_DOOR)
	            {
	                if (GetLocked(oTarget) == FALSE)
	                {
	                    if (GetIsOpen(oTarget) == FALSE)
	                    {
	                        AssignCommand(oTarget, ActionOpenDoor(oTarget));
	                    }
	                    else
	                        AssignCommand(oTarget, ActionCloseDoor(oTarget));
	                }
	            }
	            if(!PRCDoResistSpell(oTrueSpeaker, oTarget, utter.nPen))
	            {
	
	                effect eKnockdown = EffectKnockdown();
	                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, RoundsToSeconds(3), TRUE, utter.nSpellId, utter.nTruespeakerLevel);
	                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
	
	             }
	         }
	    }
	   //Select the next target within the spell shape.
	   oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(20.0), lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE |OBJECT_TYPE_AREA_OF_EFFECT);
        }

        // Mark for the Law of Sequence. This only happens if the utterance succeeds, which is why its down here.
        DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
    }// end if - Successful utterance
}
