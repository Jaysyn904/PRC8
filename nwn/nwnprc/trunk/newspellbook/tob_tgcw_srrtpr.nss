/*
   ----------------
   Soaring Raptor Strike

   tob_tgcw_srrtpr.nss
   ----------------

   08/06/07 by Stratovarius
*/ /** @file

    Soaring Raptor Strike

    Tiger Claw (Strike)
    Level: Swordsage 3, Warblade 3
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature

    You leap into the air, catching a larger opponent by surprise as you jump over
    its defenses to plunge your weapon into the crown of its head.
    
    Make a jump check with a DC equal to the target's AC. If it succeeds, you deal an extra
    6d6 damage on your attack, and attack with a +4 bonus. If it fails, you do not attack.
    This must be used on a creature larger than you are.
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
    	int nAC = GetDefenderAC(oTarget, oInitiator);
        if(GetIsSkillSuccessful(oInitiator, SKILL_JUMP, nAC) && PRCGetCreatureSize(oTarget) > PRCGetCreatureSize(oInitiator)) 
    	{
    		effect eNone;
	    	object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
	    	int nBonus = TOBSituationalAttackBonuses(oInitiator, DISCIPLINE_TIGER_CLAW);
		    DelayCommand(0.0, PerformAttack(oTarget, oInitiator, eNone, 0.0, 4 + nBonus, d6(6), GetWeaponDamageType(oWeap), "Soaring Raptor Strike Hit", "Soaring Raptor Strike Miss"));
            DelayCommand(0.1, TigerBlooded(oInitiator, oTarget));
    	}
    }
}