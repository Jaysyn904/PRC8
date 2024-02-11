//:://////////////////////////////////////////////
//:: Name     Strength of Stone
//:: FileName   sp_strstone.nss
//:://////////////////////////////////////////////
/** @file
Transmutation
Level: Paladin 2,
Components: V, S, DF,
Casting Time: 1 swift action
Range: Personal
Target: You
Duration: 1 round

You call upon the fortitude of the powers of good,
and your flesh turns an ivory-gray hue as you draw 
power up through the earth itself.

The spell grants you a +8 enhancement bonus to Strength.
The spell ends instantly if you lose contact with the 
ground. This means you cannot jump, tumble, charge, run, 
or move more than your speed in a round (because these acts
cause both of your feet to leave the ground) without breaking
the spell. A natural stone wall or ceiling counts as the ground
for the purpose of this spell (so you could climb a cavern wall
and not lose the spell).
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
        
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityIncrease(ABILITY_STRENGTH, 8) oPC, fDur); 
        
        PRCSetSchool();
}