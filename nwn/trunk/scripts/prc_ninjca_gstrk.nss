//::///////////////////////////////////////////////
//:: Ninja Ghost Strike
//:: ninjca_gstrk
//::
//:://////////////////////////////////////////////
/*
	Ignores Etherealness (maybe)
*/

#include "prc_inc_clsfunc"
#include "prc_inc_combat"

void main()
{
     //Declare major variables
     object oPC = OBJECT_SELF;
     object oTarget = PRCGetSpellTargetObject();
     
	if (!Ninja_AbilitiesEnabled(OBJECT_SELF))
	{
		IncrementRemainingFeatUses(OBJECT_SELF, FEAT_GHOST_STRIKE);
		SendMessageToPC(OBJECT_SELF, "Your ki powers will not function while encumbered or wearing armor");
		return;
	}
	else
		Ninja_DecrementKi(oPC, FEAT_GHOST_STRIKE);
	
     effect eCon = EffectVisualEffect(VFX_COM_SPARKS_PARRY);
     
     // script now uses combat system to hit and apply effect if appropriate
     string sSuccess = "*Ghost Strike Hit*";
     string sMiss    = "*Ghost Strike Miss*";
     
     // Flag to my changes in prc_inc_combat that we should not cancel ethereal
     SetLocalInt(oPC, "prc_ghost_strike", 1);
     
     PerformAttackRound(oTarget, oPC, eCon, 0.0, 0, 0, 0, FALSE, sSuccess, sMiss);
     DeleteLocalInt(oPC, "prc_ghost_strike");
}
