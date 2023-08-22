/*
   ----------------
   Ward of Peace

   true_utr_wrdpc
   ----------------

    4/8/06 by Stratovarius
*/ /** @file

    Ward of Peace

    Level: Evolving Mind 5
    Range: 60 feet
    Target: One Creature
    Duration: 5 Rounds
    Spell Resistance: Yes
    Save: None (Normal) or Will Negates (Reverse).
    Metautterances: Extend

    Normal:  You ward your target from harm with a golden halo, preventing enemies from attacking her.
             Your ally becomes immune to the blows of the enemy, but can not attack or cast hostile spells.
    Reverse: With a harsh sequence of words, you force a creature to another plane.
             Your foe is forced into another plane.
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
    struct utterance utter = EvaluateUtterance(oTrueSpeaker, oTarget, METAUTTERANCE_EXTEND, LEXICON_EVOLVING_MIND);

    if(utter.bCanUtter)
    {
        // This is done so Speak Unto the Masses can read it out of the structure
 	utter.nSaveType  = SAVING_THROW_TYPE_NONE;
    	utter.nSaveThrow = SAVING_THROW_WILL;
        utter.nPen       = GetTrueSpeakPenetration(oTrueSpeaker);
        utter.nSaveDC    = GetTrueSpeakerDC(oTrueSpeaker); 
        utter.fDur       = RoundsToSeconds(5);
        if(utter.bExtend) utter.fDur *= 2;
        int nSRCheck;
        int nSaveCheck;
        
        // The NORMAL effect of the Utterance goes here
        if (utter.nSpellId == UTTER_WARD_PEACE)
        {
        	// Used to Ignore SR in Speak Unto the Masses for friendly utterances.
        	utter.bIgnoreSR = TRUE;
        	// This utterance applies only to friends
        	utter.bFriend = TRUE;
        	// eLink is used for Duration Effects (Buff/Penalty to AC)
        	SetLocalInt(oTarget, "TrueWardOfPeace", TRUE);
        	utter.ipIProp1 = ItemPropertyNoDamage();
		object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
        	IPSafeAddItemProperty(oItem, utter.ipIProp1, utter.fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        	utter.eLink = EffectVisualEffect(VFX_DUR_LIGHTNING_SHELL);
		SetBaseAttackBonus(1, oTarget);
		// Just in case anyone tries something tricky
		if (!GetPlotFlag(oTarget)) 
		{
			SetPlotFlag(oTarget, TRUE);
			DelayCommand(utter.fDur, SetPlotFlag(oTarget, FALSE));
		}
		DelayCommand(utter.fDur, RestoreBaseAttackBonus(oTarget)); 
		DelayCommand(utter.fDur, DeleteLocalInt(oTarget, "TrueWardOfPeace"));
        }
        // The REVERSE effect of the Utterance goes here
        else // UTTER_WARD_PEACE_R
        {
        	// If the Spell Penetration fails, don't apply any effects
        	nSRCheck = PRCDoResistSpell(oTrueSpeaker, oTarget, utter.nPen);
        	if (!nSRCheck)
        	{
        		// Saving throw
        		nSaveCheck = PRCMySavingThrow(utter.nSaveThrow, oTarget, utter.nSaveDC, utter.nSaveType, OBJECT_SELF);
        		if(!nSaveCheck)
                	{
                		utter.eLink =                                EffectCutsceneParalyze();
				utter.eLink = EffectLinkEffects(utter.eLink, EffectCutsceneGhost());
				utter.eLink = EffectLinkEffects(utter.eLink, EffectEthereal());
				utter.eLink = EffectLinkEffects(utter.eLink, EffectSpellImmunity(SPELL_ALL_SPELLS));
				utter.eLink = EffectLinkEffects(utter.eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID,        100));
				utter.eLink = EffectLinkEffects(utter.eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 100));
				utter.eLink = EffectLinkEffects(utter.eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD,        100));
				utter.eLink = EffectLinkEffects(utter.eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_DIVINE,      100));
				utter.eLink = EffectLinkEffects(utter.eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL,  100));
				utter.eLink = EffectLinkEffects(utter.eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE,        100));
				utter.eLink = EffectLinkEffects(utter.eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_MAGICAL,     100));
				utter.eLink = EffectLinkEffects(utter.eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE,    100));
				utter.eLink = EffectLinkEffects(utter.eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING,    100));
				utter.eLink = EffectLinkEffects(utter.eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_POSITIVE,    100));
				utter.eLink = EffectLinkEffects(utter.eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING,    100));
               			utter.eLink = EffectLinkEffects(utter.eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC,       100));
			}
        	}
        }
        // Duration Effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, utter.eLink, oTarget, utter.fDur, TRUE, utter.nSpellId, utter.nTruespeakerLevel);
        // Impact Effects
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, utter.eLink2, oTarget);
        // Clean Up
        DelayCommand(utter.fDur, DeleteLocalInt(oTrueSpeaker, "TrueCasterLens"));
        
        // Speak Unto the Masses. Swats an area with the effects of this utterance
        DoSpeakUntoTheMasses(oTrueSpeaker, oTarget, utter);
        // Mark for the Law of Sequence. This only happens if the utterance succeeds, which is why its down here.
        // The utterance isn't active if SR stops it
        if (!nSRCheck) DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
    }// end if - Successful utterance    
}
