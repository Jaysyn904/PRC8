/*
   ----------------
   Dimensional Swap

   psi_pow_dimswap
   ----------------

   8/4/05 by Stratovarius
*/ /** @file

    Dimensional Swap

    Psychoportation (Teleportation)
    Level: Nomad 2, psychic warrior 2
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Targets: You and one ally in range
    Duration: Instantaneous
    Saving Throw: None
    Power Resistance: No
    Power Points: 3
    Metapsionics: None

    You instantly swap positions between your current position and that of a
    designated ally in range. This power affects creatures of Large or smaller
    size. You can bring along objects, but not other creatures.

    Augment: For every 2 additional power points you spend, this power can
             affect a target one size category larger.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "spinc_trans"

void main()
{
/*
  Spellcast Hook Code
  Added 2004-11-02 by Stratovarius
  If you want to make changes to all powers,
  check psi_spellhook to find out more

*/

    if (!PsiPrePowerCastCode())
    {
    // If code within the PrePowerCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    object oManifester = OBJECT_SELF;
    object oTarget     = PRCGetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestation(oManifester, oTarget,
                              PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                       2, 4
                                                       ),
                              METAPSIONIC_NONE
                              );

    if(manif.bCanManifest)
    {
        int nMaxSize = CREATURE_SIZE_LARGE + manif.nTimesAugOptUsed_1;
        int nSize    = PRCGetCreatureSize(oTarget);

        if(nSize <= nMaxSize)
        {
            DoTransposition(FALSE, FALSE);
        }
    }
}
