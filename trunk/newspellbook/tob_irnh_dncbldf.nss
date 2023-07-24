//////////////////////////////////////////////////
//  Dancing Blade Form
//  tob_dncbldf.nss
//  Tenjac 9/21/07
//////////////////////////////////////////////////
/** @file Dancing Blade Form
Iron Heart(Stance)
Level: Warblade 5
Prerequisite: Two Iron Heart maneuvers
Initiation Action: 1 swift action
Range: Personal
Target: You
Duration: Stance

You stike forward like a slithering snake, extending yourself almost beyond your ability to maintain
your balance. Your foe stumbles backward, surprised that you could reach him from such a great distance.

By carefully distributing your weight and establishing a steady, rugged posture, you can reach out and
strike with your melee attacks at a greater than normal distance. A warrior with less training and 
expertise would fall flat on his face attempting this maneuver. You, on the otherhand, have the grace,
focus, and skill needed to complete this complex move.

While you are in this stance, you gain a bonus to your reach during your turn. When you make a melee
attack, your reach increases by 5 feet. Your reach is not improved when it is not your turn, such as
when you make an attack of opportunity. You cannot improve your reach by more than 5 feet using this
ability in conjunction with other maneuvers.
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
            InitiatorMovementCheck(oInitiator, move.nMoveId, 5.0);
            SetLocalInt(oInitiator, "IHDancingBladeForm", 1);
        	
        	effect eLink = EffectVisualEffect(VFX_DUR_AIR2);
        	if (GetLocalInt(oInitiator, "KamateStance"))
			{
				eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, GetLocalInt(oInitiator, "KamateStance")));
			}
            eLink = ExtraordinaryEffect(eLink);

        	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oInitiator);                
        }
}