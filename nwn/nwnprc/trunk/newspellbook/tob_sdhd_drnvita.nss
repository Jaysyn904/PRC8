/*
   ----------------
   Drain Vitality

   tob_sdhd_drnvita.nss
   ----------------

   08/06/07 by Stratovarius
*/ /** @file

    Drain Vitality

    Shadow Hand (Strike)
    Level: Swordsage 2
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creatures
    Saving Throw: Fort partial.

    A faint numbus of sickly grey shadow surrounds your weapon.
    When you attack, this shadowy aura flows into the wound you
    inflict, sapping your opponent's strength, vitality, and energy.
    
    Make a single melee attack. If you succesfully hit the creature, and he fails a 
    Reflex save against 12 + your Wisdom modifier, he takes two points of Constitution damage.
*/

#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"

void TOBAttack(object oTarget, object oInitiator)
{
	effect eNone;
	PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Drain Vitality Hit", "Drain Vitality Miss");
	
	int nDC = 12 + GetAbilityModifier(ABILITY_WISDOM, oInitiator);
	
	int nBladeMed = HasBladeMeditationForDiscipline(oInitiator, GetDisciplineByManeuver(PRCGetSpellId()));
	if (nBladeMed)
	{
		nDC += 1;
	}  
	
	if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack") && PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
	{
		ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, 2, DURATION_TYPE_TEMPORARY, TRUE, -1.0f);
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE_RED), oTarget);
	}
}

void main()
{
    if (!PreManeuverCastCode())
    {
    // If code within the PreManeuverCastCode (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    object oInitiator    = OBJECT_SELF;
    object oTarget       = PRCGetSpellTargetObject();
    struct maneuver move = EvaluateManeuver(oInitiator, oTarget);

    if(move.bCanManeuver)
    {
    	DelayCommand(0.0, TOBAttack(oTarget, oInitiator));
    }
}