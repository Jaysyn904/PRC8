/*
   ----------------
   Divine Surge

   tob_dvsp_dvnsrg
   ----------------

   05/06/07 by Stratovarius
*/ /** @file

    Divine Surge

    Devoted Spirit (Strike)
    Level: Crusader 4
    Prerequisite: One Devoted Spirit Maneuver
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature

    Your body shakes and spasms as unfettered divine energy courses through it.
    This power sparks off your weapon and courses into your foe,
    devastating your enemy but leaving you drained.
    
    You make a single attack against an enemy. If this attack his, you deal 8d8 extra damage.
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
    	object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
		DelayCommand(0.0, PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, d8(8), GetWeaponDamageType(oWeap), "Divine Surge Hit", "Divine Surge Miss"));
    }
}