#include "prc_inc_spells"
#include "spinc_orb"


void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
    
	effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
	effect eVisFail = EffectVisualEffect(VFX_IMP_DAZED_S);
	effect eFailSave = EffectDazed();

	DoOrb(eVis, EffectLinkEffects(eVisFail, eFailSave), SAVING_THROW_TYPE_FIRE, DAMAGE_TYPE_FIRE);
}
