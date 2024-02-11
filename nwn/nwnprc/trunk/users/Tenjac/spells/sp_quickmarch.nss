//:://////////////////////////////////////////////
//:: Name     Quick March
//:: FileName   sp_quickmarch.nss
//:://////////////////////////////////////////////
/** @file Transmutation
Level: Cleric 2, Paladin 2,
Components: V, S, DF,
Casting Time: 1 swift action
Range: Medium (100 ft. + 10 ft./level)
Target: Allies in a 20-ft.-radius burst
Duration: 1 round
Saving Throw: Will negates (harmless)
Spell Resistance: Yes (harmless)

Upon casting this spell, your feet and those of your
allies glow with a yellow nimbus of light.

Quick march increases your allies' base land speed by 
30 feet. (This adjustment is considered an enhancement
bonus.) There is no effect on other modes of movement,
such as burrow, climb, fly, or swim. As with any 
effect that increases a creature's speed, this spell
affects maximum jumping distance.
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 7/19/22
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"


void main()
{
	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
	object oPC = OBJECT_SELF;
        float fDur =  RoundsToSeconds(1);
        int nMetaMagic = PRCGetMetaMagicFeat();
        if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;
        
        effect eSpeed = EffectMovementSpeedIncrease(100);
       	object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(20), lLoc, FALSE, OBJECT_TYPE_CREATURE);
       	
       	while(GetIsObjectValid(oTarget))
       	{
       		if(GetIsReactionTypeFriendly(oTarget))
       		{
       			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSpeed, oTarget, fDur);
       			SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HASTE), oTarget);
       		}       	
       		oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(20), lLoc, FALSE, OBJECT_TYPE_CREATURE);
       	}        
        PRCSetSchool();
}