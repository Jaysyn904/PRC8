//::///////////////////////////////////////////////
//:: Power: Teleport
//:: psi_pow_teleport
//:://////////////////////////////////////////////
/** @file
    Teleport, Psionic

    Psychoportation (Teleportation)
    Level: Nomad 5
    Manifesting Time: 1 standard action
    Range: Personal and touch
    Target or Targets: You and touched objects or other touched willing creatures
    Duration: Instantaneous
    Saving Throw: None
    Power Resistance: No
    Power Points: 9
    Metapsionics: None

    This power instantly transports you to a designated destination, which may
    be as distant as 100 miles per manifester level. Interplanar travel is not
    possible. You may also bring one additional willing Medium or smaller
    creature or its equivalent (see below) per three caster levels. A Large
    creature counts as two Medium creatures, a Huge creature counts as two Large
    creatures, and so forth. All creatures to be transported must be in contact
    with one another, and at least one of those creatures must be in contact
    with you. *

    You must have some clear idea of the location and layout of the destination.
    The clearer your mental image, the more likely the teleportation works.
    Areas of strong physical or magical energy may make teleportation more
    hazardous or even impossible. **

    To see how well the teleportation works, roll d% and consult the Teleport
    table. Refer to the following information for definitions of the terms on
    the table.

    On Target:
      You appear where you want to be.
    Off Target:
      You appear safely a random distance away from the destination in a random
      direction.
    Far Off Target:
      You wind up somewhere completely different.
    Mishap:
      You and anyone else teleporting with you have gotten “scrambled.” You each
      take 1d10 points of damage, and you reroll on the chart to see where you
      wind up. For these rerolls, roll 1d20+80. Each time “Mishap” comes up, the
      characters take more damage and must reroll.

    On Target Off Target Way Off Target Mishap
    01–90     91–94      95–98          99–100


    Notes:
     *  Implemented as within 10ft of you due to the lovely quality of NWN location tracking code.
     ** Implemented as you having to have marked the location beforehand using the "Mark Location"
        feat, found under the Teleport Options radial.


    @author Ornedan
    @date   Created 2005.11.08
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "psi_inc_psifunc"
#include "psi_spellhook"
#include "spinc_teleport"

void main()
{
    // Powerhook
    if(!PsiPrePowerCastCode()) return;

    /* Main script */
    object oManifester = OBJECT_SELF;
    struct manifestation manif =
        EvaluateManifestation(oManifester, OBJECT_INVALID,
                              PowerAugmentationProfile(),
                              METAPSIONIC_NONE
                              );

    if(manif.bCanManifest)
    {
        Teleport(oManifester, manif.nManifesterLevel, manif.nSpellID == POWER_TELEPORT_PARTY, FALSE, "");
    }// end if - Successfull manifestation
}
