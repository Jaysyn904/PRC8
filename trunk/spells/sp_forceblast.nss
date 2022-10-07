#include "prc_inc_spells"
#include "spinc_bolt"

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
    
	// Get the number of damage dice.    
    int nCasterLevel = PRCGetCasterLevel(OBJECT_SELF);
    int nDice = nCasterLevel > 10 ? 10 : nCasterLevel;
    
	DoBolt (nCasterLevel,4, 0, nDice, VFX_BEAM_MIND, VFX_IMP_MAGBLUE, 
		DAMAGE_TYPE_MAGICAL, SAVING_THROW_TYPE_SPELL, 
		SPELL_SCHOOL_EVOCATION, TRUE, GetSpellId());
}

