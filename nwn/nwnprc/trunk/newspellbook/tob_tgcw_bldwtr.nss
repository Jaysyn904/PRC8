/*
   ----------------
   Blood in the Water
   
   tob_tgcw_bldwtr.nss
   ----------------

    27/04/07 by Stratovarius
*/ /** @file

    Blood in the Water

    Tiger Claw (Stance)
    Level: Swordsage 1, Warblade 1
    Initiation Action: 1 Swift Action
    Range: Personal.
    Target: You.
    Duration: Stance.

    The smell of blood drives you into a fury. As you slash into your foe,
    each fresh wound you inflict spurs you onward.
    
    Whenever you successfully critical hit a creature, you gain a +1 Attack and Damage bonus for one minute.
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
	IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        effect eDur = EffectVisualEffect(VFX_DUR_BLOOD_FOUNTAIN);
        if (GetHasDefensiveStance(oInitiator, DISCIPLINE_TIGER_CLAW))
    		eDur = EffectLinkEffects(eDur, EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL));
        if (GetLevelByClass(CLASS_TYPE_BLOODCLAW_MASTER, oInitiator) >= 2)
        {
    		eDur = EffectLinkEffects(eDur, EffectMovementSpeedIncrease(33));
    		eDur = EffectLinkEffects(eDur, EffectACIncrease(1));
    	}    	
    	if (GetLocalInt(oInitiator, "TigerFangSharpClaw"))  eDur = EffectLinkEffects(eDur, EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_BASE_WEAPON));       	       
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(eDur), oTarget);
    }
}