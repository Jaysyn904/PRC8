/*
    ----------------
    Agitate Item

    true_utr_agititm
    ----------------

    5/8/06 by Stratovarius
*/ /** @file

    Agitate Item

    Level: Crafted Tool 2
    Range: 30 feet.
    Target: One Object (Or Possesor)
    Duration: 6 Rounds
    Spell Resistance: Yes
    Metautterances: Extend

    You increase or decrease the temperature of the object, harming creatures in physical contact with it.
    You affect the target with either the Heat Metal or Chill Metal spell.
*/

#include "true_inc_trufunc"
#include "true_utterhook"
//#include "prc_alterations"

void DoAgitateMetal(object oTrueSpeaker, object oTarget, int nVFX, int nBeats, int nDamageType, int nRounds);

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
    oTarget             = CraftedToolTarget(oTrueSpeaker, oTarget);
    struct utterance utter = EvaluateUtterance(oTrueSpeaker, oTarget, METAUTTERANCE_EXTEND, LEXICON_CRAFTED_TOOL);

    if(utter.bCanUtter)
    {
        // This is done so Speak Unto the Masses can read it out of the structure
        utter.nPen       = GetTrueSpeakPenetration(oTrueSpeaker);
        int nRounds      = 6;
        if(utter.bExtend) nRounds *= 2;
                	
        // If the Spell Penetration fails, don't apply any effects
	// Its done this way so the law of sequence is applied properly
	// Applies to both parts of the utterance
	int nSRCheck = PRCDoResistSpell(oTrueSpeaker, oTarget, utter.nPen);
	if (!nSRCheck)
        {
                // The NORMAL effect of the Utterance goes here
        	if (utter.nSpellId == UTTER_AGITATE_ITEM_HOT /* Example Utterance */)
        	{
        		DoAgitateMetal(oTrueSpeaker, oTarget, VFX_COM_HIT_FIRE, 1, DAMAGE_TYPE_FIRE, nRounds);
        	}
        	// The REVERSE effect of the Utterance goes here
        	else /* Effects of UTTER_AGITATE_ITEM_COLD would be here */
        	{
			DoAgitateMetal(oTrueSpeaker, oTarget, VFX_COM_HIT_FROST, 1, DAMAGE_TYPE_COLD, nRounds);
        	}
        }
        
        // Mark for the Law of Sequence. This only happens if the utterance succeeds, which is why its down here.
        if (!nSRCheck) DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
    }// end if - Successful utterance
}

void DoAgitateMetal(object oTrueSpeaker, object oTarget, int nVFX, int nBeats, int nDamageType, int nRounds)
{
	// Damage is determined by round
	int nDamage;
	if (nBeats == 1) nDamage = 0;
	else if (nBeats == 2) nDamage = d4();
	// Extended version
	else if (nBeats > 2 && nBeats < 10 && nRounds == 12) nDamage = d4(2);
	else if (nBeats > 2 && nBeats < 6) nDamage = d4(2);
	else if (nBeats == 6) nDamage = d4();
	// Extended
	else if (nBeats == 11) nDamage = d4();
	else if (nBeats == 12) nDamage = 0;
       	// Impact VFX 
        effect eLink = EffectLinkEffects(EffectVisualEffect(nVFX), EffectDamage(nDamage, nDamageType));
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
        
        nBeats += 1;
        if (nRounds >= nBeats)
        	DelayCommand(6.0, DoAgitateMetal(oTrueSpeaker, oTarget, nVFX, nBeats, nDamageType, nRounds));
}
