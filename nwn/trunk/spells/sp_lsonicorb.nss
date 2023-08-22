#include "prc_inc_spells"
#include "spinc_lessorb"

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
    
	DoLesserOrb(EffectVisualEffect(VFX_IMP_SONIC), DAMAGE_TYPE_SONIC);
}
