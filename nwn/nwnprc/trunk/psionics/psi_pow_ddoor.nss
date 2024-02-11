/*
   ----------------
   Dimension Door, Psionic

   psi_pow_ddoor
   ----------------

   19/2/04 by Stratovarius
   05.07.2005 by Ornedan
*/
/** @file

    Dimension Door, Psionic

    Psychoportation (Teleportation)
    Level: Psion/wilder 4, psychic warrior 4
    Manifesting Time: 1 standard action
    Range: Long (400 ft. + 40 ft./level)
    Target or Targets: You and touched objects or other touched willing creatures
    Duration: Instantaneous
    Saving Throw: None
    Power Resistance: No
    Power Points: 7
    Metapsionics: None

    You instantly transfer yourself from your current location to any other spot within range.
    You always arrive at exactly the spot desired—whether by simply visualizing the area or by
    stating direction**. You may also bring one additional willing Medium or smaller creature
    or its equivalent per three manifester levels. A Large creature counts as two Medium
    creatures, a Huge creature counts as two Large creatures, and so forth. All creatures to be
    transported must be in contact with you. *

    Notes:
    * Implemented as within 10ft of you due to the lovely quality of NWN location tracking code.
    ** The direction is the same as the direction of where you target the spell relative to you.
       A listener will be created so you can say the distance.
*/

#include "psi_inc_psifunc"
#include "psi_spellhook"
#include "spinc_dimdoor";


void main()
{
    // Powerhook
    if(!PsiPrePowerCastCode()) return;

    /* Main spellscript */
    object oManifester = OBJECT_SELF;
    struct manifestation manif =
        EvaluateManifestation(oManifester, OBJECT_INVALID,
                              PowerAugmentationProfile(),
                              METAPSIONIC_NONE
                              );

    if(manif.bCanManifest)
    {
        int bSelfOrParty   = ((manif.nSpellID == POWER_DIMENSIONDOOR_PARTY) || (manif.nSpellID == POWER_DIMENSIONDOOR_PARTY_DIRDIST)) ?
                              DIMENSIONDOOR_PARTY :
                              DIMENSIONDOOR_SELF;
        int bUseDirDist    = (manif.nSpellID == POWER_DIMENSIONDOOR_SELFONLY_DIRDIST) ||
                             (manif.nSpellID == POWER_DIMENSIONDOOR_PARTY_DIRDIST);

        DimensionDoor(oManifester, manif.nManifesterLevel, manif.nSpellID, "", bSelfOrParty, bUseDirDist);
    }
}