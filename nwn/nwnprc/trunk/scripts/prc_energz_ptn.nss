//::///////////////////////////////////////////////
//:: Name      Energized Potion Use Script
//:: FileName  prc_energz_ptn.nss
//:://////////////////////////////////////////////
/**@file Energize Potion
Transmutation
Level: Cleric 3, druid 3, sorc/wizard 2, Wrath 2
Components: V,S,M
Casting Time: 1 standard action
Range: Close
Effect: 10ft radius
Duration: Instantaneous
Saving Throw: Reflex half
Spell Resistance: Yes

This spell transforms a magic potion into a volatile
substance that can be hurled out to the specified 
range. The spell destroys the potion and releases
a 10-foot-radius burst of energy at the point of
impact. The caster must specify the energy type
(acid, cold, electricity, fire, or sonic) when the
spell is cast.

The potion deals 1d6 points of damage (of the
appropriate energy type) per spell level of the 
potion (maximum 3d6). For example, a potion of 
displacement transformed by this spell deals 3d6
points of damage. An energized potion set to deal
fire damage ignites combustibles within the burst
radius.

Author:    Tenjac
Created:   7/24/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
	location lLoc = GetSpellTargetLocation();
	object oPotion = GetSpellCastItem();
	int nDice = GetLocalInt(oPotion, "PRC_GrenadeLevel");
	int nType = GetLocalInt(oPotion, "PRC_GrenadeDamageType");
	int nCasterLvl = GetLocalInt(oPotion, "PRC_EnergizePotionCL");
	int nSave = GetLocalInt(oPotion, "PRC_EnergizedPotionSave");
	int nDC;	
	int nDam;
	
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 3.05f, lLoc, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	
	while(GetIsObjectValid(oTarget))
	{
		if(!PRCDoResistSpell(oPotion, oTarget, nCasterLvl + SPGetPenetr()))
		{
			nDC = PRCGetSaveDC(oPotion, oTarget);
			nDam = d6(nDice);
			
			if(PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, nSave))
			{
				nDam = (nDam/2);
			}
			
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam, nType), oTarget);
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, 3.05f, lLoc, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	}
}
				
				
	