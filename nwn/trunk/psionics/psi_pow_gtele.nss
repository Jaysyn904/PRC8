//::///////////////////////////////////////////////
//:: Teleport, Psionic Greater spellscript
//:: psi_pow_gtele
//:://////////////////////////////////////////////
/** @file
    Teleport, Psionic Greater

    Psychoportation (Teleportation)
    Level: Psion/wilder 8
    Display: Visual
    Manifesting Time: 1 standard action
    Range: Personal and touch
    Target or Targets: You and touched objects or other touched willing creatures
    Duration: Instantaneous
    Saving Throw: None or Will negates (object)
    Power Resistance: No or Yes (object)
    Power Points: 15
    Metapsionics: None

    This power instantly transports you to a designated destination. You may also bring one additional
    willing Medium or smaller creature or its equivalent per three manifester levels. A Large creature
    counts as two Medium creatures, a Huge creature counts as two Large creatures, and so forth. All
    creatures to be transported must be in contact with you. *

    Notes:
     * Implemented as within 10ft of you due to the lovely quality of NWN location tracking code.

*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 10.08.2005
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
        Teleport(oManifester, manif.nManifesterLevel, manif.nSpellID == POWER_GREATER_TELEPORT_PARTY, TRUE, "");
    }
}
