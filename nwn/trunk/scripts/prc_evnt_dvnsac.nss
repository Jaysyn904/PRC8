//::///////////////////////////////////////////////
//:: Name      Divine Sacrifice event script
//:: FileName  prc_evnt_dvnsac.nss
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
	object oPC = OBJECT_SELF;
	effect eTest = GetFirstEffect(oPC);
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	
	//if spell has expired, remove event hook
	if(!GetHasSpellEffect(SPELL_DIVINE_SACRIFICE, oPC))
	{
		RemoveEventScript(oPC, EVENT_ONHIT, "prc_evnt_dvnsac");
		return;
	}	
	
	while (GetIsEffectValid(eTest))
	{
		int nSpell = GetEffectSpellId(eTest);
		if(nSpell == SPELL_DIVINE_SACRIFICE_2 ||
		   nSpell == SPELL_DIVINE_SACRIFICE_4 ||
		   nSpell == SPELL_DIVINE_SACRIFICE_6 ||
		   nSpell == SPELL_DIVINE_SACRIFICE_8 ||
		   nSpell == SPELL_DIVINE_SACRIFICE_10)
		{
			RemoveEffect(oPC, eTest);
		}
		
		eTest = GetNextEffect(oPC);
	}
}
	
