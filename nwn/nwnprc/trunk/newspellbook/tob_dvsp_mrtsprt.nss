/*
   ----------------
   Martial Spirit
   
   tob_dvsp_mrtsprt.nss
   ----------------

    29/03/07 by Stratovarius
*/ /** @file

    Martial Spirit

    Devoted Spirit (Stance)
    Level: Crusader 1
    Initiation Action: 1 Swift Action
    Range: Personal.
    Target: You.
    Duration: Stance.

    As you cleave through your foes, each ferocious attack you make lends 
    vigor and strength to you and your allies.
    
    Whenever you successfully strike a creature, you or your ally within 30 feet heals 2 hit points.
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
	    IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        effect eDur = ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_SHIELD_OF_FAITH));
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eDur, oTarget);
    }
}