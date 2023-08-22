/*
   ----------------
   Stone Bones

   tob_stdr_stnbns
   ----------------

   20/03/07 by Stratovarius
*/ /** @file

    Stones Bones

    Stone Dragon (Strike)
    Level: Crusader 1, Swordsage 1, Warblade 1
    Initiation Action: 1 Standard Action
    Range: Personal
    Target: You
    Duration: 1 round

    You focus your energy to enhance your defenses, drawing on the power of
    your weapon's impact with a foe to toughen yourself against a counterattack.
    
    You gain DR 5/adamantium (+5) for 1 round.
*/

#include "tob_inc_move"
#include "tob_movehook"
//#include "prc_alterations"

void TOBAttack(object oTarget, object oInitiator)
{
    	effect eNone;
	PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Stone Bones Hit", "Stone Bones Miss");
	if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
    	{
        	effect eLink =                          EffectDamageReduction(5, DAMAGE_POWER_PLUS_FIVE);
        	       eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_ROOTED_TO_SPOT));
		       eLink = ExtraordinaryEffect(eLink);
        	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oInitiator, 6.0);
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