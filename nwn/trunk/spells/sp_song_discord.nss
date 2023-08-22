//::///////////////////////////////////////////////
//:: Name      Song of Discord
//:: FileName  sp_song_discord.nss
//:://////////////////////////////////////////////
/**@file Song of Discord
Enchantment (Compulsion) [Mind-Affecting, Sonic]
Level: Brd 5
Components: V, S
Casting Time: 1 standard action
Range: Medium
Area: 20 ft. burst
Duration: 1 min./level
Saving Throw: Will negates
Spell Resistance: Yes

This spell causes those within the area to turn on each other rather than attack their foes. Each affected creature has a 50% chance to attack the nearest target each round. (Roll to determine each creature’s behavior every round at the beginning of its turn.) A creature that does not attack its nearest neighbor is free to act normally for that round.

Author:    Stratovarius
Created:   5/17/2009
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

void AttackNearestForDuration(object oCreature, object oCaster);

#include "prc_inc_spells"
#include "prc_add_spell_dc"
void main()
{
	if(!X2PreSpellCastCode()) return;
	object oPC = OBJECT_SELF;
	location lLoc = PRCGetSpellTargetLocation();
	object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(20.0), lLoc, TRUE, OBJECT_TYPE_CREATURE);	
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nMetaMagic = PRCGetMetaMagicFeat();
	int nPenalty = 2;
	int nDC = PRCGetSaveDC(oTarget, oPC);
	float fDur = RoundsToSeconds(nCasterLvl);
	
	if (nMetaMagic & METAMAGIC_EXTEND)
	{
		fDur = (fDur * 2);
	}
	
	effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
	       
	while(GetIsObjectValid(oTarget))
	{		
		if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
		{
			//Save
			if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
			{
				SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, fDur);
				AttackNearestForDuration(oTarget, oPC);
			}
		}
		oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(20.0), lLoc, TRUE, OBJECT_TYPE_CREATURE);
	}
	
	PRCSetSchool();
}
	
void AttackNearestForDuration(object oCreature, object oCaster)
{
    object oTarget = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, oCreature, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, -1, -1);

    // stops force attacking when frenzy is over
    if (PRCGetDelayedSpellEffectsExpired(SPELL_SONG_OF_DISCORD, oCreature, oCaster))
    {
        AssignCommand(oCaster, ClearAllActions(TRUE) );
        return;
    }

    // 50% chance
    if (d2() == 1) AssignCommand(oCaster, ActionAttack(oTarget, FALSE));
    DelayCommand(6.0f,AttackNearestForDuration(oCreature, oCaster));
}	