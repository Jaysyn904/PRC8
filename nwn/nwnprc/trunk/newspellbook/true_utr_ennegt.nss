/*
   ----------------
   Energy Negation
   true_utr_ennegt
   ----------------

   2/8/06 by Stratovarius
*/ /** @file

    Energy Negation

    Level: Evolving Mind 3
    Range: 60 feet
    Target: One Creature
    Duration: 5 Rounds
    Spell Resistance: Yes
    Save: None
    Metautterances: Extend, Empower

    Normal:  The air crackles with yours words as you protect your target from energy.
             Your target gains Damage Resistance 10/- vs Acid, Cold, Elec, Fire or Sonic. Use the "Energy Negation, Choice" option to pick the damage type.
    Reverse: The flesh and skin of an enemy are imbued with energy, causing it great pain.
             Your foe takes 2d6 damage per round. Acid, Cold, Elec or Fire. Use the "Energy Negation, Choice" option to pick the damage type.
*/

#include "true_inc_trufunc"
#include "true_utterhook"
//#include "prc_alterations"

void main()
{
    object oTrueSpeaker = OBJECT_SELF;

    // This is the switch that tells what damage type is picked
    if(PRCGetSpellId() == UTTER_ENERGY_NEGATION_CHOICE)
    {
        int nDamageType = GetLocalInt(oTrueSpeaker, "TrueEnergyNegation");
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

        SetLocalInt(oTrueSpeaker, "TrueEnergyNegation", nDamageType);
        FloatingTextStringOnCreature("Energy Negation Damage Type: " + sName, oTrueSpeaker, FALSE);
        // Exist before we hit the utterance
        return;
    }

    if(!TruePreUtterCastCode()) return;

    object oTarget = PRCGetSpellTargetObject();
    struct utterance utter = EvaluateUtterance(oTrueSpeaker, oTarget, (METAUTTERANCE_EXTEND | METAUTTERANCE_EMPOWER), LEXICON_EVOLVING_MIND);    // If we're just picking, cut out before the actual utterance happens

    if(utter.bCanUtter)
    {
        // This is done so Speak Unto the Masses can read it out of the structure
        utter.nPen = GetTrueSpeakPenetration(oTrueSpeaker);
        utter.fDur = RoundsToSeconds(5);
        if(utter.bExtend) utter.fDur *= 2;
        int nSRCheck;
        int nDamageType = GetLocalInt(oTrueSpeaker, "TrueEnergyNegation");
        if(nDamageType == 0) nDamageType = DAMAGE_TYPE_ACID;

        // The NORMAL effect of the Utterance goes here
        if(utter.nSpellId == UTTER_ENERGY_NEGATION)
        {
            // This utterance applies only to friends
            utter.bFriend = TRUE;
            // Used to Ignore SR in Speak Unto the Masses for friendly utterances.
            utter.bIgnoreSR = TRUE;
            // Damage Resistance
            utter.eLink = EffectLinkEffects(EffectDamageResistance(nDamageType, 10), EffectVisualEffect(VFX_DUR_PROTECTION_ELEMENTS));
            // Impact VFX 
            utter.eLink2 = EffectVisualEffect(VFX_IMP_ELEMENTAL_PROTECTION);
        }
        // The REVERSE effect of the Utterance goes here
        else // UTTER_ENERGY_NEGATION_R
        {
            // If the Spell Penetration fails, don't apply any effects
            nSRCheck = PRCDoResistSpell(oTrueSpeaker, oTarget, utter.nPen);
            if(!nSRCheck)
            {
                // Damage
                // Can't do sonic with the damage part of this power
                if(nDamageType == DAMAGE_TYPE_SONIC) nDamageType = DAMAGE_TYPE_ACID;

                utter.eLink = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
                int nDamage = d6(2);
                // Empower it
                if(utter.bEmpower) nDamage += (nDamage/2);
                // Impact VFX
                utter.eLink2 = EffectLinkEffects(EffectVisualEffect(VFX_IMP_MAGVIO), EffectDamage(nDamage, nDamageType));
                // Convert the seconds back into rounds for nBeats
                int nBeats = FloatToInt(utter.fDur / 6.0);
                // This takes care of the duration bit of the utterance
                DelayCommand(6.0, DoEnergyNegation(oTrueSpeaker, oTarget, utter, nBeats, nDamageType));
            }
        }
        // Duration Effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, utter.eLink, oTarget, utter.fDur, TRUE, utter.nSpellId, utter.nTruespeakerLevel);
        // Impact Effects
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, utter.eLink2, oTarget);

        // Speak Unto the Masses. Swats an area with the effects of this utterance
        DoSpeakUntoTheMasses(oTrueSpeaker, oTarget, utter);
        // Mark for the Law of Sequence. This only happens if the utterance succeeds, which is why its down here.
        // The utterance isn't active if SR stops it
        if (!nSRCheck) DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
    }// end if - Successful utterance
}