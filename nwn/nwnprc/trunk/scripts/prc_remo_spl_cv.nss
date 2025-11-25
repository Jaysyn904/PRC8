 //:://///////////////////////////////////////////////////////////////
//:: End Self-Cast Active Spells - DynConv
//:: prc_remo_spl_fx.nss
//::
//:: Created by: Jaysyn
//:: Created on: 2025-11-22 15:45:50
 //:://///////////////////////////////////////////////////////////////
/*
	- Lists all active spell effects on and cast by the PC.
	- Allows the player to end any of them (removes all effects
	- from that spell cast by the PC).

	- Start with:
	- StartDynamicConversation("prc_remo_spl_cv", OBJECT_SELF);
 */
 //:://///////////////////////////////////////////////////////////////
#include "prc_effect_inc"
#include "inc_dynconv"

const int STAGE_ENTRY = 0;

// Get a localized spell name from spells.2da; fallback to "Spell #"
string PRCGetSpellName(int nSpell)
{
	string sName = "";
	string sRef = Get2DAString("spells", "Name", nSpell);
	if (sRef != "")
	{
		int nStrRef = StringToInt(sRef);
		if (nStrRef > 0)
		{
			sName = GetStringByStrRef(nStrRef);
		}
	}
	if (sName == "")
	{
		sName = "Spell #" + IntToString(nSpell);
	}
	return sName;
}

// Build list of unique self-cast active spells on oPC, one choice per spell id.
// Returns count of unique spells found.
int BuildSpellChoiceList(object oPC)
{
	int nCount = 0;

	array_create(oPC, "PC_SPELL_LIST");
	
	effect e = GetFirstEffect(oPC);
	
	while (GetIsEffectValid(e))
	{
		int nSpell = GetEffectSpellId(e);
		if (nSpell >= 0 && GetEffectCreator(e) == oPC)
		{
			if (array_get_int(oPC, "PC_SPELL_LIST", nSpell) == 0)
			{
				AddChoice(PRCGetSpellName(nSpell), nSpell, oPC);
				array_set_int(oPC, "PC_SPELL_LIST", nSpell, 1);
				nCount++;
			}
		}
	
		e = GetNextEffect(oPC);	
	}
	array_delete(oPC, "PC_SPELL_LIST");
	return nCount;
}
	
void main()
{
	object oPC = GetPCSpeaker();

	int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
	int nStage = GetStage(oPC);

	if (nValue == 0)
	return;

	if (nValue == DYNCONV_SETUP_STAGE)
	{
		if (!GetIsStageSetUp(nStage, oPC))
		{
			if (nStage == STAGE_ENTRY)
			{
				int nList = BuildSpellChoiceList(oPC);

				if (nList > 0)
				{
					SetHeader("Which of your active spells would you like to end:");
				}
				else
				{
					SetHeader("You have no self-cast active spells available to end.");
				}

				MarkStageSetUp(nStage, oPC);
				SetDefaultTokens();
			}
		}

		SetupTokens(oPC);
	}
	
	else if (nValue == DYNCONV_EXITED)
	{
	// no-op
	}
	else if (nValue == DYNCONV_ABORTED)
	{
	// no-op
	}
	else
	{
		// Player selected a spell id
		int nSpellId = GetChoice(oPC);

		if (nStage == STAGE_ENTRY)
		{
			// End the spell
			PRCRemoveSpellEffects(nSpellId, oPC, oPC);

			// Rebuild list
			ClearCurrentStage(oPC);
		}

		SetStage(nStage, oPC);
	}
}