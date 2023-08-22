/*
   ----------------
   Anger the Sleeping Earth

   true_utr_slperth
   ----------------

    1/9/06 by Stratovarius
*/ /** @file

    Anger the Sleeping Earth

    Level: Perfected Map 4
    Range: 100 feet
    Area: 80' Radius
    Duration: 1 Round
    Spell Resistance: No
    Save: Reflex, see text.
    Metautterances: Extend

    Your words shake the foundation of the earth, causing massive devastation and widespread mayhem.
    This utterance functions as the Earthquake spell.
*/

#include "true_inc_trufunc"
#include "true_utterhook"
//#include "prc_alterations"

void DoQuake(struct utterance utter, location lTarget, )
{
    //Declare major variables
    int nSpectacularDeath = TRUE;
    int nDisplayFeedback  = TRUE;
    int bInside           = GetIsAreaInterior(GetArea(utter.oTrueSpeaker));
    int nProneDC          = 15;
    int nDamageDC         = 15;
    int nFissureDC        = 20;
    int nDamage;
	float fSize       = FeetToMeters(80.0);
	float fProneDur   = 18.0;
    effect eVis       = EffectVisualEffect(VFX_IMP_LEAF);
    effect eDam;
	effect eExplode   = EffectVisualEffect(VFX_PRC_FNF_EARTHQUAKE);
	effect eExplode2  = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_NATURE);
	effect eExplode3  = EffectVisualEffect(VFX_IMP_DUST_EXPLOSION);
	effect eShake     = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE2);
	effect eKnockdown = EffectKnockdown();

	// Perform screen shake
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eShake, utter.oTrueSpeaker);

	//Apply epicenter explosion on caster
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode,  GetLocation(utter.oTrueSpeaker));
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode2, GetLocation(utter.oTrueSpeaker));
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode3, GetLocation(utter.oTrueSpeaker));


	//Declare the spell shape, size and the location.  Capture the first target object in the shape.
	object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fSize, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	//Cycle through the targets within the spell shape until an invalid object is captured.
	while(GetIsObjectValid(oTarget))
    {
        // Normal targeting restriction, except also skip affecting the caster
        if(oTarget != utter.oTrueSpeaker && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, utter.oTrueSpeaker))
        {
            // Let the target's AI know
            SignalEvent(oTarget, EventSpellCastAt(utter.oTrueSpeaker, utter.nSpellId));
            SignalEvent(oTarget, EventSpellCastAt(utter.oTrueSpeaker, SPELL_EARTHQUAKE)); // Also signal with Earthquake spellID. Some things might be hardcoded to react to it

            // First, always knock targets prone, DC 15 to avoid
            if(!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nProneDC, SAVING_THROW_TYPE_SPELL, utter.oTrueSpeaker))
            {
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, fProneDur, FALSE, utter.nSpellId, utter.nTruespeakerLevel, utter.oTrueSpeaker);
            }

            // Indoors, get hit by falling rubble for 8d6, reflex half
            if(bInside)
            {
                nDamage = PRCGetReflexAdjustedDamage(d6(8), oTarget, nDamageDC, SAVING_THROW_TYPE_SPELL, utter.oTrueSpeaker);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_ENERGY),
                                      oTarget, 0.0f, FALSE, utter.nSpellId, utter.nTruespeakerLevel, utter.oTrueSpeaker);
            }
            // Outdoors, 25% chance to fall into a fissure and die
            else
            {
                if(d4() == 4)
                {
                    if(!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nFissureDC, SAVING_THROW_TYPE_SPELL, utter.oTrueSpeaker))
                    {
                        DeathlessFrenzyCheck(oTarget);
                        /// @todo Find appropriate VFX to play here
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(nSpectacularDeath, nDisplayFeedback),
                                              oTarget, 0.0f, FALSE, utter.nSpellId, utter.nTruespeakerLevel, utter.oTrueSpeaker);
                    }
                }
            }
        }

        //Select the next target within the spell shape.
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, fSize, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}

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
        utter.fDur = RoundsToSeconds(1);
        if(utter.bExtend) utter.fDur *= 2;
        utter.nSaveType  = SAVING_THROW_TYPE_NONE;
        utter.nSaveThrow = SAVING_THROW_FORT;
        utter.nSaveDC    = GetTrueSpeakerDC(oTrueSpeaker);
        location lTarget = PRCGetSpellTargetLocation();

        // Perform the earthquake
        DoQuake(utter, lTarget);

        // Extended earthquake - apply the effects again next round
        if(utter.bExtend)
            DelayCommand(6.0f, DoQuake(utter, lTarget));

    	DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
    }// end if - Successful utterance
}