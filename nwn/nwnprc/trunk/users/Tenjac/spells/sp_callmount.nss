//:://////////////////////////////////////////////
//:: Name     Call Mount
//:: FileName   sp_callmount.nss
//:://////////////////////////////////////////////
/** @file Conjuration (Calling) [Good]
Level: Paladin 2,
Components: V,
Casting Time: 1 round
Range: 10 ft.
Effect: Your special mount
Duration: 1 hour/level (D)
Saving Throw: None
Spell Resistance: No

You summon your special mount from the celestial 
planes where it resides.

This works exactly as your normal, spell-like class a
bility to summon the creature, except that the duration
is shorter and you are not limited in how many times 
you can call the mount in a day (except by how many
times you can cast call mount).

You can cast this spell even if you have already 
called your mount using your class ability on the same day.
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 8/9/22
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
        
        HorseSummonPaladinMount();
        
        PRCSetSchool();
}