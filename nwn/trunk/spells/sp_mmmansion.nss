#include "prc_inc_spells"

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
    
	PRCSetSchool(SPELL_SCHOOL_CONJURATION);
	
	// Get the spell target location as opposed to the spell target.
	location lTarget = PRCGetSpellTargetLocation();

	// Note that you cannot cast a mansion inside a mansion so check the area's
	// tag to make sure the caster isn't trying to recurse mansions.
	object aCaster = GetArea(OBJECT_SELF);
	if ("MordenkainensMagnificentMansion" != GetTag(GetArea(aCaster)))
	{
		// Fire cast spell at event for the specified target
		PRCSignalSpellEvent(aCaster, FALSE);

		// Apply the ice explosion at the location captured above.
		ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3), lTarget);

		// Create the mansion doorway and save the caster on the door so we know who to let in.
		// Only people in the caster's party get to go into the mansion.		
		object oMansion = CreateObject(OBJECT_TYPE_PLACEABLE, "mordsmansent", lTarget, TRUE,
			"MordsMansEnt");
		if (GetIsObjectValid(oMansion))
		{
			SetLocalObject(oMansion, "MMM_CASTER", OBJECT_SELF);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, 
				EffectVisualEffect(VFX_DUR_GLOW_WHITE), oMansion);
		}
	}
		
	PRCSetSchool();
}
