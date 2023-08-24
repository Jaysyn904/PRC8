/*
   ----------------
   Mind Strike

   tob_dmnd_bndaslt
   ----------------

   19/08/07 by Stratovarius
*/ /** @file

    Mind Strike

    Diamond Mind (Strike)
    Level: Swordsage 4, Warblade 4
    Prerequisite: Two Diamond Mind Maneuvers
    Initiation Action: 1 Standard action
    Range: Melee Attack
    Target: One Creature
    Save: Will negates

    You strike your opponent's head, rattling his senses and causing him to lose focus.
    
    If you succeed at your attack, your foe must make a save vs DC 14 + Strength or take 1d4 wisdom damage. 
*/

#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"

void TOBAttack(object oTarget, object oInitiator)
{
    effect eNone = EffectVisualEffect(VFX_IMP_BLINDDEAD_DN_CYAN);
    int nAB = 0;
    if (GetLocalInt(oInitiator, "SupernalAttack")) nAB += 1;
	PerformAttack(oTarget, oInitiator, eNone, 0.0, nAB, 0, 0, "Mind Strike Hit", "Mind Strike Miss");
	if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
    {
    	// Saving Throw
    	if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, (14 + GetAbilityModifier(ABILITY_STRENGTH, oInitiator))))
    	{
			ApplyAbilityDamage(oTarget, ABILITY_WISDOM, d4(), DURATION_TYPE_PERMANENT);    
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