//:://////////////////////////////////////////////
//:: Power: Dimension Slide
//:: psi_pow_dimslide
//:://////////////////////////////////////////////
/** @file

    Dimension Slide

    Psychoportation (Teleportation)
    Level: Psychic warrior 3
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Target: You; see text
    Duration: Instantaneous
    Power Points: 5
    Metapsionics: None

    You instantly transfer yourself from your current location to any other spot
    within range to which you have line of sight. Movement caused by the use of
    dimension slide does not provoke attacks of opportunity.

    If you somehow attempt to transfer yourself to a location occupied by a
    solid body or a location you can’t see the power simply fails to function.


    @author Ornedan
    @date   Created - 2005.10.28
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "psi_inc_psifunc"
#include "psi_spellhook"
#include "prc_inc_teleport"


void main()
{
    // Powerhook
    if(!PsiPrePowerCastCode()) return;

    object oManifester = OBJECT_SELF;
    struct manifestation manif =
        EvaluateManifestation(oManifester, OBJECT_INVALID,
                              PowerAugmentationProfile(),
                              METAPSIONIC_NONE
                              );

    if(manif.bCanManifest)
    {
        location lTarget = PRCGetSpellTargetLocation();
        // Check if the caster can teleport and inform if they can't
        if(GetCanTeleport(oManifester, lTarget, TRUE, TRUE))
        {
            // Assign jump command with delay to prevent the damn infinite action loop
            DelayCommand(1.0f, AssignCommand(oManifester, JumpToLocation(lTarget)));

            // Do some VFX
            DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), oManifester, 0.55));
            DrawLineFromVectorToVector(DURATION_TYPE_INSTANT, VFX_IMP_WIND, GetArea(oManifester), GetPosition(oManifester), GetPositionFromLocation(lTarget), 0.0,
                                       FloatToInt(GetDistanceBetweenLocations(GetLocation(oManifester), lTarget)), // One VFX every meter
                                       0.5
                                       );
        }
    }
}