/*
   ----------------
   Covering Strike

   tob_wtrn_cvrstrk.nss
   ----------------

   19/08/07 by Stratovarius
*/ /** @file

    Covering Strike

    White Raven (Strike)
    Level: Crusader 4, Warblade 4
    Prerequisite: One White Raven maneuver
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature
    Duration: 3 rounds.

    You make a ferocious series of attacks at your enemies, forcing them on the defensive
    and buying your allies critical seconds needed to slip past them unharmed.
    
    If your strike hits, your target suffers a -4 penalty to attacks and attacks you.
*/

#include "tob_inc_move"
#include "tob_movehook"
//#include "prc_alterations"

void TOBAttack(object oTarget, object oInitiator)
{
    	effect eNone;
	PerformAttackRound(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, FALSE, "Covering Strike Hit", "Covering Strike Miss");
	if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
    	{
		effect eLink = ExtraordinaryEffect(EffectVisualEffect(VFX_IMP_FAERIE_FIRE));
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
		eLink = ExtraordinaryEffect(EffectAttackDecrease(4));
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 18.0);
		AssignCommand(oTarget, ClearAllActions());
		AssignCommand(oTarget, ActionAttack(oInitiator));
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