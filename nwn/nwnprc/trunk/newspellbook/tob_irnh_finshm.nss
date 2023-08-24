//////////////////////////////////////////////////
// Finishing Move 
// tob_finshm.nss 
// Tenjac 9/21/07 
//////////////////////////////////////////////////
/** @file Finishing Move
Iron Heart(Strike)
Level: Warblade 7
Prerequisite: Three Iron Heart maneuvers
Initiation Action: 1 standard action
Range: Melee attack
Target: One creature

You deliver a devastating strike against a wounded foe, aiming to finish him off once
and for all.

Iron Heart teaches that it is best to finish off a foe with as little effort as 
possible; the better to save your strength for your remaining enemies. When you use 
this maneuver, you throw yourself on the offensive with little thought to your 
defenses. If this attack strikes home, it might end a fight several crucial seconds
early.

As part of this maneuver, you make a melee attack against a creature. This attack
deals an extra 4d6 points of damage. If the target's current hit points are less than
its full normal hit points, the attack instead deals an extra 6d6 points of damage.
If its hit points are equal to or less than one-half its full normal hit points, the
attack instead deals an extra 14d6 points of damage.
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
                int nHP = GetCurrentHitPoints(oTarget);
                int nMaxHP = GetMaxHitPoints(oTarget);
                int nHalf = nMaxHP/2;
                int nBonus;
                object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
                
                if(nHP = nMaxHP)
                {
                        nBonus = 4;
                }
                
                if(nHP < nMaxHP)
                {
                        nBonus = 6;
                }
                
                if(nHP <= nHalf)
                {
                        nBonus = 14;
                }
                
		effect eNone;
                DelayCommand(0.0, PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, d6(nBonus), GetWeaponDamageType(oWeap), "Finishing Move Hit", "Finishing Move Miss"));
        }
}