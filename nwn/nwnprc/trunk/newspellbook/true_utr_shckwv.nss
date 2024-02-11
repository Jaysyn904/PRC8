/*
   ----------------
   Shockwave

   true_utr_shckwv
   ----------------

    1/9/06 by Stratovarius
*/ /** @file

    Shockwave

    Level: Perfected Map 1
    Range: 100 feet
    Area: 20' Radius 
    Duration: 1 Round
    Spell Resistance: No
    Save: Fortitude Negates
    Metautterances: Extend

    By speaking this utterance, you order the air to pulse violently, knocking creatures in the area to the ground.
    All creatures that fail the Fortitude save take 1d4 damage and are knocked prone for one round.
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
        utter.fDur       = RoundsToSeconds(1);
        if(utter.bExtend) utter.fDur *= 2;
        utter.nSaveType  = SAVING_THROW_TYPE_NONE;
	utter.nSaveThrow = SAVING_THROW_FORT;
	int nDamage;
        effect eExplode = EffectVisualEffect(VFX_PRC_FNF_EARTHQUAKE);
        effect eVis = EffectVisualEffect(VFX_IMP_LEAF);
        effect eDam;
        
    	location lTarget = PRCGetSpellTargetLocation();
    	//Apply the fireball explosion at the location captured above.
    	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
    	//Declare the spell shape, size and the location.  Capture the first target object in the shape.
    	object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(20.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
    	//Cycle through the targets within the spell shape until an invalid object is captured.
    	while (GetIsObjectValid(oTarget))
    	{
    	    // No hitting yourself
    	    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTarget != oTrueSpeaker)
    	    {
    	            //Fire cast spell at event for the specified target
    	            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, utter.nSpellId));
    	            //Get the distance between the explosion and the target to calculate delay
    	            float fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
    	            //Roll damage for each target
    	            nDamage = d4();
    	            eDam = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING);
    	            // This is calculated down here because the target's race matters
    	            utter.nSaveDC    = GetTrueSpeakerDC(oTrueSpeaker);
                    if(PRCGetIsAliveCreature(oTarget))
                    {
    	               if(!PRCMySavingThrow(utter.nSaveThrow, oTarget, utter.nSaveDC, utter.nSaveType, oTrueSpeaker))
    	               {
    	                   // Apply effects to the currently selected target.
    	                   DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
    	                   DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
    	                   SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oTarget, utter.fDur, TRUE, utter.nSpellId, utter.nTruespeakerLevel);
    	               }
                    }
    	    }
    	   //Select the next target within the spell shape.
    	   oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(20.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
    	}
    	
    	DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
    }// end if - Successful utterance
}