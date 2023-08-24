/*
   ----------------
   Iron Guard's Glare

   tob_dvsp_igglr.nss
   ----------------

    29/03/07 by Stratovarius
*/ /** @file

    Iron Guard's Glare

    Devoted Spirit (Stance)
    Level: Crusader 1
    Initiation Action: 1 Swift Action
    Range: Personal.
    Target: You.
    Duration: Stance.

    With a quick snarl and a glare that would stop a charging barbarian in his tracks,
    you spoil an opponent's attack. Rather than strike his original target, your enemy
    turns his attention to you.
    
    Any creature you threaten takes a -4 penalty on attacks against allies.
    (Mechnical implementation: AoE that grants allies +4 Dodge AC when they are in it).
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
	SPApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectAreaOfEffect(AOE_PER_IRON_GUARD_GLARE)), oTarget);
    }
}