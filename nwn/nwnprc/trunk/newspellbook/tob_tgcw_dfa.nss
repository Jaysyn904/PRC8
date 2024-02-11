/*
    ----------------
    Death From Above

    tob_tgcw_flshrip
    ----------------

    18/08/07 by Stratovarius
*/ /** @file

    Death From Above

    Tiger Claw (Strike)
    Level: Swordsage 4, Warblade 4
    Prerequisite: One Tiger Claw maneuver
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature

    With a war cry, you leap into the air and lift your weapon high overhead. As you arc downward, your weight and momentum
    lend bone-crushing force to your attack.
    
    Make a jump check vs DC 20. If you succeed, your target is flatfooted versus the attack, deal 4d6 damage and land within 20' of your opponent. Otherwise, perform only a normal attack.
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
    	if(GetIsSkillSuccessful(oInitiator, SKILL_JUMP, 20)) 
    	{
    		object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
	    	AssignCommand(oTarget, ClearAllActions(TRUE));
	    	int nBonus = TOBSituationalAttackBonuses(oInitiator, DISCIPLINE_TIGER_CLAW);
		    DelayCommand(0.0, PerformAttack(oTarget, oInitiator, eNone, 0.0, nBonus, d6(4), GetWeaponDamageType(oWeap), "Death From Above Hit", "Death From Above Miss"));
		    // Land 20 feet away from target.
		    _DoBullRushKnockBack(oInitiator, oTarget, 20.0);
    	}
    	else // Normal attack
    		DelayCommand(0.0, PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Hit", "Miss"));
            
        DelayCommand(0.1, TigerBlooded(oInitiator, oTarget));  
    }
}