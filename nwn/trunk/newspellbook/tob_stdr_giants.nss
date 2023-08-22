//////////////////////////////////////////////////
//  Giant's Stance 
//  tob_stdr_giants.nss
//  Tenjac 9/12/07
//////////////////////////////////////////////////
/** @file Giant's Stance
Stone Dragon (Stance)
Level: Crusader 5, swordsage 5, warblade 5
Prerequisite: Two Stone Dragon maneuvers
Initiation Aciton: 1 swift action
Range: Personal
Target: You
Duration: Stance

You swing your weapon in an wide, deadly arc that slams into your foe with
incredible force. Only your mastery of the Stone Dragon techniques allows you
to make such reckless blows without losing your footing.

Tapping into the power of the Stone Dragon, you strike with resolute, irresistable
force. You learn to set the full weight of your body into each of your attacks. A
warrior with less skill would lose his balance and fall to the ground when using 
this fighting syle.

While you are in this stance, you deal damage as if you were one size larger than
normal, to a maximum of Large. This benefit improves your weapon and unarmed strike
damage. If does not confer any of the other benefits or drawbacks of a change in 
size, such as a modifier to ability scores or AC, or an improved reach.

This stance immediately ends if you move more than 5 feet for any reason such as
from a bull rush attack, a telekinesis spell, and so forth.

*/

#include "tob_inc_move"
#include "tob_movehook"
#include "prc_inc_function"

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
                SetLocalInt(oInitiator, "SDGiantsStance", 1);
                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAttackDecrease(1), oInitiator);
                // Set local int for PRCGetCreatureSize()
                SetLocalInt(oTarget, "PRC_Power_Expansion_SizeIncrease", 1);
                
                        // Size has changed, evaluate PrC feats again
        EvalPRCFeats(oTarget);
                InitiatorMovementCheck(oInitiator, move.nMoveId, 5.0);
        }
}