#include "prc_inc_spells"
#include "prc_add_spell_dc"
#include "spinc_orb"

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
    
	effect eVis = EffectVisualEffect(VFX_IMP_ACID_S );
	effect eVisFail = EffectVisualEffect(VFX_IMP_STUN);
	effect eFailSave = EffectStunned();

	DoOrb(eVis, EffectLinkEffects(eVisFail, eFailSave), 
		SAVING_THROW_TYPE_ACID, DAMAGE_TYPE_ACID);
}
