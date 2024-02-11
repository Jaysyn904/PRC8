//::///////////////////////////////////////////////
//:: Name      Snap Kick
//:: FileName  tob_ft_snapkick.nss
//:://////////////////////////////////////////////
/** When you make a melee attack with one or more 
melee weapons (including a standard attack, full 
attack, or even a strike maneuver), you can make
an additional attack at your highest attack bonus. 
You take a -2 penalty on all attack rolls you 
make this round.

Author:    Stratovarius
Created:   6.11.2018
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    object oInitiator = OBJECT_SELF;
    int nSwitch = GetLocalInt(oInitiator, "SnapKick");
    
    if (nSwitch == TRUE)
    {
        FloatingTextStringOnCreature("Deactivating Snap Kick", oInitiator, FALSE);
        DeleteLocalInt(oInitiator, "SnapKick");
        PRCRemoveEffectsFromSpell(OBJECT_SELF, 3741);
    }
    else
    {
        FloatingTextStringOnCreature("Activating Snap Kick", oInitiator, FALSE);
        SetLocalInt(oInitiator, "SnapKick", TRUE);
        effect eLinkA = ExtraordinaryEffect(EffectAttackDecrease(2));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLinkA, oInitiator); 
        
        // OnHit for Snap Kick
        object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
        if (IPGetIsMeleeWeapon(oItem))
        {
                // Add eventhook to the weapon
                IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
                AddEventScript(oItem, EVENT_ITEM_ONHIT, "tob_feats", TRUE, FALSE);                    
        }        
    }
}

