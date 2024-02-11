//::///////////////////////////////////////////////
//:: Name      Boneblade event script
//:: FileName  prc_evnt_bonebld.nss
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
	object oSpellOrigin = OBJECT_SELF;
	object oSpellTarget = PRCGetSpellTargetObject(oSpellOrigin);
	object oItem        = PRCGetSpellCastItem(oSpellOrigin);
/*
// motu99: obsolate, is handled in PRCGetSpellCastItem
	
	// Scripted combat system
	if(!GetIsObjectValid(oItem))
	{
		oItem = GetLocalObject(oSpellOrigin, "PRC_CombatSystem_OnHitCastSpell_Item");
	}
*/	
	//Boneblade +1d6 damage vs living
	if (GetHasSpellEffect(SPELL_BONEBLADE, oItem))
	{
		if(PRCGetIsAliveCreature(oSpellTarget))
		{
			effect eDam = EffectDamage(d6(1), DAMAGE_TYPE_MAGICAL);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oSpellTarget);
		}
	}
}