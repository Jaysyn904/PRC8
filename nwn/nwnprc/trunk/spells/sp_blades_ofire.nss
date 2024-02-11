//::///////////////////////////////////////////////
//:: Name      Blades of Fire
//:: FileName  sp_blades_ofire.nss
//:://////////////////////////////////////////////
/**@file Blades of Fire
Conjuration (Creation) [Fire]
Level: Ranger 2, sorcerer/wizard 2, warmage 2
Components: V
Range: Touch
Targets: Up to two melee weapons you are wielding
Duration: 1 round
Saving Throw: None
Spell Resistence: None

Flames sheathe your melee weapons, harming neither
you nor the weapons but possibly burning your 
opponents. Your melee weapons each deal an extra
1d6 points of fire damage. This damage stacks with
any energy damage your weapons already deal.

Author:    Tenjac
Created:   7/6/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	PRCSetSchool(SPELL_SCHOOL_CONJURATION);
	
	object oPC = OBJECT_SELF;
	object oSword1 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	object oSword2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
	float fDur = 9.0f;
	int nMetaMagic = PRCGetMetaMagicFeat();
	itemproperty iprop = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d6);
	
	if(nMetaMagic & METAMAGIC_EXTEND)
	{
		fDur += fDur;
	}
	
	if(IPGetIsMeleeWeapon(oSword1))
	{		
		IPSafeAddItemProperty(oSword1, iprop, fDur);
	}
	
	if(IPGetIsMeleeWeapon(oSword2))
	{
		IPSafeAddItemProperty(oSword2, iprop, fDur);
	}
	
	PRCSetSchool();
}
	