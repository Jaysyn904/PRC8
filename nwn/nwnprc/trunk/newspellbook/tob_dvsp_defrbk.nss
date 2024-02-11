/*
   ----------------
   Defensive Rebuke

   tob_dvsp_defrbk
   ----------------

   15/07/07 by Stratovarius
*/ /** @file

    Defensive Rebuke

    Devoted Spirit (Boost)
    Level: Crusader 3
    Prerequisite: One Devoted Spirit maneuver.
    Initiation Action: 1 Swift Action
    Range: Personal
    Target: You
    Duration: 1 round

    You sweep your weapon in a wide, deadly arc. When your blows strike home, you
    send your foe tumbling back on the defensive. He must deal with you first, or 
    leave himself open to your deadly counter.
    
    You make an attack of opportunity against any foe you strike this round
    who targets your allies instead of attacking you.
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
	object oItem = IPGetTargetedOrEquippedMeleeWeapon();
	// Add the OnHit
	IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 6.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        effect eDur = EffectVisualEffect(VFX_DUR_BLUESHIELDPROTECT);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eDur), oTarget, 6.0);
    }
}