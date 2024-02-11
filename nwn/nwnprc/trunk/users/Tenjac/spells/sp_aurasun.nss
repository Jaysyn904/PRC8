//:://////////////////////////////////////////////
//:: Name     Aura of the Sun
//:: FileName   sp_aurasun.nss
//:://////////////////////////////////////////////
/** @file Aura of the Sun
Abjuration [Light]
Level: Cleric 4, Paladin 4,
Components: V, S, DF,
Casting Time: 1 standard action
Range: 10 ft.
Area: 10-ft.-radius emanation centered on you
Duration: 1 round/level (D)
Saving Throw: No
Spell Resistance: None

By casting aura of the sun, you fill the area around you with warm, glowing light that eliminates natural 
shadows and hampers magical darkness.Any creature attempting to cast a spell from the shadow subschool or 
a spell with the darkness descriptor within an aura of the sun must succeed on a caster level check (DC 11 +
your caster level), or the spell fails. Areas of magical darkness originating from 3rd-level or lower spells 
and effects are temporarily suppressed when overlapping with an aura of the sun. Creatures that take penalties 
in bright light also take them while within an aura of the sun, and an undead creature takes 1d6 points of positive
energy damage at the end of its turn every round that it spends within the spell's area.Furthermore, any creature 
attempting to hide within the aura takes a -4 penalty on Hide checks.
This effect is centered on you and moves with you.
Anyone who enters the aura immediately becomes subject to its effect, but creatures that leave are no longer affected.
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
	PRCSetSchool(SPELL_SCHOOL_ABJURATION);
	object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDur =  RoundsToSeconds(nCasterLvl);
        int nMetaMagic = PRCGetMetaMagicFeat();
        if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;
        
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAreaOfEffect(AOE_MOB_AURASUN), fDur, oPC);
        
        PRCSetSchool();
}