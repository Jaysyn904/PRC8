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
#include "prc_inc_natweap"  
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
  
        // Fallback #1: no melee weapon - check for an existing PRC fist / creature weapon  
        if (!GetIsObjectValid(oItem))  
        {  
            object oFist = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oInitiator);  
            if (GetIsObjectValid(oFist))  
                oItem = oFist;  
        }  
  
        // Fallback #2: still nothing - check for gloves  
        if (!GetIsObjectValid(oItem))  
        {  
            object oGlove = GetItemInSlot(INVENTORY_SLOT_ARMS, oInitiator);  
            if (GetIsObjectValid(oGlove) && GetBaseItemType(oGlove) == BASE_ITEM_GLOVES)  
                oItem = oGlove;  
        }  
  
        // Add the OnHit  
        IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);  
        effect eDur = ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_SHIELD_OF_FAITH));  
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eDur, oTarget);  
    }  
}



/* void main()
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
		if (!GetIsObjectValid(oItem))  
		{  
			object oFist = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oInitiator);  
			if (GetIsObjectValid(oFist))  
				oItem = oFist;  
		} 
 	    
		// Add the OnHit
	    IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        effect eDur = ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_SHIELD_OF_FAITH));
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eDur, oTarget);
    }
} */