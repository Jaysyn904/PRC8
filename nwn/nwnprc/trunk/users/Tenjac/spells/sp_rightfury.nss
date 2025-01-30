//:://////////////////////////////////////////////
//:: Name     Righteous Fury
//:: FileName   sp_rightfury.nss
//:://////////////////////////////////////////////
/** @file
Transmutation
Level: Paladin 3,
Components: V, S, DF,
Casting Time: 1 standard action
Range: Personal
Target: You
Duration: 1 minute/level

You pull a holy aura about you that glows a golden red.

Summoning the power of your deity, you charge yourself 
with positive energy. This gives you 5 temporary hit 
points per caster level (maximum 50) and a +4 sacred 
bonus to Strength. These temporary hit points last for
up to 1 hour.
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 1/29/21
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"

void main()
{
	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
	object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDur =  60*(nCasterLvl);
        int nMetaMagic = PRCGetMetaMagicFeat();
        if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;
        int nHP = PRCMin(50, nCasterLvl * 5);
        
        effect eBuff = EffectAbilityIncrease(ABILITY_STRENGTH, 4);
        effect eHP = EffectTemporaryHitpoints(nHP);
        effect eLink = EffectLinkEffects(eBuff, eHP);
        
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDur);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_GOOD_HELP), oPC);
        
        PRCSetSchool();
}