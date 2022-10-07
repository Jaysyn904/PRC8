/*
   ----------------
   Douse the Flames

   tob_wtrn_dsflms.nss
   ----------------

   27/04/07 by Stratovarius
*/ /** @file

    Douse the Flames

    White Raven (Strike)
    Level: Crusader 1, Warblade 1
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature

    You strike your enemy with a resounding blow, capturing his attention.
    As he turns to look, you let loose a string of oaths, challenges, and taunts
    that force him to focus his attention on you.
    
    If your strike hits, your target suffers a -2 penalty to attacks and attacks you.
*/

#include "tob_inc_move"
#include "tob_movehook"
//#include "prc_alterations"

void TOBAttack(object oTarget, object oInitiator)
{
    	effect eNone;
	PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Douse the Flames Hit", "Douse the Flames Miss");
	if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
    	{
		effect eLink = ExtraordinaryEffect(EffectVisualEffect(VFX_IMP_FAERIE_FIRE));
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
		eLink = ExtraordinaryEffect(EffectAttackDecrease(2));
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0);
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