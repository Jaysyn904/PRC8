#include "prc_inc_spells"
#include "spinc_orb"

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
    
	effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
	effect eVisFail = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
	effect eFailSave = EffectBlindness();

	DoOrb(eVis, EffectLinkEffects(eVisFail, eFailSave), 
		SAVING_THROW_TYPE_COLD, DAMAGE_TYPE_COLD);
}

