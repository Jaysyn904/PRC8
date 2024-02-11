//:://////////////////////////////////////////////
//:: Name     Axiomatic Storm
//:: FileName   sp_axio_storm.nss
//:://////////////////////////////////////////////
/** @file
Conjuration (Creation)
Level: Cleric 3, Paladin 3,
Components: V, S, M, DF,
Casting Time: 1 standard action
Area: Cylinder (20-ft. radius, 20 ft. high)
Duration: 1 round/level (D)
Saving Throw: None
Spell Resistance: No

You call upon the forces of law and a heavy rain 
begins to fall around you, its raindrops harsh and 
metallic. Above you, a jet of caustic acid lances 
down from the heavens.

A driving rain falls around you. It falls in a fixed
area once created. The storm reduces hearing and
visibility, resulting in a —4 penalty on Listen, Spot,
and Search checks. It also applies a —4 penalty on ranged
attacks made into, out of, or through the storm. Finally, 
it automatically extinguishes any unprotected flames and 
has a 50% chance to extinguish protected flames (such as 
those of lanterns).

The rain damages chaotic creatures, dealing 2d6 points
of damage per round (chaotic outsiders take double damage).
In addition, each round, a gout of acid strikes a randomly 
selected chaotic outsider within the spell's area, dealing
5d6 points of acid damage. 
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 1/28/21
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"

void DoAcid(int nCount, location lLoc, object oPC)
{	
	if(nCount >0)
	{	
		object oChaotic = GetFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(20), lLoc);
		{
			while(GetIsObjectValid(oChaotic))
			{
				if(GetAlignmentLawChaos(oChaotic) == ALIGNMENT_CHAOTIC))  
				{
					if(PRCGetRacialType(oChaotic) == RACIAL_TYPE_OUTSIDER))
					{
						//increment count of chaotic outsiders
						nOutsiders++;
						
						//Set as a target
						SetLocalObject(oPC, "oAxioStorm" + IntToString(nOutsiders), oChaotic);
					}
				}
				oChaotic = GetNextObjectInShape(SHAPE_SPHERE, FeetToMeters(20), lLoc);
			}
		}
		//get a random number
		int nRandom = Random(nOutsiders);
		
		//Get the target
		object oTarget = GetLocalObject(oPC, "oAxioStorm" + IntToString(nRandom));
		
		//Deal acid damage
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, d6(5), DAMAGE_TYPE_ACID));
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_ACID), oTarget);
		
		//another round down
		nCount--;
		nOutsiders=0;
		
		if(nCount >0) DelayCommand(6.0f, DoAcid(nCount, lLoc, oPC));
	}
}

void main()
{
	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_ABJURATION);
	object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDur =  RoundsToSeconds(nCasterLvl);
        int nCount = nCasterLvl;
        int nMetaMagic = PRCGetMetaMagicFeat();
        if(nMetaMagic & METAMAGIC_EXTEND)
        {
        	fDur += fDur;
        	nCount += nCount;
        }   
        
        //Apply AoE
        effect eAoe = EffectAreaOfEffect(AOE_PER_AXIOMATIC_STORM);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAoe, lLoc, fDur);
        
        DoAcid(nCount, lLoc, oPC);
        
        PRCSetSchool();
}