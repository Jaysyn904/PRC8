/*
   ----------------
   Wall of Blades

   tob_irnh_wllblds.nss
   ----------------

    06/06/07 by Stratovarius
*/ /** @file

    Wall of Blades

    Iron Heart (Counter)
    Level: Warblade 2
    Initiation Action: 1 Swift Action
    Range: Personal.
    Target: You.
    Duration: 1 Round

    Your weapon sways back and forth in your hand, ready to block incoming blows.
    With the speed of a thunderbolt, you clash your weapon against your foe's
    blade as he attempts to attack.
    
    You make an attack roll against yourself. If it is higher than your armour class, the result
    of the roll becomes your armour class until the end of the round.
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
	int nAC = GetDefenderAC(oInitiator, oTarget);
	int nAttack = GetAttackRoll(oTarget, oInitiator, GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator));
	// Add bonus if greater
	if (nAttack > nAC)
	{
		int nBonus = nAttack - nAC;
		effect eAC = EffectLinkEffects(EffectACIncrease(nBonus), EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
		eAC = EffectLinkEffects(eAC, EffectBonusFeat(FEAT_UNCANNY_REFLEX));
		
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eAC), oTarget, 6.0);
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_AC_BONUS), oTarget);
	}
    }
}