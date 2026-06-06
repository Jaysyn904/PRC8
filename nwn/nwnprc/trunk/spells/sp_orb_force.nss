//::///////////////////////////////////////////////
//:: Name      
//:: FileName  sp_.nss
//:://////////////////////////////////////////////
/**@file Orb of Force
Conjuration (Creation) [Force]
Level: Sorcerer/wizard 4
Components: V, S
Casting Time: 1 standard action
Range: Medium (100 ft. + 10 ft./level)
Effect: One orb of force
Duration: Instantaneous
Saving Throw: None
Spell Resistance: No

You create a globe of force 3 inches
across, which streaks from your palm
toward your target. You must succeed on
a ranged touch attack to hit the target.
The orb deals 1d6 points of damage per
caster level (maximum 10d6).

Author:    Tenjac
Created:   7/6/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_sp_tch"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	PRCSetSchool(SPELL_SCHOOL_CONJURATION);
	
	object oPC = OBJECT_SELF;
	object oTarget = PRCGetSpellTargetObject();
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nDice = PRCMin(10, nCasterLvl);
	int nDam = d6(nDice);
	int nTouch = PRCDoRangedTouchAttack(oTarget);
	int nMetaMagic = PRCGetMetaMagicFeat();
	
	if(nMetaMagic & METAMAGIC_MAXIMIZE) nDam = 6 * nDice;
	
	if(nMetaMagic & METAMAGIC_EMPOWER) nDam += (nDam/2);
	nDam += SpellDamagePerDice(oPC, nDice);
	PRCSignalSpellEvent(oTarget, TRUE, SPELL_ORB_OF_FORCE);
	
	if(nTouch)
	{
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PULSE_BOMB), oTarget);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_FORCE), oTarget);
	}
}
	