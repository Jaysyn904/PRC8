//::///////////////////////////////////////////////
//:: Name      Inlindl School
//:: FileName  prc_ft_inlindl.nss
//:://////////////////////////////////////////////
/** 
	You can choose to sacrifice your shield bonus 
	to AC in exchange for a bonus on melee attack rolls 
	equal to one-half that bonus. This bonus applies 
	only on attacks made with light weapons.

	Author:    Stratovarius
	Created:   12.11.2018

	Fixed by: 	Jaysyn
	Fixed on: 	2025-07-24 16:18:03
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
#include "prc_inc_spells"
#include "prc_inc_combat"
#include "prc_inc_combmove"
 
 
void main()
{
    object oInitiator 	= OBJECT_SELF;
	object oTarget 		= PRCGetSpellTargetObject();
	object oWeapon 		= GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
	
	int nWeaponType		= GetBaseItemType(oWeapon);
	int nWeaponSize 	= GetWeaponSize(oWeapon);
	int nCreatureSize	= GetCreatureSize(oInitiator);
		
	
	if(DEBUG) DoDebug("prc_ft_inlindl >> Base item type: " + IntToString(nWeaponType));
	
	if(DEBUG) DoDebug("prc_ft_inlindl >> Base item size: " + IntToString(nWeaponSize));

	if(DEBUG) DoDebug("prc_ft_inlindl >> Creature size: " + IntToString(nCreatureSize));
			
	effect eBlank;
	
	if (nWeaponType != BASE_ITEM_RAPIER && nWeaponType != BASE_ITEM_ELVEN_THINBLADE && nWeaponType != BASE_ITEM_ELVEN_COURTBLADE &&
		(nWeaponSize > 3 || nWeaponSize >= nCreatureSize))
	{
		SendMessageToPC(oInitiator, "Inlindl School strike requires a light weapon.");
		PerformAttack(oTarget, oInitiator, eBlank);
		return;
	}
	
	PRCRemoveEffectsFromSpell(oInitiator, GetSpellId());
	
	int nShieldAC = GetTotalShieldACBonus(oInitiator);	
	
	effect eShieldMalus = EffectACDecrease(nShieldAC, AC_SHIELD_ENCHANTMENT_BONUS);	
	effect eVis = EffectVisualEffect(VFX_DUR_ARMOR_OF_DARKNESS);	
	effect eLink = EffectLinkEffects(eShieldMalus, eVis);	
	
	//DelayCommand(0.0f, ClearAllActions());
	//DelayCommand(0.1f, AssignCommand(oInitiator, 
	PerformAttackRound(oTarget, oInitiator, eBlank, 0.0, nShieldAC/2, 0, 0, TRUE, "Inlindl School Strike (+"+IntToString(nShieldAC/2)+") : Hit!", "Inlindl School Strike (+"+IntToString(nShieldAC/2)+") : Miss!");
	
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eLink), oInitiator, 5.9);
	
	ActionAttack(oTarget);
	
}	

// Almost every part of this is wrong. - Jaysyn
/* void main()
{
    object oInitiator = OBJECT_SELF;
    int nSwitch = GetLocalInt(oInitiator, "InlindlSchool");
    
    if (nSwitch == TRUE)
    {
        FloatingTextStringOnCreature("Deactivating Inlindl School", oInitiator, FALSE);
        DeleteLocalInt(oInitiator, "InlindlSchool");
        PRCRemoveEffectsFromSpell(oInitiator, GetSpellId());
    }
    else
    {
        FloatingTextStringOnCreature("Activating Inlindl School", oInitiator, FALSE);
        SetLocalInt(oInitiator, "InlindlSchool", TRUE);
        int nShield = GetItemACValue(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oInitiator));
        effect eLink = EffectLinkEffects(EffectACDecrease(nShield), EffectAttackIncrease(nShield/2));
        eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_ARMOR_OF_DARKNESS));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eLink), oInitiator, 6.0);         
    }
} */

