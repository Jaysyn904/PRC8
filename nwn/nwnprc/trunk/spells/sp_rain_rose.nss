//::///////////////////////////////////////////////
//:: Name      Rain of Roses
//:: FileName  sp_rain_rose.nss
//:://////////////////////////////////////////////
/**@file Rain of Roses 
Evocation [Good] 
Level: Drd 7 
Components: V, S, M 
Casting Time: 1 standard action 
Range: Long (400 ft. + 40 ft./level) 
Area: Cylinder (80-ft. radius, 80 ft. high)
Duration: 1 round/level (D)
Saving Throw: None (ability damage) and Fortitude 
negates (sickening) 
Spell Resistance: Yes

Red roses fall from the sky. Their sharp thorns 
graze the flesh of evil creatures, dealing 1d4 
points of temporary Wisdom damage per round. A 
creature reduced to 0 Wisdom falls unconscious as
its mind succumbs to horrible nightmares. In 
addition, the beautiful rose petals sicken evil 
creatures touched by them; those that fail a 
Fortitude save are sickened (-2 penalty on attack
rolls, weapon damage rolls, saving throws, 
ability checks, and skill checks) until they
leave the spell's area. A successful Fortitude 
save renders a creature immune to the sickening 
effect of the roses, but not the ability damage 
caused by their thorns.

Material Component: A red rose. 

Author:    Tenjac
Created:   
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
	int nCasterLvl = PRCGetCasterLevel(oPC);
	effect eAOE = EffectAreaOfEffect(VFX_AOE_RAIN_OF_ROSES);
	location lLoc = GetLocation(oPC);
	int nMetaMagic = PRCGetMetaMagicFeat();
	object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, 24.38f, lLoc, FALSE, OBJECT_TYPE_CREATURE);
	float fDur = RoundsToSeconds(nCasterLvl);
	
	if(nMetaMagic & METAMAGIC_EXTEND)
	{
		fDur += fDur;
	}
	
	//Create AoE
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lLoc, fDur);

    object oAoE = GetAreaOfEffectObject(lLoc, "VFX_AOE_RAIN_OF_ROSES");
    SetAllAoEInts(SPELL_RAIN_OF_ROSES, oAoE, PRCGetSpellSaveDC(SPELL_RAIN_OF_ROSES, SPELL_SCHOOL_EVOCATION), 0, nCasterLvl);

	//SPGoodShift(oPC);
	PRCSetSchool();
}