/*
   ----------------
   Shadow Jaunt

   tob_sdhd_sdhjnt.nss
   ----------------

   08/06/07 by Stratovarius
*/ /** @file

    Shadow Jaunt

    Shadow Hand [Teleportation]
    Level: Swordsage 2
    Initiation Action: 1 Standard Action
    Range: 50'
    Target: You

    A cloud of shadow energy engulfs you, spins into a tiny mote,
    and disappears. A moment later, this shadowy cloud appears 
    across the battlefield and expels you from it.
    
    You teleport up to 50'.
*/

#include "tob_inc_move"
#include "tob_movehook"
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
        location lTarget = PRCGetSpellTargetLocation();
        // Check if the caster can teleport and inform if they can't
        if(GetCanTeleport(oInitiator, lTarget, TRUE, TRUE))
        {
            // Assign jump command with delay to prevent the damn infinite action loop
            DelayCommand(1.0f, AssignCommand(oInitiator, JumpToLocation(lTarget)));
            DelayCommand(1.5, ShadowPounce(oInitiator));

            // Do some VFX
            DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), oInitiator, 0.55));
            DrawLineFromVectorToVector(DURATION_TYPE_INSTANT, VFX_IMP_WIND, GetArea(oInitiator), GetPosition(oInitiator), GetPositionFromLocation(lTarget), 0.0,
                                       FloatToInt(GetDistanceBetweenLocations(GetLocation(oInitiator), lTarget)), // One VFX every meter
                                       0.5
                                       );
        }
    }
}