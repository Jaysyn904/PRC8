/*
04/03/21 by Stratovarius

Anima Mage Exploit Vestige Cast Spell

Cast a spell from an exploited vestige
*/

#include "bnd_inc_bndfunc"

void ClearExploitVestigeCastBypass(object oBinder, int nGeneration)
{
	if (GetLocalInt(oBinder, "ExploitVestigeBardSorcBypass") != nGeneration)
		return;

	DeleteLocalInt(oBinder, "ExploitVestigeBardSorcBypass");
	DeleteLocalInt(oBinder, "EldritchSpellBlast");
}

void PrepareExploitVestigeCastBypass(object oBinder, int nGeneration)
{
	// This is an isolated free cast. Discard any abandoned advanced-spellbook
	// state from an earlier action before the spell hook sees it.
	DeleteLocalInt(oBinder, "NSB_Class");
	DeleteLocalInt(oBinder, "NSB_SpellLevel");
	DeleteLocalInt(oBinder, "NSB_SpellbookID");

	SetLocalInt(oBinder, "ExploitVestigeBardSorcBypass", nGeneration);
	SetLocalInt(oBinder, "EldritchSpellBlast", TRUE);
	// This timer is created when the setup action executes, so a spell that
	// clears the remaining action queue cannot strand the compatibility flag.
	// Eligible Bard/Sorcerer spells can take up to 16 seconds before their
	// script hook runs, so leave ample room before the abandoned-cast fallback.
	DelayCommand(30.0f, ClearExploitVestigeCastBypass(oBinder, nGeneration));
}

void main()
{
	object oBinder = OBJECT_SELF;
	if (GetLocalInt(oBinder, "ExploitVestige"))
	{
		int nArcaneClass = GetPrimaryArcaneClass(oBinder);
		// BardSorcPrCCheck already has a narrowly scoped bypass for special
		// cheat-casts. Reuse it here so this additional Exploit Vestige spell
		// keeps its normal spell behavior without spending an /sb slot.
		if (nArcaneClass == CLASS_TYPE_BARD
		 || nArcaneClass == CLASS_TYPE_SORCERER)
		{
			int nGeneration = GetLocalInt(
				oBinder,
				"ExploitVestigeBardSorcGeneration"
			) + 1;
			if (nGeneration <= 0)
				nGeneration = 1;
			SetLocalInt(
				oBinder,
				"ExploitVestigeBardSorcGeneration",
				nGeneration
			);
			ActionDoCommand(PrepareExploitVestigeCastBypass(
				oBinder,
				nGeneration
			));
		}

		ActionCastSpell(GetLocalInt(oBinder, "ExploitVestigeSpell"), 0, 0, 0, METAMAGIC_NONE, nArcaneClass, 0, 0, OBJECT_INVALID, FALSE);

		// Keep both action-ordered cleanup and an independent fallback. Spells
		// such as Greater Teleport can clear their action queue after the hook.
		if (nArcaneClass == CLASS_TYPE_BARD
		 || nArcaneClass == CLASS_TYPE_SORCERER)
			ActionDoCommand(ClearExploitVestigeCastBypass(
				oBinder,
				GetLocalInt(oBinder, "ExploitVestigeBardSorcGeneration")
			));
	}
	else
	{
		IncrementRemainingFeatUses(oBinder, 9259);
		FloatingTextStringOnCreature("You are not exploiting a vestige!", oBinder, FALSE);
	}
}
