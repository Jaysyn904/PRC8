#include "inc_debug"
#include "prc_inc_spells"

void main()
{
	object oSummoned = OBJECT_SELF;

	// Get the caster of the potential dispel
	object oCaster = GetLastSpellCaster();
	int nCasterLevel = PRCGetCasterLevel(oCaster);
	
	if(DEBUG) DoDebug("mirror_image_sa: EVENT_NPC_ONSPELLCASTAT triggered.");

	// Get the spell ID
	int nSpellId = GetLastSpell();
	if(DEBUG) DoDebug("mirror_image_sa: Dispel spell ID: " + IntToString(nSpellId));

	// Check if the spell ID is a dispel spell
	if (nSpellId == SPELL_DISPEL_MAGIC || nSpellId == SPELL_LESSER_DISPEL || nSpellId == SPELL_GREATER_DISPELLING || nSpellId == SPELL_MORDENKAINENS_DISJUNCTION
		|| nSpellId == SPELL_SLASHING_DISPEL || nSpellId == SPELL_DISPELLING_TOUCH || nSpellId == SPELL_PIXIE_DISPEL || nSpellId == SPELL_GREAT_WALL_OF_DISPEL)
	{
		// Get the target of the spell
		object oTarget = OBJECT_SELF;
		if(DEBUG) DoDebug("mirror_image_sa: Spell targeted at: " + GetName(oTarget));

		// Check if the target is OBJECT_SELF
		if (oTarget == OBJECT_SELF)
		{
			// Retrieve the original caster of the Spiritual Weapon spell from oSummon
			object oSummon = OBJECT_SELF;
			object oOriginalCaster = GetLocalObject(oSummon, "oMaster");

			// Ensure oOriginalCaster is valid
			if (GetIsObjectValid(oOriginalCaster))
			{
				if(DEBUG) DoDebug("mirror_image_sa: Original caster found. Caster level: " + IntToString(PRCGetCasterLevel(oOriginalCaster)));

				// Determine the DC for the dispel check
				int nDispelDC = 11 + PRCGetCasterLevel(oOriginalCaster);
				if(DEBUG) DoDebug("mirror_image_sa: Dispel DC: " + IntToString(nDispelDC));

				// Determine the maximum cap for the dispel check
				int nDispelCap = 0;
				if (nSpellId == SPELL_LESSER_DISPEL)
					nDispelCap = 5;
				else if (nSpellId == SPELL_DISPEL_MAGIC || nSpellId == SPELL_SLASHING_DISPEL || nSpellId == SPELL_DISPELLING_TOUCH || nSpellId == SPELL_PIXIE_DISPEL || nSpellId == INVOKE_VORACIOUS_DISPELLING)
					nDispelCap = 10;
				else if (nSpellId == SPELL_GREATER_DISPELLING || nSpellId == SPELL_GREAT_WALL_OF_DISPEL)
					nDispelCap = 15;
				else if (nSpellId == SPELL_MORDENKAINENS_DISJUNCTION)
					nDispelCap = 0; // No cap for Disjunction

				// Roll for the dispel check
				int nDispelRoll = d20();
				int nCappedCasterLevel = nCasterLevel;

				if (nDispelCap > 0 && nCasterLevel > nDispelCap)
					nCappedCasterLevel = nDispelCap;

				nDispelRoll += nCappedCasterLevel;

				if(DEBUG) DoDebug("mirror_image_sa: Dispel roll: " + IntToString(nDispelRoll) + " (Caster Level: " + IntToString(nCappedCasterLevel) + ", Cap: " + IntToString(nDispelCap) + ")");

				// Compare the dispel result to the DC
				if (nDispelRoll >= nDispelDC)
				{
					if(DEBUG) DoDebug("mirror_image_sa: Dispel check succeeded.");

					// Dispel succeeded, destroy oSummon
					if(DEBUG) DoDebug("mirror_image_sa: Dispel Magic succeeded. Destroying Mirror Image.");

					// Set flags and destroy objects with delays
					SetPlotFlag(oSummon, FALSE);
					SetImmortal(oSummon, FALSE);

					ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_DISPEL), oSummon);

					DelayCommand(1.0f, DestroyObject(oSummon));
					
					if(DEBUG) DoDebug("mirror_image_sa: Mirror Image destruction scheduled.");
				}
				else
				{
					if(DEBUG) DoDebug("mirror_image_sa: Dispel check failed.");
				}
			}
			else
			{
				if(DEBUG) DoDebug("mirror_image_sa: Original caster not found.");
			}
		}
	}
	return;
}
