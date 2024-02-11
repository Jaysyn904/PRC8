//:://////////////////////////////////////////////
//:: Name     Rhino's Rush
//:: FileName   sp_rhinorush.nss
//:://////////////////////////////////////////////
/** @file Transmutation
Level: Paladin 1, Ranger 1, Wrath (SpC) 1,
Components: V, S,
Casting Time: 1 swift action
Range: Personal
Target: You
Duration: 1 round

This spell allows you to propel yourself in a single deadly
charge. The first charge attack you make before the end of 
the round deals double damage on a successful hit.
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 7/21/22
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
        
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_IOUNSTONE_RED), oPC, fDur);
        
        PRCSetSchool();
}