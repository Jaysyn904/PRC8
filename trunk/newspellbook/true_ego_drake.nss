/*
   ----------------
   Cadence of the Thunder Drake
   Acolyte of the Ego level 2+

   true_ego_fort
   ----------------

   3/1/20 by Stratovarius

Type of Feat: Class
Prerequisite: Acolye of the Ego 2+
Specifics: You can make a single breath weapon attack— specifically, a 20-foot cone of painful noise that deals 2d6 points of 
sonic damage per morphic cadence you know. The Reflex save to halve the damage is DC 10 + your acolyte of the ego class level + your Con modifier + the number of morphic cadences you know.
Use: Selected.
*/

#include "true_inc_trufunc"
#include "true_utterhook"

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
    // Cadences always use personal truenames, even when targeting another creature
    struct utterance utter = EvaluateUtterance(oTrueSpeaker, 
                                               oTrueSpeaker, 
                                               METAUTTERANCE_NONE/* Use METAUTTERANCE_NONE if it has no Metautterance usable*/, 
                                               LEXICON_EVOLVING_MIND /* Uses the same DC formula*/);

    if(utter.bCanUtter)
    {
    	int nClass = GetLevelByClass(CLASS_TYPE_ACOLYTE_EGO, oTrueSpeaker);
        int nDice  = GetCadenceCount(oTrueSpeaker);
        // Figure out where the cone was targetted.
     	location lTargetLocation = PRCGetSpellTargetLocation();
     	int nSaveDC = 10 + nClass + nDice + GetAbilityModifier(ABILITY_CONSTITUTION, oTrueSpeaker);
        
     	oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, FeetToMeters(20.0), lTargetLocation, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
     	while(GetIsObjectValid(oTarget))
     	{
          	if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oTrueSpeaker))
          	{
               	//Get the distance between the target and caster to delay the application of effects
               	float fDelay = PRCGetSpellEffectDelay(lTargetLocation, oTarget);                 
               	// Roll damage for each target
               	int nDamage = d6(nDice * 2);

               	// Adjust damage according to Reflex Save, Evasion or Improved Evasion
               	nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nSaveDC, SAVING_THROW_TYPE_SONIC);

               	// Apply effects to the currently selected target.
               	if(nDamage > 0)
               	{
               	     effect eDamage = PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_SONIC);
               	     DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SONIC), oTarget));
               	     DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
               	}
          	}
          	//Select the next target within the spell shape.
          	oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, FeetToMeters(20.0), lTargetLocation, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        }  

        // Mark for the Law of Sequence. This only happens if the cadence succeeds, which is why its down here.
        DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
    }// end if - Successful utterance
}
