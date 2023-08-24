/*
   ----------------
   Mirrored Pursuit

   tob_stsn_mrrprs
   ----------------

   05/12/07 by Stratovarius
*/ /** @file

    Mirrored Pursuit

    Setting Sun (Counter)
    Level: Swordsage 5
    Prerequisite: Two Setting Sun maneuvers
    Initiation Action: 1 immediate action
    Range: 30 feet
    Target: One creature

    Your movements perfectly match your foe's, allowing you to move as she does.
    Try as she might to escape, you remain at her side.
    
    You immediately move to any spot adjacent to your enemy, provided it is within range.
*/

#include "tob_inc_move"
#include "tob_movehook"
//#include "prc_alterations"
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
        if(FeetToMeters(30.0) >= GetDistanceBetween(oInitiator, oTarget))
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