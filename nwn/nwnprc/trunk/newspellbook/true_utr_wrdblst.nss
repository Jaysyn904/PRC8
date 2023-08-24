/*
   ----------------
   Word of Bolstering

   true_utr_wrdblst
   ----------------

   3/8/06 by Stratovarius
*/ /** @file

    Word of Bolstering

    Level: Evolving Mind 4
    Range: 60 feet
    Target: One Creature
    Duration: Instantaneous (Normal) or 5 Rounds (Reverse)
    Spell Resistance: Yes
    Save: None
    Metautterances: Extend, Empower

    Normal:  Suffusing your ally with the glow of positive energy, you eliminate the drain he experiences.
             Remove all ability drain from the target.
    Reverse: Your words cause the body of a foe to weaken and grow more frail.
             Your foe takes a 1d6 penalty to Dex, Con, or Str. Choose the Ability to drain with Word of Bolstering, Choice.
*/

int GetIsSupernaturalCurse(effect eEff)
{
    return GetTag(GetEffectCreator(eEff)) == "q6e_ShaorisFellTemple";
}

#include "true_inc_trufunc"
#include "true_utterhook"
//#include "prc_alterations"

void main()
{
    object oTrueSpeaker = OBJECT_SELF;

    // This runs regardless of the rest of the utterance
    // If we're just picking, cut out before the actual utterance happens
    // This is the switch that tells what damage type is picked
    if(PRCGetSpellId() == UTTER_WORD_BOLSTERING_CHOICE)
    {
        int nDamageType = GetLocalInt(oTrueSpeaker, "TrueWordBlasting");
        string sName;
        switch(nDamageType)
        {
            case ABILITY_STRENGTH:
                nDamageType = ABILITY_DEXTERITY;
                sName = "Dexterity Damage";
                break;

            case ABILITY_DEXTERITY:
                nDamageType = ABILITY_CONSTITUTION;
                sName = "Constitution Damage";
                break;

            default:
                nDamageType = ABILITY_STRENGTH;
                sName = "Strength Damage";
                break;
        }

        SetLocalInt(oTrueSpeaker, "TrueWordBlasting", nDamageType);
        FloatingTextStringOnCreature("Word of Blasting Damage Type: " + sName, oTrueSpeaker, FALSE);
        return;// End utterance
    }

    //it's actual utterance, not the switch so we can run spellhook now
    if(!TruePreUtterCastCode()) return;

    object oTarget = PRCGetSpellTargetObject();
    struct utterance utter = EvaluateUtterance(oTrueSpeaker, oTarget, (METAUTTERANCE_EXTEND | METAUTTERANCE_EMPOWER), LEXICON_EVOLVING_MIND);

    if(utter.bCanUtter)
    {
        // This is done so Speak Unto the Masses can read it out of the structure
        utter.nPen       = GetTrueSpeakPenetration(oTrueSpeaker);
        utter.fDur       = RoundsToSeconds(5);
        int nSRCheck;
        if(utter.bExtend) utter.fDur *= 2;

        // The NORMAL effect of the Utterance goes here
        if(utter.nSpellId == UTTER_WORD_BOLSTERING)
        {
            // This utterance applies only to friends
            utter.bFriend = TRUE;
            // Used to Ignore SR in Speak Unto the Masses for friendly utterances.
            utter.bIgnoreSR = TRUE;

            effect eBad = GetFirstEffect(oTarget);
            //Search for negative effects
            while(GetIsEffectValid(eBad))
            {
                if(GetEffectType(eBad) == EFFECT_TYPE_ABILITY_DECREASE)
                {
                    //Remove effect if it is negative.
                    if(!GetIsSupernaturalCurse(eBad))
                        RemoveEffect(oTarget, eBad);
                }
                eBad = GetNextEffect(oTarget);
            }
            // Impact VFX 
            utter.eLink2 = EffectVisualEffect(VFX_IMP_RESTORATION);
            // This part is instantaneous
            utter.fDur = 0.0;
        }
        // The REVERSE effect of the Utterance goes here
        else // UTTER_WORD_BOLSTERING_R
        {
            // If the Spell Penetration fails, don't apply any effects
            nSRCheck = PRCDoResistSpell(oTrueSpeaker, oTarget, utter.nPen);
            if(!nSRCheck)
            {
                // Stat Penalty
                int nLoss = d6();
                if(utter.bEmpower) nLoss += (nLoss/2);
                ApplyAbilityDamage(oTarget, GetLocalInt(oTrueSpeaker, "TrueWordBlasting"), nLoss, DURATION_TYPE_TEMPORARY, TRUE, utter.fDur, TRUE);
                // Impact VFX 
                utter.eLink2 = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE_GRN);
            }
        }
        // Impact Effects
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, utter.eLink2, oTarget);

        // Speak Unto the Masses. Swats an area with the effects of this utterance
        DoSpeakUntoTheMasses(oTrueSpeaker, oTarget, utter);
        // Mark for the Law of Sequence. This only happens if the utterance succeeds, which is why its down here.
        // The utterance isn't active if SR stops it
        if(!nSRCheck) DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
    }// end if - Successful utterance
}