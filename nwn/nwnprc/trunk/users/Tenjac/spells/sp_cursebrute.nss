//:://////////////////////////////////////////////
//:: Name     Curse of the Brute
//:: FileName   sp_cursebrute.nss
//:://////////////////////////////////////////////
/** @file Transmutation
Level: Paladin 2, Cleric 3,
Components: V, S,
Casting Time: 1 action
Range: Touch
Target: Creature touched
Duration: 1 round/level
Saving Throw: Fortitude negates
Spell Resistance: Yes

You can grant an enhancement bonus up to +1 per caster 
level to one physical ability of the creature touched 
(Strength, Constitution, or Dexterity).
However, this temporarily suppresses both the creature's 
Intelligence and Charisma, each by the amount of the 
enhancement bonus. If this lowers any ability below 3, 
the spell fails.

*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 6/17/2022
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"


void main()
{
	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
	object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDur =  RoundsToSeconds(nCasterLvl);
        int nMetaMagic = PRCGetMetaMagicFeat();
        if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;
        int nAbilBuff;
        object oTarget = PRCGetSpellTargetObject();
        
        int nSpell = PRCGetSpellId();
        
        //Get ability by which spell is used
        if (nSpell == SPELL_CURSE_BRUTE_STR) nAbilBuff = ABILITY_STRENGTH;
        if (nSpell == SPELL_CURSE_BRUTE_DEX) nAbilBuff = ABILITY_DEXTERITY;
        if (nSpell == SPELL_CURSE_BRUTE_CON) nAbilBuff = ABILITY_CONSTITUTION;
        
        //Get maximum bonus without lowering either stat below 3        
        int nBonus = PRCMin(GetAbilityScore(oTarget, ABILITY_CHARISMA), GetAbilityScore(oTarget, ABILITY_INTELLIGENCE)) - 3;
        nBonus = PRCMin(nCasterLvl, nBonus);
        
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityIncrease(nAbilBuff, nBonus), oTarget, fDur);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityDecrease(ABILITY_INTELLIGENCE, nBonus), oTarget, fDur);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityDecrease(ABILITY_CHARISMA, nBonus), oTarget, fDur);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_AURA_RED_LIGHT), oTarget, fDur);
        
        PRCSetSchool();
}