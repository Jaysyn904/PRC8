/*
   ----------------
   Fiery Assault
   
   tob_dw_fryaslt.nss
   ----------------

    29/10/07 by Stratovarius
*/ /** @file

    Fiery Assault

    Desert Wind (Stance) [Fire]
    Level: Swordsage 6
    Prerequisite: Two Desert Wind maneuvers
    Initiation Action: 1 Swift Action
    Range: Personal
    Target: You
    Duration: Stance
    
    Fire dances along your arms and across your weapon, lending burning energy to every attack you make.
    
    Your attacks do an extra 1d6 fire damage.
    This is a supernatural maneuver.
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
	effect eDam  = EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_FIRE);
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eDam, oTarget);
    }
}