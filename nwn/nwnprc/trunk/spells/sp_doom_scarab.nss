//::///////////////////////////////////////////////
//:: Name      Doom Scarabs
//:: FileName  sp_doom_scarab.nss
//:://////////////////////////////////////////////
/**@file Doom Scarabs
Conjuration/Necromancy
Level: Duskblade 3, sorcerer/wizard 4
Components: V,S
Casting Time: 1 standard action
Range: 60ft
Area: Cone-shaped burst
Duration: Instantaneous
Saving Throw: Will half
Spell Resistance: See text

This spell has two effects. It deals 1d6 points of
damage per two caster levels (maximum 10d6) to all
creatures in the area.  Spell resistance does not
apply to this damage.  However, spell resistance 
does apply to the spell's secondary effect.  If you
ovecome a creature's spell resistance, you gain 1d4
temporary hit points as the scarabs feast on the 
creature's arcane energy and bleed it back into you.
You gain these temporary hit points for each creature
whose spell resistance you overcome.  You never gain
temporary hit points from creatures that do not have 
spell resistance.

The temporary hit points gained from this spell last
for up to 1 hour.

**/

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	PRCSetSchool(SPELL_SCHOOL_NECROMANCY);
	
	object oPC = OBJECT_SELF;
	location lLoc = PRCGetSpellTargetLocation();
	object oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, 18.29f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nMetaMagic = PRCGetMetaMagicFeat();
	int nBonusDice;
	int nDam;
	int nDC;
	float fDur = HoursToSeconds(1);
	
	//don't target the caster moron
	if(oTarget == oPC)
	{
		oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, 18.29f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
	}		
	
	if(nMetaMagic & METAMAGIC_EXTEND)
	{
		fDur += fDur;
	}
	
	while(GetIsObjectValid(oTarget))
	{
		nDam = d6(PRCMin(nCasterLvl/2, 10));
		nDC = PRCGetSaveDC(oTarget, oPC);
			
		if(nMetaMagic & METAMAGIC_MAXIMIZE)
		{
			nDam = 6 * (PRCMin(nCasterLvl/2, 10));
		}
		
		if(nMetaMagic & METAMAGIC_EMPOWER)
		{
			nDam += (nDam/2);
		}
		nDam += SpellDamagePerDice(oPC, PRCMin(nCasterLvl/2, 10));
		if(PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
		{
			nDam = (nDam/2);
			
			if(GetHasMettle(oTarget, SAVING_THROW_WILL))
			{
				PRCSetSchool();
				return;
			}
		}
		
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_MAGICAL), oTarget);
		
		if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
		{
			nBonusDice++;
		}
		
		oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, 18.29f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
	}
	
	effect eBonus = EffectTemporaryHitpoints(d4(nBonusDice));
	
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonus, oPC, fDur);
	
	PRCSetSchool();
}

	
	