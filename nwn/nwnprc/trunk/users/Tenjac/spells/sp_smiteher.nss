//:://////////////////////////////////////////////
//:: Name     Smite Heretic
//:: FileName   sp_smiteher.nss
//:://////////////////////////////////////////////
/** @file Conjuration
Level: Paladin 3,
Components: V, S, DF,
Casting Time: 1 standard action
Range: Personal
Target: You
Duration: 10 minutes/level

For the duration of the spell, when using your smite 
evil class ability against an evil creature with the
ability to cast divine spells, you gain a +2 sacred 
bonus on the attack roll.

Furthermore, the attack deals 2 extra points of damage 
(instead of 1) per paladin level.
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 7/25/2022
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"


void main()
{
	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_CONJURATION);
	object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDur =  600 * nCasterLvl;
        int nMetaMagic = PRCGetMetaMagicFeat();
        if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;
        
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_AURA_PULSE_YELLOW_WHITE), oPC, fDur);
        
        PRCSetSchool();
}