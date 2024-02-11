//:://////////////////////////////////////////////
//:: Name     Lesser Visage of the Deity
//:: FileName   sp_lvisdiety.nss
//:://////////////////////////////////////////////
/** @file 
Transmutation [Good or Evil]
Level: Cleric 3, Blackguard 4, Paladin 4, Mysticism 3,
Components: V, S, DF,
Casting Time: 1 standard action
Range: Personal
Target: You
Duration: 1 round/level

As you end your prayer, you can feel the hand of your
deity upon you. Your appearance reflects her divine power,
and her touch grants you resistance from some of the damage
of this world.

You gain a +4 enhancement bonus to Charisma. You also gain 
resistance to acid 10, cold 10, and electricity 10 if you 
are good, or resistance to cold 10 and fire 10 if you are evil.
 
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 1/26/21
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"

void main()
{
	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
	object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        int nMetaMagic = PRCGetMetaMagicFeat();
        int nAlign = GetAlignmentGoodEvil(oPC);
        int nBonus = 4;
        float fDur = RoundsToSeconds(nCasterLvl);
        
        if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;
        
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityIncrease(ABILITY_CHARISMA, nBonus), oPC, fDur);
        
        if (nAlign == ALIGNMENT_GOOD)
        {
        	effect eResAcid = EffectDamageResistance(DAMAGE_TYPE_ACID, 10);
        	effect eResCold = EffectDamageResistance(DAMAGE_TYPE_COLD, 10);
        	effect eResElec = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 10);
        	effect eLink = EffectLinkEffects(eResAcid, eResCold);
        	eLink = EffectLinkEffects(eLink, eResElec);
        	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDur);
        	SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_GOOD_HELP), oPC);
        }
        
        else if (nAlign == ALIGNMENT_EVIL)
        {
        	effect eLink = EffectLinkEffects(EffectDamageResistance(DAMAGE_TYPE_COLD, 10), EffectDamageResistance(DAMAGE_TYPE_FIRE, 10));
        	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDur);
        	SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_EVIL_HELP), oPC);
        }        
	PRCSetSchool();
}