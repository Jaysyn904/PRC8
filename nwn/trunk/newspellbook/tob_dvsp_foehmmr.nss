/*
   ----------------
   Foehammer

   tob_dvsp_foehmmr
   ----------------

   05/06/07 by Stratovarius
*/ /** @file

    Foehammer

    Devoted Spirit (Strike)
    Level: Crusader 2
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature

    You throw yourself behind your attack, lending your blow such
    great weight and force that you leave injuries that even magical defenses cannot ignore.
    
    You make a single attack against an enemy. If this attack his, you ignore all DR and do an extra 2d6 damage.
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
    	effect eNone = EffectVisualEffect(PSI_IMP_CONCUSSION_BLAST);
    	SetLocalInt(oInitiator, "MoveIgnoreDR", TRUE);
    	object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
	    DelayCommand(0.0, PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, d6(2), GetWeaponDamageType(oWeap), "Foehammer Hit", "Foehammer Miss"));
	    // Cleanup
	    DelayCommand(3.0, DeleteLocalInt(oInitiator, "MoveIgnoreDR"));
    }
}