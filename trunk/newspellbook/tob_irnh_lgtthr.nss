//////////////////////////////////////////////////
//  Lightning Throw
//  tob_irnh_lgtthr.nss
//  Tenjac  9/25/07
//////////////////////////////////////////////////
/** @file Lightning Throw
Iron Heart(Strike)
Level: Warblade 8
Prerequisite: Two Iron Heart maneuvers
Initiation Action: 1 standard action
Range: 30ft
Area: 30ft
Duration: Instantaneous
Saving Throw: Reflex half

You throw your weapon through the air, sending it flying end over end to strike with uncanny accuracy
and terrible force. It leaves it its wake a trail of battered enemies.

The Iron Heart tradition's more esoteric teachings allow a student to transform any melee weapon into 
a thrown projectile. By focusing your concentration and attuning your senses to your weapon's balance,
you can throw almost anything.

When you use this strike, you make a singe melee attack (even though you are throwing your weapon).
You deal damage to each creature in the maneuver's area equal to your normal melee damage (including
damage from from Strength modifier, feats, magical abilities on your weapon, and so forth), plus an
extra 12d6 points of damage. Each creature in the attack's area can make a Reflex save with a DC
equal to the result of your attack roll. A successful save halves the damage dealt.

Your weapon automatically returns to your hand at the end of the round.
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
        	object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
                int nDC = d20(1) + GetAttackBonus(oTarget, oInitiator, oWeap);
                SetLocalInt(oInitiator, "IHLightningThrow", TRUE);
                float fLength = FeetToMeters(30.0);
                location lTarget = PRCGetSpellTargetLocation();
                vector vOrigin = GetPosition(oInitiator);
                effect eVis;
                
                oTarget = MyFirstObjectInShape(SHAPE_SPELLCYLINDER, fLength, lTarget, TRUE, OBJECT_TYPE_CREATURE, vOrigin);
                while(GetIsObjectValid(oTarget))
                {
                        if(oTarget != oInitiator)
                        {
                                if(PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC))
                                {
                                        SetLocalInt(oTarget, "LightningThrowSave", TRUE);
                                        DelayCommand(1.0, DeleteLocalInt(oTarget, "LightningThrowSave"));                                        
                                }
                                                      
                                DelayCommand(0.0, PerformAttack(oTarget, oInitiator, eVis, 0.0, 100, d6(12), 0, "Lightning Throw Hit", "Lightning Throw Miss"));
                        }
                        oTarget = MyNextObjectInShape(SHAPE_SPELLCYLINDER, fLength, lTarget, TRUE, OBJECT_TYPE_CREATURE, vOrigin);
                }
                DelayCommand(1.0f, DeleteLocalInt(oInitiator, "IHLightningThrow"));
        }
}