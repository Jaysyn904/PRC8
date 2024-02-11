/*
   ----------------
   Obscuring Shadow Veil

   tob_sdhd_obscvl
   ----------------

   31/03/07 by Stratovarius
*/ /** @file

    Obscuring Shadow Veil

    Shadow Hand (Strike)
    Level: Swordsage 4
    Prerequisite: Two Shadow Hand maneuvers
    Initiation Action: 4 Standard Action
    Range: Melee Attack
    Target: One Creature
    Saving Throw: Fortitude Partial.

    As you strike your opponent, you summon the fell energies of the Shadow Hand school
    to rob your foe of her sight. Inky, black energy burrows into her eyes, rendering her
    blind for a few critical moments.
    
    Your attack deals an additional 5d6 damage. If the foe fails a Fort save vs 14 + Wisdom modifier
    the foe suffers a 50% miss chance for one round.
    This is a supernatural maneuver.
*/

#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"

void TOBAttack(object oTarget, object oInitiator)
{
    	int nDamage = d6(5);
    	int nDamageType = DAMAGE_TYPE_MAGICAL;
    	
	effect eNone;
	PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, nDamage, nDamageType, "Obscuring Shadow Veil Hit", "Obscuring Shadow Veil Miss");
	if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
    	{
    		// Saving Throw
    		if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (14 + GetAbilityModifier(ABILITY_WISDOM, oInitiator))))
    		{
			effect eLink = SupernaturalEffect(EffectVisualEffect(VFX_IMP_HEAD_EVIL));
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
			eLink = SupernaturalEffect(EffectMissChance(50));
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
    }
}