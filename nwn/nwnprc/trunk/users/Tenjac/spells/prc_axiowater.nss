//:://////////////////////////////////////////////
//:: Name     Axiomatic Water Impact Script
//:: FileName   prc_axiowater.nss
//:://////////////////////////////////////////////
/** @file Transmutation [Lawful]
Level: Cleric 1, Paladin 1,
Components: V, S, M,
Casting Time: 1 minute
Range: Touch
Target: Flask of water touched
Duration: Instantaneous
Saving Throw: Will negates (object)
Spell Resistance: Yes (object)

You speak the ancient, slippery words as you pour the iron and silver into the flask. Despite the fact that there
is more powder than will fit in the container, all of it dissolves, leaving a flask of water dotted with motes of gunmetal gray.

This transmutation imbues a flask (1 pint) of water with the order of law, turning it into axiomatic water. Axiomati
water damages chaotic outsiders the way holy water damages undead and evil outsiders. A flask of axiomatic water can 
be thrown as a splash weapon. Treat this attack as a ranged touch attack with a range increment of 10 feet. A flask
breaks if thrown against the body of a corporeal creature, but to use it against an incorporeal creature, the bearer
must open the flask and pout the axiomatic water out onto the target. Thus, a character can douse an incorporeal 
creature with axiomatic water only if he is adjacent to it. Doing so is a ranged touch attack that does not provoke
attacks of opportunity.

A direct hit by a flask of axiomatic water deals 2d4 points of damage to a chaotic outsider. Each such creature 
within 5 feet of the point where the flask hits takes 1 point of damage from the splash.

Material Component: 5 pounds of powdered iron and silver (worth 25 gp).
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 6/10/2022
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"
#include "prc_inc_sp_tch"

void main()
{
	location lTarget = GetSpellTargetLocation();
	float fRadius = FeetToMeters(5);
	int nTouch;
	effect eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
	object oTarget = PRCGetSpellTargetObject();
	
	//Targeted a creature
	if (GetIsObjectValid(oTarget) == TRUE)
	{
		nTouch = PRCDoRangedTouchAttack(oTarget);
	}
	
	//Hit
	if(nTouch >= 1)
	{
		int nDirectDam = d4(2);
	}
	
	//Critical
	if(nTouch == 2)
	{
	        nDam += nDam;
        }
        
        effect eDam = EffectDamage(nDam, DAMAGE_TYPE_DIVINE);
        object oDoNotDam = oTarget;
	
	//Outsider
	if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER)
	{
		//Chaotic
		if(GetAlignmentLawChaos(oTarget) == ALIGNMENT_CHAOTIC)
		{
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		}
	}
	
	oTarget = MyGetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
	while(GetIsObjectValid(oTarget))
	{
		if(oTarget != oDoNotDam)
		{
			//Outsider
			if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER)
			{
				//Chaotic
				if(GetAlignmentLawChaos(oTarget) == ALIGNMENT_CHAOTIC)
				{
					SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(1, DAMAGE_TYPE_DIVINE), oTarget);
					SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				}
			}
		}
		MyGetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
	}
}
			
		