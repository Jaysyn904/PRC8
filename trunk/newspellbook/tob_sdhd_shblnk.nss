//////////////////////////////////////////////////
// Shadow Blink
// tob_sdhd_shblnk.nss
// Tenjac   12/12/07
//////////////////////////////////////////////////
/** @file Shadow Hand [Teleportation]
Level: Swordsage 7
Initiation Action: 1 swift action
Range: 50 ft.
Target: You

In the blink of an eye, you disappear and emerge from a mote of shadow energy across the battlefield.
This maneuver functions as the shadow jaunt maneuver, except that it can be initiated as a swift action.
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
                    FloatToInt(GetDistanceBetweenLocations(GetLocation(oInitiator), lTarget)), 0.5);
            }
    }
}