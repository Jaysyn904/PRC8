/*
    ----------------
    Flesh Ripper

    tob_tgcw_flshrip
    ----------------

    18/08/07 by Stratovarius
*/ /** @file

    Flesh Ripper

    Tiger Claw (Strike)
    Level: Swordsage 3, Warblade 3
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature
    Duration: 1 round
    Save: Fortitude Partial; see text

    With a mixture of careful precision and animal savagery, you tear into a foe to produce jagged wounds that overwhelm him with pain.
    
    If the target fails a Fortitude save vs 13 + Strength modifier, he takes a -4 penalty to attacks and AC.
*/

#include "tob_inc_move"
#include "tob_movehook"
#include "prc_inc_combmove" 

void TOBAttack(object oTarget, object oInitiator)
{
    	effect eNone = EffectVisualEffect(PSI_IMP_CONCUSSION_BLAST);
    	int nBonus = TOBSituationalAttackBonuses(oInitiator, DISCIPLINE_TIGER_CLAW);
	PerformAttack(oTarget, oInitiator, eNone, 0.0, nBonus, 0, 0, "Flesh Ripper Hit", "Flesh Ripper Miss");
	if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack") && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
    	{
    		// Saving Throw
    		if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (13 + GetAbilityModifier(ABILITY_STRENGTH, oInitiator))))
    		{
			    effect eLink = EffectLinkEffects(EffectAttackDecrease(4), EffectACDecrease(4));
			    eLink = ExtraordinaryEffect(eLink);
			    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0);
		    }
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
        DelayCommand(0.1, TigerBlooded(oInitiator, oTarget));
    }
}