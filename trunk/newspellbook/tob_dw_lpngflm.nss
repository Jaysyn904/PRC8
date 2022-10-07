/*
   ----------------
   Leaping Flame

   tob_dw_lpngflm.nss
   ----------------

    31/08/07 by Stratovarius
*/ /** @file

    Leaping Flame

    Desert Wind (Counter) [Teleport]
    Level: Swordsage 5
    Prerequisite: Two Desert Wind Maneuvers
    Initiation Action: 1 Swift Action
    Range: Personal.
    Target: You
    Duration: Instantaneous

    As your foe attacks you, you disappear in a burst of flame and smoke, 
    only to reappear as if out of thin air next to him.
    
    You teleport up to a 100ft to the person who last attacked you.
    This is a supernatural maneuver.
*/

#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"
#include "prc_inc_teleport"

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
        location lTarget = GetLocation(oTarget);
        // Check if the caster can teleport and inform if they can't
        // There's also a range component here
        if(GetCanTeleport(oInitiator, lTarget, TRUE, TRUE) && FeetToMeters(100.0) >= GetDistanceBetween(oInitiator, oTarget))
        {
            // Assign jump command with delay to prevent the damn infinite action loop
            DelayCommand(1.0f, AssignCommand(oInitiator, JumpToLocation(lTarget)));

            // Do some VFX
            DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), oInitiator, 0.55));
            DrawLineFromVectorToVector(DURATION_TYPE_INSTANT, VFX_IMP_WIND, GetArea(oInitiator), GetPosition(oInitiator), GetPositionFromLocation(lTarget), 0.0,
                                       FloatToInt(GetDistanceBetweenLocations(GetLocation(oInitiator), lTarget)), // One VFX every meter
                                       0.5
                                       );
        }
    }
}