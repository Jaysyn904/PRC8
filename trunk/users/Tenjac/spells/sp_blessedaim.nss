//:://////////////////////////////////////////////
//:: Name     Blessed Aim
//:: FileName   sp_blessedaim.nss
//:://////////////////////////////////////////////
/** @file Divination
Level: Blackguard 1, Cleric 1, Paladin 1,
Components: V, S,
Casting Time: 1 standard action
Range: 50 ft.
Effect: 50-ft.-radius spread centered on you
Duration: 1 minute/level
Saving Throw: Will negates (harmless)
Spell Resistance: No

With the blessing of your deity, you bolster your
allies' aim with an exhortation.

This spell grants your allies within the spread
a +2 morale bonus on ranged attack rolls. 
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"


void main()
{
	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_DIVINATION);
	object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDur = 60 * nCasterLvl;
        int nMetaMagic = PRCGetMetaMagicFeat();
        if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;
        effect eAOE = EffectAreaOfEffect(AOE_PER_BLESSEDAIM);
        
        SPApplyEffectToObejct(DURATION_TYPE_TEMPORARY, eAOE, oPC, fDur);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PULSE_HOLY), oPC);
	
	PRCSetSchool();
}