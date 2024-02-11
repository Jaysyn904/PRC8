/*
   ----------------
   Leading the Attack

   tob_wtrn_ldngatk.nss
   ----------------

   27/04/07 by Stratovarius
*/ /** @file

    Leading the Attack

    White Raven (Strike)
    Level: Crusader 1, Warblade 1
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature

    You boldly strike at your enemy. As you attack, you shout a war cry
    to demonstrate that victory is at hand. This attack inspires nearby
    allies to join the fray with renewed vigor.
    
    If your strike hits, your target suffers a -4 penalty to AC.
*/

#include "tob_inc_move"
#include "tob_movehook"
//#include "prc_alterations"

void TOBAttack(object oTarget, object oInitiator)
{
	effect eNone;
	PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Leading the Attack Hit", "Leading the Attack Miss");
	if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
    	{
		effect eLink = ExtraordinaryEffect(EffectVisualEffect(PSI_IMP_CONCUSSION_BLAST));
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
		eLink = ExtraordinaryEffect(EffectACDecrease(4));
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