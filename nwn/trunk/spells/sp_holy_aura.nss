//::///////////////////////////////////////////////
//:: Name      Holy Aura
//:: FileName  sp_holy_aura.nss
//:://////////////////////////////////////////////8
/** @file Holy Aura
Abjuration [Good]
Level: 	Clr 8, Good 8, Hlr 8
Components: 	V, S, F
Casting Time: 	1 standard action
Range: 	20 ft.
Targets: 	One creature/level in a 20-ft.-radius burst centered on you
Duration: 	1 round/level (D)
Saving Throw: 	See text
Spell Resistance: 	Yes (harmless)

A brilliant divine radiance surrounds the subjects, 
protecting them from attacks, granting them resistance
to spells cast by evil creatures, and causing evil 
creatures to become blinded when they strike the
subjects. This abjuration has four effects.

First, each warded creature gains a +4 deflection bonus 
to AC and a +4 resistance bonus on saves. Unlike 
protection from evil, this benefit applies against all 
attacks, not just against attacks by evil creatures.

Second, each warded creature gains spell resistance 25 
against evil spells and spells cast by evil creatures.

Third, the abjuration blocks possession and mental 
influence, just as protection from evil does.

Finally, if an evil creature succeeds on a melee 
attack against a warded creature, the offending 
attacker is blinded (Fortitude save negates, as 
blindness/deafness, but against holy aura’s save DC).

Focus: A tiny reliquary containing some sacred relic. 
The reliquary costs at least 500 gp. 

**/
////////////////////////////////////////////////////
// Author: Tenjac
// Date :  7.10.06
////////////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_spells"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	PRCSetSchool(SPELL_SCHOOL_ABJURATION);
	
	object oPC = OBJECT_SELF;
	location lLoc = GetLocation(oPC);
	object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(20.0f), lLoc, FALSE, OBJECT_TYPE_CREATURE);
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nCounter = nCasterLvl;
	int nMetaMagic = PRCGetMetaMagicFeat();
	float fDur = RoundsToSeconds(nCasterLvl);
	effect eDur = EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MINOR);
	eDur = EffectLinkEffects(EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE), eDur);
	
	if(nMetaMagic & METAMAGIC_EXTEND)
	{
		fDur += fDur;
	}
	
	effect eLink = EffectLinkEffects(VersusAlignmentEffect(EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS), ALIGNMENT_ALL, ALIGNMENT_EVIL), EffectACIncrease(4, AC_DEFLECTION_BONUS, AC_VS_DAMAGE_TYPE_ALL));
	eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, 4, SAVING_THROW_TYPE_ALL));
	eLink = EffectLinkEffects(eLink, VersusAlignmentEffect(EffectSpellResistanceIncrease(25), ALIGNMENT_ALL, ALIGNMENT_EVIL));
	eLink = EffectLinkEffects(eLink, eDur);
	
	while(GetIsObjectValid(oTarget) && nCounter > 0)
	{
		if(GetIsFriend(oTarget, oPC))
		{
			nCounter--;
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur);
		}
		oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(20.0f), lLoc, FALSE, OBJECT_TYPE_CREATURE);
	}
	
	PRCSetSchool();
}
	
	
	
	
	