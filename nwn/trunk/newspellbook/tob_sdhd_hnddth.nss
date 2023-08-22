/*
   ----------------
   Hand of Death

   tob_sdhd_hnddth.nss
   ----------------

   08/06/07 by Stratovarius
*/ /** @file

    Hand of Death

    Shadow Hand (Strike)
    Level: Swordsage 4
    Initiation Action: 1 Standard Action
    Range: Touch
    Target: One Creatures
    Duration: 1d3 rounds
    Saving Throw: Fort negates

    You reach out and tap your foe with a single finger. Her look of puzzlement
    turns to fear as black energy spreads across her body, rendering her helpless.
    
    Make a melee touch attack. If it succeeds, the target must save or be paralyzed.
*/

#include "tob_inc_move"
#include "tob_movehook"
#include "prc_inc_sp_tch"

void main()
{
    if (!PreManeuverCastCode())
    {
    // If code within the PreManeuverCastCode (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    object oInitiator    = OBJECT_SELF;
    object oTarget       = PRCGetSpellTargetObject();
    struct maneuver move = EvaluateManeuver(oInitiator, oTarget);

    if(move.bCanManeuver)
    {
        int nTouchAttack = PRCDoMeleeTouchAttack(oTarget);
        if(nTouchAttack > 0)
        {
		
    		// Saving Throw
    		if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (14 + GetAbilityModifier(ABILITY_WISDOM, oInitiator))))
    		{
    			effect eParal = EffectParalyze();
			effect eVis = EffectVisualEffect(82);
			effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
			effect eDur2 = EffectVisualEffect(VFX_DUR_PARALYZED);
			effect eDur3 = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);
			
			effect eLink = EffectLinkEffects(eDur2, eDur);
			eLink = EffectLinkEffects(eLink, eParal);
			eLink = EffectLinkEffects(eLink, eVis);
			eLink = EffectLinkEffects(eLink, eDur3);
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(d3()));
		}
        }
    }
}