/*
   ----------------
   Manticore Parry

   tob_irnh_mntpry
   ----------------

    13/12/07 by Stratovarius
*/ /** @file

    Manticore Parry

    Iron Heart (Counter)
    Level: Warblade 6
    Prerequisite: Two Iron Heart maneuvers
    Initiation Action: 1 swift action
    Range: Melee attack
    Target: One creature

    You block an enemy's attack with a lightning-quick parry, then deflect it toward a different target.
    Your foe can barely control its momentum as its attack now slams into an ally.
    
    Make an opposed attack roll against the targeted creature. If you succeed, he damages an ally of his in melee range.
    If there is no enemy, he damages no one.
*/

#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"

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
    	object oInitWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
    	object oTargetWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
    	int nBase   = GetBaseAttackBonus(oTarget);
    	SetBaseAttackBonus(nBase - 1, oTarget);
    	if (DEBUG) DoDebug("tob_stsn_folstrk: GetBaseAttackBonus returns " + IntToString(nBase));
    	int nInit   = GetAttackBonus(oTarget, oInitiator, oInitWeap) + d20();
    	int nTarget = GetAttackBonus(oInitiator, oTarget, oTargetWeap) + d20();
    	
	if (nInit >= nTarget)
    	{
    		object oAreaTarget = FindNearestNewEnemyWithinRange(oInitiator, oTarget);
		if (nTarget >= GetDefenderAC(oAreaTarget, oInitiator))
		{
			// Deal damage to himself
			effect eDam = GetAttackDamage(oAreaTarget, oTarget, oInitWeap, GetWeaponBonusDamage(oTargetWeap, oAreaTarget), GetMagicalBonusDamage(oTarget, oAreaTarget));
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);		
		}
        }
        else
        {
		// Foes attacks as normal     
		DelayCommand(0.0, PerformAttack(oInitiator, oTarget, eNone, 0.0, 0, 0, 0, "Hit", "Miss"));
        }
        
        DelayCommand(6.0, RestoreBaseAttackBonus(oTarget));
    }
}