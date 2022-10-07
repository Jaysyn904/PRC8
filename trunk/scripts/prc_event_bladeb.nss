//::///////////////////////////////////////////////
//:: Name      Blade of Blood event script
//:: FileName  prc_evnt_bladeb.nss
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
	object oWielder = OBJECT_SELF;	
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oWielder);
	effect eTest = GetFirstEffect(oWeapon);
	int nDamBonus;
	
	int nMetaMagic = GetLocalInt(oWeapon, "PRC_BLADE_BLOOD_METAMAGIC");
	int nSpell = GetLocalInt(oWeapon, "PRC_BLADE_BLOOD_SPELLID");
	
	if(nSpell == SPELL_BLADE_OF_BLOOD_EMP)
	{		
		nDamBonus = d6(3);
		
		if(nMetaMagic == METAMAGIC_MAXIMIZE)
		{
			nDamBonus = 18;
		}
		
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_EVIL_HELP), oWielder);
	}
    else
    {
        nDamBonus = d6(1);
        
        if(nMetaMagic == METAMAGIC_MAXIMIZE)
        {
            nDamBonus = 6;
        }
    }
	
	if(nMetaMagic == METAMAGIC_EMPOWER)
	{
		nDamBonus += (nDamBonus/2);
	}
	FloatingTextStringOnCreature("Blade of Blood deals "+IntToString(nDamBonus)+" damage", oWielder);
	//Deal bonus damage
	object oTarget = PRCGetSpellTargetObject();
	if (PRCGetIsAliveCreature(oTarget)) SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamBonus, DAMAGE_TYPE_MAGICAL), oTarget);
	
	while (GetIsEffectValid(eTest))
	{
		int nSpell = GetEffectSpellId(eTest);
		if(nSpell == SPELL_BLADE_OF_BLOOD)
		{
			RemoveEffect(oWeapon, eTest);
		}
		
		eTest = GetNextEffect(oWeapon);
	}
	
	//Clean up local ints
	DeleteLocalInt(oWeapon, "PRC_BLADE_BLOOD_METAMAGIC");
	DeleteLocalInt(oWeapon, "PRC_BLADE_BLOOD_SPELLID");
}
