/*
   ----------------
   Scorpion Parry

   tob_stsn_scrpry
   ----------------

    13/12/07 by Stratovarius
*/ /** @file

    Scorpion Parry

    Setting Sun (Counter)
    Level: Swordsage 6
    Prerequisite: Two Setting Sun maneuvers
    Initiation Action: 1 swift action
    Range: Melee attack
    Target: One creature

    You knock your opponent's attack aside, guiding his weapon into one of his allies.
    
    Make an opposed attack roll against the targeted creature. If you succeed, he damages an ally of his in melee range.
    If there is no enemy, he damages no one.
*/

#include "tob_inc_move"
#include "tob_movehook"
//#include "prc_alterations"

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