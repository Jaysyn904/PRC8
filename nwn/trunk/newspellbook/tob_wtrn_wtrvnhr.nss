/*
   ----------------
   White Raven Hammer

   tob_wtrn_wtrvnhr.nss
   ----------------

   29/09/07 by Stratovarius
*/ /** @file

    White Raven Hammer

    White Raven (Strike)
    Level: Crusader 8, Warblade 8
    Prerequisite: Three White Raven maneuvers
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature
    Duration: 1 round.

    You slam your opponent with a mighty attack to disrupt his senses and leave
    him unable to defend himself while your allies close to finish him off.
    
    If your strike hits, you deal an extra 6d6 damage and your opponent is stunned.
*/

#include "tob_inc_move"
#include "tob_movehook"

void TOBAttack(object oTarget, object oInitiator)
{
	effect eNone;
	PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, d6(6), 0, "White Raven Hammer Hit", "White Raven Hammer Miss");
	if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
    {
		effect eLink = ExtraordinaryEffect(EffectVisualEffect(VFX_IMP_FAERIE_FIRE));
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
		eLink = ExtraordinaryEffect(EffectStunned());
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0);
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