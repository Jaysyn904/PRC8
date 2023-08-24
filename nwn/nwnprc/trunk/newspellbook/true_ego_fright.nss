/*
   ----------------
   Cadence of the Frightful Mind
   Acolyte of the Ego level 2+

   true_ego_fright
   ----------------

   25/8/18 by Stratovarius
*/ /** @file

Type of Feat: Class
Prerequisite: Acolye of the Ego 2+
Specifics:  You can frighten your foes (as the fear spell, PH 229). The DC for the Will save to resist the effect is 10 + your acolyte of the ego level + your Cha modifier + the number of morphic cadences you know. The duration of the effect is 1 round per class level.
Use: Selected.
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
    // Cadences always use personal truenames, even when targeting another creature
    struct utterance utter = EvaluateUtterance(oTrueSpeaker, 
                                               oTrueSpeaker, 
                                               METAUTTERANCE_NONE/* Use METAUTTERANCE_NONE if it has no Metautterance usable*/, 
                                               LEXICON_EVOLVING_MIND /* Uses the same DC formula*/);

    if(utter.bCanUtter)
    {
    	int nClass = GetLevelByClass(CLASS_TYPE_ACOLYTE_EGO, oTrueSpeaker);
        // This is done so Speak Unto the Masses can read it out of the structure
        utter.fDur       = RoundsToSeconds(nClass);
        int nDC   = 10 + nClass + GetAbilityModifier(ABILITY_CHARISMA, oTrueSpeaker);

	effect eVis = EffectVisualEffect(VFX_IMP_FEAR_S);
	effect eFear = EffectFrightened();
    	effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
    	effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
    	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    	float fDelay;
    	//Link the fear and mind effects
    	utter.eLink = EffectLinkEffects(eFear, eMind);
    	utter.eLink = EffectLinkEffects(utter.eLink, eDur);
    	
    	//Apply Impact
    	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, PRCGetSpellTargetLocation());
    	//Get first target in the spell cone
    	oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, PRCGetSpellTargetLocation(), TRUE);
    	while(GetIsObjectValid(oTarget))
    	{
        	if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
        	{
            		fDelay = PRCGetRandomDelay();
            		//Fire cast spell at event for the specified target
            		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FEAR));
	     		//Make a will save
            		if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR, OBJECT_SELF, fDelay))
            		{
            		        // Duration Effects
        			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, utter.eLink, oTarget, utter.fDur, TRUE, utter.nSpellId, utter.nTruespeakerLevel);
            		}
        	}
    	    //Get next target in the spell cone
    	    oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, PRCGetSpellTargetLocation(), TRUE);
    	}    	

        // Mark for the Law of Sequence. This only happens if the cadence succeeds, which is why its down here.
        DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
    }// end if - Successful utterance
}
