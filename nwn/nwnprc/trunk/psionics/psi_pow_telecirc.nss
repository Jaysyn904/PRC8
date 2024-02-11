//:://////////////////////////////////////////////
//:: Power: Teleportation Circle, Psionic
//:: psi_pow_telecirc
//:://////////////////////////////////////////////
/** @file

    Teleportation Circle, Psionic

    Psychoportation (Teleportation)
    Level: Nomad 9
    Manifesting Time: 10 minutes
    Range: 0 ft.
    Effect: 5-ft.-radius circle that teleports those who activate it
    Duration: 10 min./level
    Saving Throw: None
    Power Resistance: Yes
    Power Points: 17
    Metapsionics: Extend

    You create a circle on the floor or other horizontal surface that teleports,
    as greater teleport, any creature who stands on it to a designated spot.
    Once you designate the destination for the circle, you cant change it. The
    power fails if you attempt to set the circle to teleport creatures into a
    solid object, to a place with which you are not familiar and have no clear
    description, or to another plane.

    The circle itself is subtle and nearly impossible to notice. If you intend
    to keep creatures from activating it accidentally, you need to mark the
    circle in some way.

    Note: Magic traps such as teleportation circle are hard to detect and
    disable. A rogue (only) can use the Search skill to find the circle and
    Disable Device to thwart it. The DC in each case is 25 + spell level, or 34
    in the case of teleportation circle.


    Implementation: At this time, the circle does not act as a trap, merely as
    a normal area of effect. This means that though it can be dispelled, it
    cannot be disarmed. Due to this, the option to have the circle be hidden is
    also disabled.

    @author Ornedan
    @date   Created - 2005.11.12
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "psi_inc_psifunc"
#include "psi_spellhook"
#include "spinc_telecircle"


void main()
{
    // Powerhook
    if(!PsiPrePowerCastCode()) return;

    /* Main script */
    object oManifester = OBJECT_SELF;
    struct manifestation manif =
        EvaluateManifestation(oManifester, OBJECT_INVALID,
                              PowerAugmentationProfile(),
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        int bVisible = manif.nSpellID == POWER_TELEPORTATIONCIRCLE_VISIBLE;

        TeleportationCircle(oManifester, manif.nManifesterLevel, bVisible, manif.bExtend);
    }// end if - Successfull manifestation
}
