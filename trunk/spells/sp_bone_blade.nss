//::///////////////////////////////////////////////
//:: Name       Bone Blade 
//:: FileName   sp_bone_blade.nss 
//:://////////////////////////////////////////////
/**@file Boneblade
Necromancy [Evil]
Level: Blk 2, Clr 3
Components: V, S, F, Undead
Casting Time: 1 action
Range: Touch
Effect: One bone that becomes a blade
Duration: 10 minutes/level

The caster changes a bone at least 6 inches long into
a longsword, short sword, or greatsword (caster's choice).
This weapon has a +1 enhancement bonus on attacks and 
damage for every five caster levels (at least +1, 
maximum +4). Furthermore, this blade deals an extra +1d6
points of damage to living targets and an additional +1d6
points of damage to good­aligned targets.

This spell confers no proficiency with the blade, but the
caster doesn't need to be the one wielding the blade for 
it to be effective.

Focus: A 6-inch-long bone. 

Author:    Tenjac
Created:   3/9/2006
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
	//define vars
	object oPC = OBJECT_SELF;
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nMetaMagic = PRCGetMetaMagicFeat();
	int nType = MyPRCGetRacialType(oPC);
	int nEnhance = 1;
	int nSpell = GetSpellId();
	float fDuration = (600.0f * nCasterLvl);
	string sSword;
	int nRandom = d3(1);
	
	//Spellhook
	if(!X2PreSpellCastCode()) return;
	
	PRCSetSchool(SPELL_SCHOOL_NECROMANCY);
	
	//Check for undeath
	if(nType == RACIAL_TYPE_UNDEAD)
	{
		//Summon blade
		if(nSpell == SPELL_BONEBLADE_GREATSWORD)
		{
			if(nRandom == 1)
			{
				sSword = "wswgs071";
			}
			
			if(nRandom == 2)
			{
				sSword = "wswgs072";
			}
			
			else
			{
				sSword = "wswgs073";
			}
		}
		
		if(nSpell == SPELL_BONEBLADE_LONGSWORD)
		{
			if(nRandom == 1)
			{
				sSword = "wswls091";
			}
			
			if(nRandom == 2)
			{
				sSword = "wswls092";
			}
			
			else
			{
				sSword = "wswls093";
			}
		}
		
		if(nSpell == SPELL_BONEBLADE_SHORTSWORD)
		{
			if(nRandom == 1)
			{
				sSword = "wswss071";
			}
			
			if(nRandom == 2)
			{
				sSword = "wswss072";
			}
			
			else
			{
				sSword = "wswss073";
			}
		}
				
		//Create sword	
		object oSword = CreateItemOnObject(sSword, oPC, 1);
		
		//+1 per 5 levels
		if(nCasterLvl > 9)
		{
			nEnhance = 2;
		}
		
		if(nCasterLvl > 14)
		{
			nEnhance = 3;
		}
		
		if(nCasterLvl > 19)
		{
			nEnhance = 4;
		}
		
		IPSetWeaponEnhancementBonus(oSword, nEnhance);
		
		//+1d6 good
		itemproperty ipProp = ItemPropertyEnhancementBonusVsAlign(IP_CONST_ALIGNMENTGROUP_GOOD, d6(1));		
		
		IPSafeAddItemProperty(oSword, ipProp, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
		
		//+1d6 living, use onHit Unique Power
		itemproperty ipBlade = (ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1));
		IPSafeAddItemProperty(oSword, ipBlade, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
		
		AddEventScript(oSword, EVENT_ITEM_ONHIT, "prc_evnt_bonebld", TRUE, FALSE); 
				
		//Check metamagic
		if (nMetaMagic & METAMAGIC_EXTEND)
		{
			fDuration = (fDuration * 2);
		}
		
		//Schedule deletion of item
		DelayCommand(fDuration, DestroyObject(oSword));
		
	}
	//SPEvilShift(oPC);
	PRCSetSchool();
}
	
	
	