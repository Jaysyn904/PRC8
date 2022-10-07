/*
   ----------------
   Energy Negation, Greater
   true_utr_ennegtg
   ----------------

    4/8/06 by Stratovarius
*/ /** @file

    Energy Negation, Greater

    Level: Evolving Mind 5
    Range: 60 feet
    Target: One Creature
    Duration: 5 Rounds
    Spell Resistance: Yes
    Save: None
    Metautterances: Extend

    Normal:  Your utterance renders your target impervious to harm from one type of energy.
             Your target gains Damage Immunity vs Acid, Cold, Elec, Fire or Sonic. Use the "Energy Negation, Greater, Choice" option to pick the damage type.
    Reverse: You wreathe your ally in energy that lashes out at those who strike him in battle.
             Any foe that strikes your target in melee combat takes 20 points of damage from the chosen element. Acid, Cold, Elec or Fire. Use the "Energy Negation, Greater, Choice" option to pick the damage type.
*/

#include "true_inc_trufunc"
#include "true_utterhook"
//#include "prc_alterations"

void main()
{
    object oTrueSpeaker = OBJECT_SELF;

    // This runs regardless of the rest of the utterance
    // If we're just picking, cut out before the actual utterance happens
    // This is the switch that tells what damage type is picked
    if(PRCGetSpellId() == UTTER_ENERGY_NEGATION_GREATER_CHOICE)
    {
        int nDamageType = GetLocalInt(oTrueSpeaker, "TrueEnergyNegationGreater");
        string sName;
        switch(nDamageType)
        {
            case DAMAGE_TYPE_ACID:
                nDamageType = DAMAGE_TYPE_COLD;
                sName = "Cold Damage";
                break;

            case DAMAGE_TYPE_COLD:
                nDamageType = DAMAGE_TYPE_ELECTRICAL;
                sName = "Electrical Damage";
                break;

            case DAMAGE_TYPE_ELECTRICAL:
                nDamageType = DAMAGE_TYPE_FIRE;
                sName = "Fire Damage";
                break;

            case DAMAGE_TYPE_FIRE:
                nDamageType = DAMAGE_TYPE_SONIC;
                sName = "Sonic Damage";
                break;

            default:
                nDamageType = DAMAGE_TYPE_ACID;
                sName = "Acid Damage";
                break;
        }

        SetLocalInt(oTrueSpeaker, "TrueEnergyNegationGreater", nDamageType);
        FloatingTextStringOnCreature("Energy Negation, Greater Damage Type: " + sName, oTrueSpeaker, FALSE);
        // Exist before we hit the utterance
        return;
    }

    if(!TruePreUtterCastCode()) return;

    object oTarget = PRCGetSpellTargetObject();
    struct utterance utter = EvaluateUtterance(oTrueSpeaker, oTarget, METAUTTERANCE_EXTEND, LEXICON_EVOLVING_MIND);

    if(utter.bCanUtter)
    {
        // This is done so Speak Unto the Masses can read it out of the structure
        utter.nPen = GetTrueSpeakPenetration(oTrueSpeaker);
        utter.fDur = RoundsToSeconds(5);
        if(utter.bExtend) utter.fDur *= 2;
        int nDamageType = GetLocalInt(oTrueSpeaker, "TrueEnergyNegationGreater");
        if(nDamageType == 0) nDamageType = DAMAGE_TYPE_ACID;
        // This utterance applies only to friends
        utter.bFriend = TRUE;
        // Used to Ignore SR in Speak Unto the Masses for friendly utterances.
        utter.bIgnoreSR = TRUE;

        // The NORMAL effect of the Utterance goes here
        if(utter.nSpellId == UTTER_ENERGY_NEGATION_GREATER)
        {
            // Damage Immunity
            utter.eLink = EffectLinkEffects(EffectDamageImmunityIncrease(nDamageType, 100), EffectVisualEffect(VFX_DUR_PROTECTION_ELEMENTS));
            // Impact VFX 
            utter.eLink2 = EffectVisualEffect(VFX_IMP_ELEMENTAL_PROTECTION);
        }
        // The REVERSE effect of the Utterance goes here
        else // UTTER_ENERGY_NEGATION_GREATER_R
        {
            if(nDamageType == DAMAGE_TYPE_SONIC) nDamageType = DAMAGE_TYPE_ACID;

            // Damage Shield,
            utter.eLink = EffectLinkEffects(EffectDamageShield(0, DAMAGE_BONUS_20, nDamageType), EffectVisualEffect(VFX_DUR_CHILL_SHIELD));
            // Impact VFX
            utter.eLink2 = EffectVisualEffect(VFX_IMP_ELEMENTAL_PROTECTION);
        }
        // Duration Effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, utter.eLink, oTarget, utter.fDur, TRUE, utter.nSpellId, utter.nTruespeakerLevel);
        // Impact Effects
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, utter.eLink2, oTarget);

        // Speak Unto the Masses. Swats an area with the effects of this utterance
        DoSpeakUntoTheMasses(oTrueSpeaker, oTarget, utter);
        // Mark for the Law of Sequence. This only happens if the utterance succeeds, which is why its down here.
        // The utterance isn't active if SR stops it
        DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
    }// end if - Successful utterance
}