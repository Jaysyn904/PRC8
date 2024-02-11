//:://////////////////////////////////////////////
//:: Name     Righteous Aura
//:: FileName sp_rightaura.nss  
//:://////////////////////////////////////////////
/** @file Abjuration [Good, Light]
Level: Paladin 4,
Components: V, S, DF,
Casting Time: 1 standard action
Range: Personal
Target: You
Duration: 1 hour/level

You invoke the powers of good and law, and in response
to your pleas, you glow with the golden radiance of the sun.

You are bathed in an unearthly glow for the duration of the
spell, as if a daylight spell (PH 216) had been cast on you.
You get a +4 sacred bonus to Charisma.

If you die, your body is converted into an explosive blast 
of energy in a 20-foot-radius burst centered where you fell,
dealing 2d6 points of damage per caster level (maximum 20d6)
to all evil creatures in the burst's area. Good creatures in
the area are healed by the same amount, and undead take 
double this damage. Spell resistance cannot prevent this 
damage, but a successful Reflex save reduces it to half. 
Your body is disintegrated, so you cannot be raised with a
raise dead spell. Spells that do not require an intact body,
such as true resurrection, can be used to bring you back to 
life as normal.

*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 7/20/22
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"

void main()
{
	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_CONJURATION);
	object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDur = HoursToSeconds(nCasterLvl);
        int nMetaMagic = PRCGetMetaMagicFeat();
        if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;
        
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityIncrease(ABILITY_CHARISMA, 4), fDur, oPC);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAreaOfEffect(VFX_MOB_DAYLIGHT), fDur, oPC);
        
        AddEventScript(oPC, EVENT_ONPLAYERDEATH, "prc_rightaura", FALSE, TRUE);
        AddEventScript(oPC, EVENT_NPC_ONDEATH, "prc_rightaura", FALSE, TRUE);
        
        PRCSetSchool();
}