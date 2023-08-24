/*
   ----------------
   Mountain Hammer

   tob_stdr_mnthmmr
   ----------------

   08/06/07 by Stratovarius
*/ /** @file

    Mountain Hammer

    Stone Dragon (Strike)
    Level: Crusader 2, Swordsage 2, Warblade 2
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature

    Like a falling avalanche, you strike with the weight and fury of the mountain.
    
    You make a single attack against an enemy. If this attack his, you ignore all DR and do an extra 2d6 damage.
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
    	effect eNone = EffectVisualEffect(PSI_IMP_CONCUSSION_BLAST);
    	SetLocalInt(oInitiator, "MoveIgnoreDR", TRUE);
    	object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
	DelayCommand(0.0, PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, d6(2), GetWeaponDamageType(oWeap), "Mountain Hammer Hit", "Mountain Hammer Miss"));
	// Cleanup
	DelayCommand(3.0, DeleteLocalInt(oInitiator, "MoveIgnoreDR"));
    }
}