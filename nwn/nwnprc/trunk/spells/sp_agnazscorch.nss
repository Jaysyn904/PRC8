#include "prc_inc_spells"
#include "spinc_bolt"
#include "prc_add_spell_dc"

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;

	// Get the number of damage dice.    
    int nCasterLevel = PRCGetCasterLevel(OBJECT_SELF);
    int nDice = (nCasterLevel + 1) / 2;
    if (nDice > 5) nDice = 5;
    
	DoBolt (nCasterLevel,8, 0, nDice, VFX_BEAM_FIRE_LASH, VFX_IMP_FLAME_S,
		DAMAGE_TYPE_FIRE, SAVING_THROW_TYPE_FIRE);
}
