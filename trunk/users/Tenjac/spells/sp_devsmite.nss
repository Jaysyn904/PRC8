
//:://////////////////////////////////////////////
//:: Name     Devastating Smite  
//:: FileName   sp_devsmite.nss
//:://////////////////////////////////////////////
/** @file Transmutation
Level: Blackguard 1, Cleric 1, Paladin 1,
Components: V, S, DF,
Casting Time: 1 swift action
Range: Touch
Target: Creature touched
Duration: 1 round or until discharged; see text
Saving Throw: Will negates (harmless)
Spell Resistance: Yes (harmless)

The next smite attack made by the subject deals double 
its normal smite damage. For instance, a 9th-level paladin
normally deals an extra 9 points of damage with her smite
evil ability. Under the effect of this spell, she would
deal an extra 18 points of damage. The spell applies to 
only one smite attack; if that attack misses, the spell
is lost without effect.

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
	PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
	object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDur =  RoundsToSeconds(1);
        int nMetaMagic = PRCGetMetaMagicFeat();
        if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;
        
        //Apply VFX, handle damage in smite script
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_AURA_PULSE_ORANGE_WHITE), oPC, fDur);
        
        PRCSetSchool();
}