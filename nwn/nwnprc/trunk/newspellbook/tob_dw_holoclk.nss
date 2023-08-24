/*
   ----------------
   Holocaust Cloak
   
   tob_dvsp_mrtsprt.nss
   ----------------

    15/07/07 by Stratovarius
*/ /** @file

    Holocaust Cloak

    Desert Wind (Stance) [Fire]
    Level: Swordsage 3
    Prerequisite: One Desert Wind Maneuver
    Initiation Action: 1 Swift Action
    Range: Personal
    Target: You
    
    Fire trails along your blade as you spin it about,
    cloaking you in flames that leap out to burn those who attack you.
    
    You cloak yourself in fire, dealing 5 damage to all who strike you in melee.
    This is a supernatural maneuver.
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
	object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oInitiator);
	// Add the OnHit
	IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        effect eDur = SupernaturalEffect(EffectVisualEffect(VFX_DUR_ELEMENTAL_SHIELD));
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eDur, oTarget);
    }
}