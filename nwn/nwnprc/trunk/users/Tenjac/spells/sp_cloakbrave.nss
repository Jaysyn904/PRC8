//:://////////////////////////////////////////////
//:: Name     Cloak of Bravery
//:: FileName   sp_cloakbrave.nss
//:://////////////////////////////////////////////
/** @file
Abjuration [Mind-Affecting]
Level: Paladin 2, Cleric 3, Courage 3,
Components: V, S,
Casting Time: 1 standard action
Range: 60 ft.
Area: 60-ft.-radius emanation centered on you
Duration: 10 minutes/level
Saving Throw: Will negates (harmless)
Spell Resistance: Yes (harmless)

Summoning up your courage, you throw out your arm and sweep 
it over the area, cloaking all your allies in a glittering
mantle of magic that bolsters their bravery.

All allies within the emanation (including you) gain a morale
bonus on saves against fear effects equal to your caster level
(to a maximum of +10 at caster level 10th).
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 1/28/21
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"


void main()
{
	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_ABJURATION);
	object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDur =  HoursToSeconds(nCasterLvl)/6;
        int nMetaMagic = PRCGetMetaMagicFeat();
        if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;
        
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAreaOfEffect(VFX_MOB_CLOAK_OF_BRAVERY), oPC, fDur);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_LIGHT_WHITE_20), oPC, fDur);
        
        PRCSetSchool();
}