/*
   ----------------
   Energy Vortex

   true_utr_envrtx
   ----------------

    2/9/06 by Stratovarius
*/ /** @file

    Energy Vortex

    Level: Perfected Map 2
    Range: 100 feet
    Area: 20' Radius 
    Duration: 1 Minute
    Spell Resistance: Yes
    Save: None
    Metautterances: Extend, Empower

    Your words transform the nature of the air, turning it from harmless gas into a swirling mass of harmful energy.
    You fill the air around your foes with energy, dealing 2d6 acid, cold, electrical, or fire damage per round.
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
    struct utterance utter = EvaluateUtterance(oTrueSpeaker, oTrueSpeaker, (METAUTTERANCE_EXTEND | METAUTTERANCE_EMPOWER), LEXICON_PERFECTED_MAP);

    if(utter.bCanUtter)
    {
        // This is done so Speak Unto the Masses can read it out of the structure
        utter.fDur       = RoundsToSeconds(10);
        if (utter.bExtend) utter.fDur *= 2;
        if (utter.bEmpower) SetLocalInt(oTrueSpeaker, "UtterEnergyVortexEmpower", TRUE);
        
        // The first effect of the Utterance goes here
        if (utter.nSpellId == UTTER_ENERGY_VORTEX_ACID)
        {
        	// eLink is used for Duration Effects (Buff/Penalty to AC)
        	utter.eLink = EffectAreaOfEffect(AOE_PER_ENERGY_VORTEX);
        	SetLocalInt(oTrueSpeaker, "UtterEnergyVortexDamage", DAMAGE_TYPE_ACID);
        }
        // The second effect of the Utterance goes here
        else if (utter.nSpellId == UTTER_ENERGY_VORTEX_COLD)
        {
        	// eLink is used for Duration Effects (Buff/Penalty to AC)
        	utter.eLink = EffectAreaOfEffect(AOE_PER_ENERGY_VORTEX);
        	SetLocalInt(oTrueSpeaker, "UtterEnergyVortexDamage", DAMAGE_TYPE_COLD);
        }
        // The third effect of the Utterance goes here
        else if (utter.nSpellId == UTTER_ENERGY_VORTEX_ELEC)
        {
        	// eLink is used for Duration Effects (Buff/Penalty to AC)
        	utter.eLink = EffectAreaOfEffect(AOE_PER_ENERGY_VORTEX);
        	SetLocalInt(oTrueSpeaker, "UtterEnergyVortexDamage", DAMAGE_TYPE_ELECTRICAL);
        }        
        // The fourth effect of the Utterance goes here
        else /* Effects of UTTER_ENERGY_VORTEX_FIRE here */
        {
        	// eLink is used for Duration Effects (Buff/Penalty to AC)
        	utter.eLink = EffectAreaOfEffect(AOE_PER_ENERGY_VORTEX);
        	SetLocalInt(oTrueSpeaker, "UtterEnergyVortexDamage", DAMAGE_TYPE_FIRE);
        }
        // If either of these ApplyEffect isn't needed, delete it.
        // Duration Effects
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, utter.eLink, PRCGetSpellTargetLocation(), utter.fDur);
        // Clean up the ints here
        DelayCommand(utter.fDur, DeleteLocalInt(oTrueSpeaker, "UtterEnergyVortexDamage"));
        DelayCommand(utter.fDur, DeleteLocalInt(oTrueSpeaker, "UtterEnergyVortexEmpower"));

        // Mark for the Law of Sequence. This only happens if the utterance succeeds, which is why its down here.
        DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
    }// end if - Successful utterance
}
