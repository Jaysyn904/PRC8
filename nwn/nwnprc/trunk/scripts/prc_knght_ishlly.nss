//::///////////////////////////////////////////////
//:: Knight - Improved Shield Ally
//:: prc_knght_ishlly.nss
//:://////////////////////////////////////////////
//:: Share Pain for one round
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: July 1, 2007
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
	//Declare main variables.
	object oPC = OBJECT_SELF;
	object oTarget = PRCGetSpellTargetObject();
	object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
	object oArmor2 = GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget);
	ExecuteScript("prc_knght_ishart", oTarget);
	
     	int iDamageTaken = GetLocalInt(oTarget, "ShieldAllyDamage");
        int iHeal = 0;
        
        // Once a round, fellas
        if (GetLocalInt(oPC, "ImprovedShieldAlly")) return;
          
     	if(iDamageTaken > 0)
     	{
          	iHeal = iDamageTaken;
          	
          	effect eHeal = EffectHeal(iHeal);
          	ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
          	effect eDamage = EffectDamage(iDamageTaken);
          	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oPC);
          	
     	}
    effect eDur     = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);

    // Get the OnHitCast: Unique on the manifester's armor / hide
    IPSafeAddItemProperty(oArmor2, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 6.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);

    // Hook eventscript
    AddEventScript(oPC, EVENT_ONHIT, "psi_pow_shrpnaux", TRUE, FALSE);
    DelayCommand(6.0, RemoveEventScript(oPC, EVENT_ONHIT, "psi_pow_shrpnaux", TRUE, FALSE));

    // Store the target for use in the damage script
    SetLocalObject(oTarget, "PRC_Power_SharePain_Target", oPC);

    // Do VFX for the monitor to look for
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, 6.0, TRUE, PRCGetSpellId(), 1000);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oPC,     6.0, TRUE, PRCGetSpellId(), 1000);     	
    SetLocalInt(oPC, "ImprovedShieldAlly", TRUE);
          	DelayCommand(6.0, DeleteLocalInt(oPC, "ImprovedShieldAlly"));
}
