//::///////////////////////////////////////////////////
//:: X0_S1_PETRGAZE
//:: Petrification touch attack monster ability.
//:: Fortitude save (DC 15) or be turned to stone permanently.
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/14/2002
//::///////////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    object oTarget = PRCGetSpellTargetObject();
    int nHitDice = GetHitDice(oTarget);
	effect eImmune = EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE);
//:: Check for Immunity to Petrification 
	int bImmune = GetHasFeat(FEAT_IMMUNE_PETRIFICATION, oTarget);

	if (bImmune)
	{ 
		SendMessageToPC(OBJECT_SELF, "This creatrure is immune to petrification");
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eImmune, oTarget);
		return;
	}

    PRCDoPetrification(nHitDice, OBJECT_SELF, oTarget, GetSpellId(), 15);
}

