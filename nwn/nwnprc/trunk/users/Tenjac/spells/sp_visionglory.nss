
//:://////////////////////////////////////////////
//:: Name     Vision of Glory
//:: FileName   sp_visionglory.nss
//:://////////////////////////////////////////////
/** @file Divination
Level: Cleric 1, Paladin 1,
Components: V, S, DF,
Casting Time: 1 standard action
Range: Touch
Target: Creature touched
Duration: 1 minute or until discharged
Saving Throw: None
Spell Resistance: Yes

You give the subject creature a brief vision of a divine
entity that is giving it support and inspiring it to 
continue. The creature gets a morale bonus equal to your 
Charisma modifier on a single saving throw. It must choose
to use the bonus before making the roll to which it applies.
Using the bonus discharges the spell.

*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 7/25/2022
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
        object oTarget = PRCGetSpellTargetObject();
        
        int nBonus = GetAbilityModifier(ABILITY_CHARISMA, oPC);
        SetLocalInt(oTarget, "PRCVisGlory", nBonus);
        DelayCommand(60.0f, DeleteLocalInt(oTarget, "PRCVisGlory"));
        
        PRCSetSchool();
}

