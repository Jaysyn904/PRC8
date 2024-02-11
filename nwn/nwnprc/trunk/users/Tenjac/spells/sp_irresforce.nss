//:://////////////////////////////////////////////
//:: Name     Irresistable Force
//:: FileName   sp_irresforce.nss
//:://////////////////////////////////////////////
/** @file Evocation
Level: Paladin 4,
Components: V, S,
Casting Time: 1 action
Range: Personal
Target: You
Duration: 1 round/level

Charging yourself with divine energy, you become the epitome of force in motion.
You are protected by freedom of movement.
You gain a +10 bonus on bull rush attempts.
You gain a +10 bonus on checks made to avoid being tripped.
When moving in combat, you act as if you had the Mobility feat.
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
	PRCSetSchool(SPELL_SCHOOL_EVOCATION);
	object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDur =  RoundsToSeconds(nCasterLvl);
        int nMetaMagic = PRCGetMetaMagicFeat();
        if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;
        
        //Freedom of Movement
        effect eLink = EffectLinkEffects(EffectImmunity(IMMUNITY_TYPE_PARALYSIS), EffectImmunity(IMMUNITY_TYPE_SLOW));
        eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_ENTANGLE));
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDur);
        
        //Mobility
        IPSafeAddItemProperty(GetPCSkin(oPC), PRCItemPropertyBonusFeat(FEAT_MOBILITY), fDur);
        PRCSetSchool();
}