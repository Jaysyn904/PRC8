//:://////////////////////////////////////////////
//:: Name     Holy Fire
//:: FileName   sp_holyfire.nss
//:://////////////////////////////////////////////
/** @file Evocation [Fire, Good]
Level: Cleric 2, Paladin 3,
Components: V, S, DF,
Casting Time: 1 swift action
Range: Personal
Target: You
Duration: 1 round

All undead within range of your next turning attempt
(if you make it before this spell's duration expires)
are especially vulnerable to the attempt. Whether you
succeed in turning them or not, the undead take hit 
point damage equal to the result of your turning damage
roll. This damage is half fire and half sacred energy.

*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 6/21/2022
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"


void main()
{
	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_ABJURATION);
	object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDur =  RoundsToSeconds(1);
        int nMetaMagic = PRCGetMetaMagicFeat();
        if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;
        
        //Set a VFX
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MAJOR), oPC);
        
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAreaOfEffect(VFX_MOB_HOLYFIRE), oPC);
        
        PRCSetSchool();
}