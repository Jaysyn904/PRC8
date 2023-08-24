//::///////////////////////////////////////////////
//:: Name      Utterdark
//:: FileName  sp_utterdark.nss
//:://////////////////////////////////////////////
/**@file Utterdark
Conjuration (Creation) [Evil] 
Level: Darkness 8, Demonic 8, Sor/Wiz 9
Components: V, S, M/DF 
Casting Time: 1 hour 
Range: Close (25 ft. + 5 ft./2 levels) 
Area: 100-ft./level radius spread, centered on caster
Duration: 1 hour/level 
Saving Throw: None 
Spell Resistance: No

Utterdark spreads from the caster, creating an area
of cold, cloying magical darkness. This darkness is
similar to that created by the deeper darkness spell,
but no magical light counters or dispels it. 
Furthermore, evil aligned creatures can see in this 
darkness as if it were simply a dimly lighted area.

Arcane Material Component: A black stick, 6 inches 
long, with humanoid blood smeared upon it.

Author:    Tenjac
Created:   5/21/06

*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
#include "prc_inc_spells"
#include "prc_misc_const"

void main()
{
	
	PRCSetSchool(SPELL_SCHOOL_CONJURATION);
	
	if (!X2PreSpellCastCode()) return;
		
	//Declare major variables including Area of Effect Object
	effect eAOE = EffectAreaOfEffect(AOE_PER_UTTERDARK);
	object oPC = OBJECT_SELF;
	int nMetaMagic = PRCGetMetaMagicFeat();
	int nCasterLvl = PRCGetCasterLevel(oPC);
	float fDuration = (nCasterLvl * 600.0f);
	location lLoc = GetLocation(oPC);
	
	
	//Check Extend metamagic feat.
	if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
	{
		fDuration = fDuration *2;    //Duration is +100%
	}
	
	//Create an instance of the AOE Object using the Apply Effect function
	
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lLoc, fDuration);
		
	//SPEvilShift(oPC);
	
	PRCSetSchool();
}