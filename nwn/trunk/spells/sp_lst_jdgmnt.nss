//::///////////////////////////////////////////////
//:: Name      Last Judgment
//:: FileName  sp_lst_jdgmnt.nss
//:://////////////////////////////////////////////
/**@file Last Judgment
Necromancy [Death, Good] 
Level: Clr 8, Sor/Wiz 8, Wrath 8
Components: V, Celestial 
Casting Time: 1 round 
Range: Close (25 ft. + 5 ft./2 levels) 
Target: One evil humanoid, monstrous humanoid, or
giant/2 levels 
Duration: Instantaneous
Saving Throw: Will partial 
Spell Resistance: Yes

Reciting a list of the targets' evil deeds, you call
down the judgment of the heavens upon their heads. 
Creatures that fail their saving throw are struck 
dead and bodily transported to the appropriate Lower
Planes to suffer their eternal punishment. Creatures 
that succeed nevertheless take 3d6 points of 
temporary Wisdom damage as guilt for their misdeeds
overwhelms their minds.

This spell affects only humanoids, monstrous 
humanoids, and giants of evil alignment.

A true resurrection or miracle spell can restore life 
to a creature slain by this spell normally. A 
resurrection spell works only if the creature's body 
can be recovered from the Lower Planes before the 
resurrection is cast.

Author:    Tenjac
Created:   7/6/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_inc_template"
#include "prc_add_spell_dc"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	PRCSetSchool(SPELL_SCHOOL_NECROMANCY);
	
	object oPC = OBJECT_SELF;
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nToBeAffected = nCasterLvl / 2;
	int nDC; 
	location lLoc = PRCGetSpellTargetLocation();
	
	//Must be Celestial
	if(GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD) 
	{
		if((MyPRCGetRacialType(oPC) == RACIAL_TYPE_OUTSIDER) || (GetHasTemplate(TEMPLATE_CELESTIAL)) || (GetHasTemplate(TEMPLATE_HALF_CELESTIAL)))
		{
			object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, 7.62, lLoc, FALSE, OBJECT_TYPE_CREATURE);
			
			while(GetIsObjectValid(oTarget))
			{
				if(nToBeAffected > 0)
				{
					int nType = MyPRCGetRacialType(oTarget);
					
					if(nType != RACIAL_TYPE_UNDEAD &&
					nType != RACIAL_TYPE_CONSTRUCT &&
					nType != RACIAL_TYPE_ELEMENTAL &&
					nType != RACIAL_TYPE_VERMIN    &&
					nType != RACIAL_TYPE_OOZE      &&
					nType != RACIAL_TYPE_ANIMAL    &&
					nType != RACIAL_TYPE_ABERRATION &&
					nType != RACIAL_TYPE_BEAST)
					{
						if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
						{
							//decrement the counter
							nToBeAffected--;
							
							if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
							{
								nDC = PRCGetSaveDC(oTarget, oPC);
								
								if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_DEATH))
								{
									SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
									
									
									//Any module specific code for moving the body to another plane would go here
								}
								else
								{
									if(!GetHasMettle(oTarget, SAVING_THROW_WILL))
									{
										//made save, apply ability damage
										ApplyAbilityDamage(oTarget, ABILITY_WISDOM, d6(3), DURATION_TYPE_TEMPORARY, TRUE, -1.0f);
									}
								}
							}
						}
					}
				}
			oTarget = MyNextObjectInShape(SHAPE_SPHERE, 7.62, lLoc, FALSE, OBJECT_TYPE_CREATURE);
			}			
		}
		
		else SendMessageToPC(oPC, "You do not meet the casting requirements for this spell.");
	}	
	//SPGoodShift(oPC);
	PRCSetSchool();
}
								
								
	
	
	