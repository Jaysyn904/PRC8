/*
   ----------------
   Daunting Strike

   tob_dvsp_dntstrk.nss
   ----------------

    31/08/07 by Stratovarius
*/ /** @file

    Daunting Strike

    Devoted Spirit (Strike)
    Level: Crusader 5
    Prerequisite: One Devoted Spirit Maneuver
    Initiation Action: 1 Standard Action
    Range: Melee
    Target: One creature
    Saving Throw: Will negates
    Duration: 1 minute

    A blue, dancing flame appears on your weapon. As you strike your foe,
    this flame slides off your weapon and covers your enemy in raging fire.
    
    You make a single melee attack. If it hits, the foe must save against DC 15 + Charisma or be shaken.
*/

#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"

void TOBAttack(object oTarget, object oInitiator)
{
    	effect eNone = EffectVisualEffect(PSI_IMP_CONCUSSION_BLAST);
	PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Daunting Strike Hit", "Daunting Strike Miss");
	if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
    	{
    		// Saving Throw
    		if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (15 + GetAbilityModifier(ABILITY_CHARISMA, oInitiator))))
    		{
			effect eLink = ExtraordinaryEffect(EffectLinkEffects(EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED), EffectShaken()));
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 60.0);
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