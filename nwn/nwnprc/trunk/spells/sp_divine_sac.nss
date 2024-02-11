//::///////////////////////////////////////////////
//:: Name      Divine Sacrifice
//:: FileName  sp_divine_sac.nss
//:://////////////////////////////////////////////
/**@file Divine Sacrifice
Necromancy
Level: Paladin 1
Compnonents: V,S
Casting Time: 1 standard action
Range: Personal
Target: Self
Duration: 1 round/level or until discharged

You can sacrifice life force to increase the damage
you deal.  When you cast the spell, you can sacrifice
up to 10 of your hit points.  For every 2 hp you 
sacrifice, on your next successful attack you deal
+1d6 damage, to a maximum of +5d6 on that attack.
Your ability to deal this extra damage ends when you 
successfully attack or when the spell duration ends.
Sacrificed hit points count as normal lethal damage, 
even if you have the regenration ability.

Author:    Tenjac
Created:   6/22/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	PRCSetSchool(SPELL_SCHOOL_NECROMANCY);
	
	object oPC = OBJECT_SELF;
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nSpell = GetSpellId();
	int nDam;
	int nHPLoss;
	float fDur = RoundsToSeconds(nCasterLvl);
	
	if(nSpell == SPELL_DIVINE_SACRIFICE_2)
	{
		nDam = d6(1);
		nHPLoss = 2;
	}
	
	if(nSpell == SPELL_DIVINE_SACRIFICE_4)
	{
		nDam = d6(2);
		nHPLoss = 4;
	}
	
	if(nSpell == SPELL_DIVINE_SACRIFICE_6)
	{
		nDam = d6(3);
		nHPLoss = 6;
	}
	
	if(nSpell == SPELL_DIVINE_SACRIFICE_8)
	{
		nDam = d6(4);
		nHPLoss = 8;
	}
	
	if(nSpell == SPELL_DIVINE_SACRIFICE_10)
	{
		nDam = d6(5);
		nHPLoss = 10;
	}
	
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oPC, nHPLoss, DAMAGE_TYPE_DIVINE), oPC);
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageIncrease(nDam, DAMAGE_TYPE_MAGICAL), oPC, fDur);
	
	//Set up removal
	itemproperty ipHook = ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1);
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	
	IPSafeAddItemProperty(oWeapon, ipHook, fDur);
	
	AddEventScript(oPC, EVENT_ONHIT, "prc_evnt_dvnsac", FALSE, FALSE);
	
	PRCSetSchool();
}