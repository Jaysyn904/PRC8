//::///////////////////////////////////////////////
//:: Name: Seething Eyebane
//:: Filename: sp_seeth_eyebn.nss
//::///////////////////////////////////////////////
/**Seething Eyebane
Transmutation [Evil, Acid]
Level: Corrupt 1
Components: V, S, Corrupt
Casting Time: 1 action
Range: Touch
Target: Creature touched
Duration: Instantaneous
Saving Throw: Fortitude negates (see text)
Spell Resistance: Yes

The subject's eyes burst, spraying acid upon everyone
within 5 feet. The subject is blinded and takes 1d6
points of acid damage. Those sprayed take 1d6 points
of acid damage (Reflex save for half). Creatures 
without eyes can't be blinded, but they might take 
acid damage if someone nearby is the subject of 
seething eyebane.

Corruption Cost: 1d6 points of Constitution damage

@author Written By: Tenjac
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_add_spell_dc"
void main()
{
    if (!X2PreSpellCastCode()) return;

	PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
	//define vars
	object oPC = OBJECT_SELF;
	object oTarget = PRCGetSpellTargetObject();
	location lTarget = GetLocation(oTarget);
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nDC = PRCGetSaveDC(oTarget, oPC);
	int nType = MyPRCGetRacialType(oTarget);
	
	PRCSignalSpellEvent(oTarget, TRUE, SPELL_SEETHING_EYEBANE, oPC);
	
	if(nType != RACIAL_TYPE_CONSTRUCT &&
	   nType != RACIAL_TYPE_OOZE &&
	   nType != RACIAL_TYPE_ELEMENTAL &&
	   nType != RACIAL_TYPE_UNDEAD)
	{
		//Spell Resistance
		if (!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
		{		
			//Fort save
			if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_ACID))    
			{
				
				//Blind target permanently
				effect eBlind = EffectBlindness();
				SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eBlind, oTarget);
				
				oTarget = MyFirstObjectInShape(SHAPE_SPHERE, 5.0, lTarget, FALSE, OBJECT_TYPE_CREATURE);
				
				while(GetIsObjectValid(oTarget))
				{
					//nDam = 1d6 acid
					int nDam = d6(1);
                	// Acid Sheath adds +1 damage per die to acid descriptor spells
                	if (GetHasDescriptor(GetSpellId(), DESCRIPTOR_ACID) && GetHasSpellEffect(SPELL_MESTILS_ACID_SHEATH, oPC))
                		nDam += 1;  			
					nDam += SpellDamagePerDice(oPC, 1);                		
					effect eDam = PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_ACID);
					
					//apply damage
					SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
					
					oTarget = MyNextObjectInShape(SHAPE_SPHERE, 5.0, lTarget, FALSE, OBJECT_TYPE_CREATURE);
				}
				
			}
		}
	}
	//Corruption cost 1d6 CON regardless of success
	int nCost = d6(1);
	
	DoCorruptionCost(oPC, ABILITY_CONSTITUTION, nCost, 0);
	
	//Corrupt spells get mandatory 10 pt evil adjustment, regardless of switch
	AdjustAlignment(oPC, ALIGNMENT_EVIL, 10, FALSE);
	
	//SPEvilShift(oPC);	
	PRCSetSchool();
	
}