//:://////////////////////////////////////////////
//:: Name     Major Resistance
//:: FileName   sp_majorresist.nss
//:://////////////////////////////////////////////
/** @file 
Abjuration
Level: Bard 2, Cleric 2, Druid 2, Paladin 2, Sorcerer 2, Wizard 2,
Components: V, S, M, DF,
Casting Time: 1 action
Range: Touch
Target: Creature touched
Duration: 1 hour/level
Saving Throw: Will negates (harmless)
Spell Resistance: Yes (harmless)

You imbue the subject with a strong magical energy that protects 
her from harm, granting a +3 resistance bonus on saves.

*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 7/14/22
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"


void main()
{
	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_ABJURATION);
	object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDur =  HoursToSeconds(nCasterLvl);
        int nMetaMagic = PRCGetMetaMagicFeat();
        if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;
        object oTarget = GetSpellTargetObject();
        
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_AURA_WHITE), oTarget, fDur);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSavingThrowIncrease(SAVING_THROW_ALL, 3), oTarget, fDur);
        
        PRCSetSchool();
}