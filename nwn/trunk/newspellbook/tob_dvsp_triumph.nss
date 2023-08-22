/*
   ----------------
   Aura of Triumph
   
   tob_dvsp_triumph.nss
   ----------------

    19/09/07 by Stratovarius
*/ /** @file

    Aura of Triumph

    Devoted Spirit (Stance)
    Level: Crusader 6
    Prerequisite: Two Devoted Spirit maneuvers
    Initiation Action: 1 Swift Action
    Range: Personal
    Target: One ally
    Duration: Stance

    You channel the power of good through your body and soul, infusing the area around 
    you with a soft, golden radiance. With each blow you strike against evil, you feel
    invigorated and driven onwards.
    
    While you are in this stance you and the targeted ally both heal 4 points of damage
    with each successful melee attack either of you makes against an evil target.
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
    if (oTarget == oInitiator)
    {
    	FloatingTextStringOnCreature("You cannot target yourself with Aura of Triumph", oInitiator, FALSE);
    	return;
    }

    if(move.bCanManeuver)
    {
	object oItem = IPGetTargetedOrEquippedMeleeWeapon();
	// Add the OnHit
	IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        effect eDur = ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eDur, oTarget);
        oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
	IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eDur, oInitiator);   
        SetLocalObject(oInitiator, "DSTriumph", oTarget);
        SetLocalObject(oTarget, "DSTriumph", oInitiator);
    }
}