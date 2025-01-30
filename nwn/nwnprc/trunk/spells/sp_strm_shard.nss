//::///////////////////////////////////////////////
//:: Name      Storm of Shards
//:: FileName  sp_strm_shard.nss
//:://////////////////////////////////////////////
/**@file Storm of Shards 
Evocation [Good] 
Level: Sanctified 6 
Components: V, S, Sacrifice 
Casting Time: 1 standard action 
Range: 0 ft.
Area: 80-ft.-radius spread 
Duration: Instantaneous
Saving Throw: Fortitude negates (blinding),
Reflex half (shards) 
Spell Resistance: Yes

Shards of heavenly light rain down from above. 
Evil creatures within the spell's area that fail 
a Fortitude save are blinded permanently. The 
light shards also slice the flesh of evil 
creatures, dealing 1d6 points of damage per caster
level (maximum 20d6). A successful Reflex save 
halves the damage, which is of divine origin.

Sacrifice: 1d3 points of Strength drain. 

Author:    Tenjac
Created:   6/28/06
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
	location lLoc = GetLocation(oPC);
	object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, 24.38f, lLoc, FALSE, OBJECT_TYPE_CREATURE);
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nDC = PRCGetSaveDC(oTarget, oPC);
	int nAlign;
	int nMetaMagic = PRCGetMetaMagicFeat();
	
	//VFX
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_FIRESTORM), lLoc);
	
	while(GetIsObjectValid(oTarget))
	{
		if(!PRCDoResistSpell(OBJECT_SELF, oTarget, nCasterLvl + SPGetPenetr()))
		{
			nAlign = GetAlignmentGoodEvil(oTarget);
			
			if(nAlign == ALIGNMENT_EVIL)
			{
				if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_DIVINE))
				{
					SPApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectBlindness(), oTarget);
				}
				
				int nDam = d6(PRCMin(nCasterLvl, 20));
				
				if(nMetaMagic & METAMAGIC_MAXIMIZE)
				{
					nDam = 6 *(PRCMin(nCasterLvl, 20));
				}
				
				if(nMetaMagic & METAMAGIC_EMPOWER)
				{
					nDam += (nDam/2);
				}
				
				if(PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_DIVINE))
				{
					nDam = nDam/2;
				}
				nDam += SpellDamagePerDice(oPC, PRCMin(nCasterLvl, 20));
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_DIVINE), oTarget);
			}
		}
		oTarget = MyNextObjectInShape(SHAPE_SPHERE, 24.38f, lLoc, FALSE, OBJECT_TYPE_CREATURE);
	}
	
	//Sanctified spells get mandatory 10 pt good adjustment, regardless of switch
	AdjustAlignment(oPC, ALIGNMENT_GOOD, 10, FALSE);
	
	//SPGoodShift(oPC);
	DoCorruptionCost(oPC, ABILITY_STRENGTH, d3(1), 1);
	PRCSetSchool();
}
		
				
	