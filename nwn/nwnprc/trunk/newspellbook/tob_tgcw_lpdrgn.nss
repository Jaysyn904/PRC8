/*
   ----------------
   Leaping Dragon Stance
   
   tob_tgcw_lpdrgn.nss
   ----------------

    27/04/07 by Stratovarius
*/ /** @file

    Leaping Dragon Stance

    Tiger Claw (Stance)
    Level: Swordsage 3, Warblade 3
    Initiation Action: 1 Swift Action
    Range: Personal.
    Target: You.
    Duration: Stance.

    Even when you are trapped in tight quarters and seemingly unable to move, a leap can send you flying gracefully through the air
    
    You gain a +10 bonus on jump checks, and always count as if you are running.
*/

#include "tob_inc_move"
#include "tob_movehook"
//#include "prc_alterations"

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
        effect eDur = EffectVisualEffect(VFX_DUR_BLOOD_FOUNTAIN);
        if (GetHasDefensiveStance(oInitiator, DISCIPLINE_TIGER_CLAW))
    		eDur = EffectLinkEffects(eDur, EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL));
        if (GetLevelByClass(CLASS_TYPE_BLOODCLAW_MASTER, oInitiator) >= 2)
        {
    		eDur = EffectLinkEffects(eDur, EffectMovementSpeedIncrease(33));
    		eDur = EffectLinkEffects(eDur, EffectACIncrease(1));
    	}    		
    	if (GetLocalInt(oInitiator, "TigerFangSharpClaw"))  eDur = EffectLinkEffects(eDur, EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_BASE_WEAPON));       	       
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(eDur), oTarget);
    }
}