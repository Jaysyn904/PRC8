//::///////////////////////////////////////////////
//:: Name      Leonal's Roar
//:: FileName  sp_leonl_roar.nss
//:://////////////////////////////////////////////
/**@file Leonal's Roar 
Evocation [Good, Sonic]
Level: Drd 8 
Components: V 
Casting Time: 1 standard action 
Range: 40 ft.
Targets: Non good creatures in a 40-ft.radius spread
centered on you 
Duration: Instantaneous
Saving Throw: Fortitude partial 
Spell Resistance: Yes

This spell has the effect of a holy word, and it 
additionally deals 2d6 points of sonic damage to 
non-good creatures in the area. A successful 
Fortitude saving throw negates the sonic damage, 
but not the other effects of the spell.

Author:    Tenjac
Created:   7/7/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	PRCSetSchool(SPELL_SCHOOL_EVOCATION);
	
	object oPC = OBJECT_SELF;
	location lLoc = PRCGetSpellTargetLocation();
	object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, 12.192, lLoc, TRUE, OBJECT_TYPE_CREATURE);
	int nDC;
	int nMetaMagic = PRCGetMetaMagicFeat();
	int nDam;
	int nCasterLvl = PRCGetCasterLevel(oPC);
	
	while(GetIsObjectValid(oTarget))
	{
		nDC = PRCGetSaveDC(oTarget, oPC);
		
		if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
		{
			if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SONIC))
			{
				nDam = d6(2);
				
				if(nMetaMagic & METAMAGIC_MAXIMIZE)
				{
					nDam = 12;
				}
				
				if(nMetaMagic & METAMAGIC_EMPOWER)
				{
					nDam += (nDam/2);
				}
				nDam += SpellDamagePerDice(oPC, 2);
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_SONIC), oTarget);
			}
		}
		oTarget = MyNextObjectInShape(SHAPE_SPHERE, 12.192, lLoc, TRUE, OBJECT_TYPE_CREATURE);
	}	
	//Holy Word
	ActionCastSpellAtLocation(SPELL_HOLY_WORD, lLoc, nMetaMagic, TRUE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
	//SPGoodShift(oPC);
}