//:://////////////////////////////////////////////
//:: Name     Seek Eternal Rest
//:: FileName   sp_seeketrest.nss
//:://////////////////////////////////////////////
/** @file
Conjuration (Healing)
Level: Paladin 3,
Components: V, DF,
Casting Time: 1 standard action
Range: Personal
Target: You
Duration: 1 hour/level

You invoke the greater powers and are infused with 
a great, golden glow, empowering you with holy glory.

You improve your ability to turn undead. For the
purpose of turning or destroying undead, you are
treated as a cleric of your paladin level.
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
	PRCSetSchool(SPELL_SCHOOL_CONJURATION);
	object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDur =  HoursToSeconds(nCasterLvl);
        int nMetaMagic = PRCGetMetaMagicFeat();
        if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;
        
        //Apply VFX, need to alter the turning script
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_AURA_YELLOW_LIGHT), oPC, fDur);
        
        PRCSetSchool();
}