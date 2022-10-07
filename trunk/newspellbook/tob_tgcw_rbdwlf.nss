/*
   ----------------
   Rabid Wolf Strike

   tob_tgcw_rbdwlf.nss
   ----------------

   08/06/07 by Stratovarius
*/ /** @file

    Rabid Wolf Strike

    Tiger Claw (Strike)
    Level: Swordsage 2, Warblade 2
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creatures

    You foam at the mouth and scream in rage as you make a powerful attack
    against your enemy. You set aside all thoughts of defense as you lunge forward.
    
    Make a single attack with a +4 bonus on the attack roll, and +2d6 damage. 
    You take a -4 penalty to AC for the rest of the round.
*/

#include "tob_inc_move"
#include "tob_movehook" 
#include "prc_inc_combmove" 

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
    	effect eNone;
    	object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
    	int nBonus = TOBSituationalAttackBonuses(oInitiator, DISCIPLINE_TIGER_CLAW);
	    DelayCommand(0.0, PerformAttack(oTarget, oInitiator, eNone, 0.0, 4 + nBonus, d6(2), GetWeaponDamageType(oWeap), "Rabid Wolf Strike Hit", "Rabid Wolf Strike Miss"));
        effect eLink =                          EffectACDecrease(4);
               eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_ROOTED_TO_SPOT));
	       eLink = ExtraordinaryEffect(eLink);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oInitiator, 6.0);
        DelayCommand(0.1, TigerBlooded(oInitiator, oTarget));
    }
}