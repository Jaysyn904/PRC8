/////////////////////////////////////////////////////////////////////
//
// Blast of Flame - Cone of fire damage 1d6 / level, cap 10.
//
/////////////////////////////////////////////////////////////////////

#include "prc_inc_spells"
#include "spinc_cone"

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
    
	DoCone (6, 0, 10, -1, VFX_IMP_FLAME_S, 
		DAMAGE_TYPE_FIRE, SAVING_THROW_TYPE_FIRE);
}
