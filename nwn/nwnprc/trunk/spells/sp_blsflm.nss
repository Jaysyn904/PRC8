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

	object oCaster = OBJECT_SELF;
	int EleDmg = ChangedElementalDamage(oCaster, DAMAGE_TYPE_FIRE);
	int nSaveType = ChangedSaveType(EleDmg);
    
	DoCone (6, 0, 10, -1, VFX_IMP_FLAME_S,   
		EleDmg, nSaveType, SPELL_SCHOOL_EVOCATION, -1, TRUE);
}
