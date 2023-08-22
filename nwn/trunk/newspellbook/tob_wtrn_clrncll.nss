/*
   ----------------
   Clarion Call

   tob_wtrn_clrncll
   ----------------

   29/09/07 by Stratovarius
*/ /** @file

    Clarion Call

    White Raven (Boost)
    Level: Crusader 7, Warblade 7
    Prerequisite: Three White Raven maneuvers
    Initiation Action: 1 swift Action
    Range: 60 ft.
    Area: 60 ft radius.

    As you defeat an opponent, you shout a battle cry that inspires
    one of your allies to renew his efforts.
    
    If you kill a foe with a melee attack this round, all allies in range
    gain a single extra attack in their next round.
*/

#include "tob_inc_move"
#include "tob_movehook"
//#include "prc_alterations"

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
        effect eDur = EffectVisualEffect(VFX_DUR_MARK_OF_THE_HUNTER);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eDur), oTarget, 6.0);
    }
}