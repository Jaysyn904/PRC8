/*
Forsaker Fast Healing

Forsakers regain hit points at an exceptionally fast rate. At 1st level, the character regains 1 hit point per round,
to a maximum of 10 hit points per day. The number of hit points regained per round increases by +1 for every four 
forsaker levels, and the maximum restorable per day increases by 10 for every two forsaker levels. Except as noted 
above, this ability works like the fast healing ability described in the introduction of the Monster Manual.
*/

#include "prc_class_const"

void main()
{
    object oPC = OBJECT_SELF;
	int nClass = GetLevelByClass(CLASS_TYPE_FORSAKER, oPC);
	int nRegen = 1 + (nClass-1)/4;
	int nMax = 10 * (nClass+1)/2;
	/*FloatingTextStringOnCreature("Strength = "+IntToString(ABILITY_STRENGTH), oPC, FALSE);
	FloatingTextStringOnCreature("Dex = "+IntToString(ABILITY_DEXTERITY), oPC, FALSE);
	FloatingTextStringOnCreature("Con = "+IntToString(ABILITY_CONSTITUTION), oPC, FALSE);
	FloatingTextStringOnCreature("Int = "+IntToString(ABILITY_INTELLIGENCE), oPC, FALSE);
	FloatingTextStringOnCreature("Wis = "+IntToString(ABILITY_WISDOM), oPC, FALSE);
	FloatingTextStringOnCreature("Cha = "+IntToString(ABILITY_CHARISMA), oPC, FALSE);*/
        
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_NATURE);
    effect eLink = EffectLinkEffects(EffectRegenerate(nRegen, 6.0), EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));

    //Apply effects and VFX
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds((nMax/nRegen)+1));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);    
}