#include "prc_inc_spells"
#include "spinc_greenfire"

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;

	PRCSetSchool(SPELL_SCHOOL_ABJURATION);

	// Get target location.
	location lTarget = PRCGetSpellTargetLocation();

	// Save the spell ID as a local int on ourselves so we don't have to hard code
	// it for the AOE.
	SetGreenfireSpellID(GetSpellId());
			
	// Get spell duration, taking metamagic into account (default is 1 round).
	float fDuration = PRCGetMetaMagicDuration(RoundsToSeconds(1));

	// Create the AOE for the spell and apply it to the target location.
	effect eAOE = EffectAreaOfEffect(AOE_PER_FOGACID, "sp_greenfire_en", 
		"sp_greenfire_hb", "sp_greenfire_ex");
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, fDuration);
	
	PRCSetSchool();
}
