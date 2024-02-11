//:://////////////////////////////////////////////
//:: Name     Clear Mind
//:: FileName   sp_clearmind.nss
//:://////////////////////////////////////////////
/** @file
Clear Mind
Abjuration
Level: Paladin 1
Components: V, S, DF,
Casting Time: 1 standard action
Range: Personal
Target: You
Duration: 10 minutes/level

A silver glow sheathes your body as you complete the spell. As the glow fades, you feel a touch
of the divine at the back of your mind. This divine touch spreads until you feel your concerns 
and anxieties fade away.

You gain a +4 sacred bonus on saving throws made against mind-affecting spells and effects.
 
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 1/23/21
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"


void main()
{
	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_ABJURATION);
	object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDur = 600 * nCasterLvl;
        effect eVis = EffectVisualEffect(VFX_DUR_AURA_BLUE_LIGHT);
        effect eBuff = EffectSavingThrowIncrease(SAVING_THROW_ALL, 4, SAVING_THROW_TYPE_MIND_SPELLS);
        
        SPApplyEffectToObject(oPC, DURATION_TYPE_TEMPORARY, eVis, 3.0f);
        SPApplyEffectToObject(oPC, DURATION_TYPE_TEMPORARY, eBuff, fDur);
	
	PRCSetSchool();
}