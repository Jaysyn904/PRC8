//:://////////////////////////////////////////////
//:: Name     Lesser Aspect of the Diety
//:: FileName   sp_laspdiety.nss
//:://////////////////////////////////////////////
/** @file 
Transmutation [Good]
Level: Apostle of Peace 4, Exalted Arcanist 4, Paladin 4, Knight of the Chalice 4,
Components: V, S, DF,
Casting Time: 1 standard action
Range: Personal
Target: You
Duration: 1 round/level

When you cast this spell, your body changes into a form that is more like 
your deity (in a very limited fashion, of course).

You gain a +4 enhancement bonus to your Charisma score.

You also gain acid, cold, and electricity resistance 10.
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 6/7/2022
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"


void main()
{
	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
	object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDur =  RoundsToSeconds(nCasterLvl);
        int nMetaMagic = PRCGetMetaMagicFeat();
        if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;
        
        effect eLink = EffectAbilityIncrease(ABILITY_CHARISMA, 4);
        eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_ACID, 10));
        eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_COLD, 10));
        eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 10));
        eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_IOUNSTONE_YELLOW));
        
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDur);
        
        PRCSetSchool();
}