/*
   ----------------
   Cloak of Deception

   tob_sdhd_clkdcp.nss
   ----------------

    08/06/07 by Stratovarius
*/ /** @file

    Cloak of Deception

    Shadow Hand (Boost) 
    Level: Swordsage 2
    Initiation Action: 1 Swift Action
    Range: Personal.
    Target: You.
    Duration: 1 Round.

    The shadows around you seem to surge forward and
    engulf you. For a brief moment, they render you invisible.
    
    You gain greater invisibility for one round.
    This maneuver is a supernatural maneuver.
*/

#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"

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
	effect eImpact = EffectVisualEffect(VFX_IMP_HEAD_MIND);
	effect eVis = EffectVisualEffect(VFX_DUR_INVISIBILITY);
	effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_IMPROVED);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	effect eCover = EffectConcealment(50);
	effect eLink = EffectLinkEffects(eDur, eCover);
    	eLink = EffectLinkEffects(eLink, eVis);
	
    	SPApplyEffectToObject(DURATION_TYPE_INSTANT, ExtraordinaryEffect(eImpact), oTarget);
    	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eLink), oTarget, 6.0);
    	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eInvis), oTarget, 6.0);	
    }
}