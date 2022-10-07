/*
   ----------------
   Entangling Blade

   tob_dvsp_ntngle
   ----------------

   05/06/07 by Stratovarius
*/ /** @file

    Entangling Blade

    Devoted Spirit (Strike)
    Level: Crusader 4
    Prerequisite: One Devoted Spirit Maneuver
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature
    Duration: 1 round.

    You hack into your foe's legs, forcing his movement to slow and his resolution to falter.
    
    You make a single attack against an enemy. If this attack his, you deal 2d6 extra damage, 
    and you foe takes a 20 ft penalty to his movement speed.
*/

#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"

void TOBAttack(object oTarget, object oInitiator)
{
    	effect eNone = EffectVisualEffect(PSI_IMP_CONCUSSION_BLAST);
    	object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
	PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, d6(2), GetWeaponDamageType(oWeap), "Entangling Blade Hit", "Entangling Blade Miss");
	if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
    	{
		effect eLink = ExtraordinaryEffect(EffectMovementSpeedDecrease(66));
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