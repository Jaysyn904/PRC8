
#include "spinc_burst"
#include "prc_inc_spells"
#include "prc_add_spell_dc"
void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
    
	// Get the number of damage dice. 
	int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);
	  
    int nDice = nCasterLvl;
    if (nDice > 15) nDice = 15;
    
	// Acid storm is a huge burst doing 1d6 / lvl acid damage (15 cap)
	DoBurst (nCasterLvl,6, 0, nDice, 
		VFX_FNF_ACIDSTORM, VFX_IMP_ACID_S, 
		RADIUS_SIZE_HUGE, DAMAGE_TYPE_ACID, DAMAGE_TYPE_ACID, SAVING_THROW_TYPE_ACID,
		FALSE, SPELL_SCHOOL_EVOCATION, GetSpellId());

	// Add some extra sfx.		
	//PlaySound("sco_swar3blue");
}
