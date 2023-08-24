/*
   ----------------
   Fire Riposte
   
   tob_dw_frrpst.nss
   ----------------

    04/06/07 by Stratovarius
*/ /** @file

    Fire Riposte

    Desert Wind (Counter)
    Level: Swordsage 2
    Initiation Action: 1 Immediate Action
    Range: Personal.
    Target: You.
    Duration: Instantaneous.

    You focus the pain from a wound you have just suffered
    into a firey manifestation of revenge.
    
    The next time you are struck during this round, you make a melee touch attack.
    If it succeeds, the target takes 4d6 fire damage.
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
		IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 6.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        effect eDur = EffectVisualEffect(VFX_DUR_FLAMING_SPHERE);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eDur), oTarget, 6.0);
    }
}