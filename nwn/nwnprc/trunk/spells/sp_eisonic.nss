#include "prc_inc_spells"
#include "spinc_engimm"

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
    
	DoEnergyImmunity (DAMAGE_TYPE_SONIC, VFX_IMP_SONIC);
}
