/*
   ----------------
   Psychic Reformation

   psi_pow_psyref
   ----------------

   25/3/05 by Stratovarius
*/ /** @file

    Psychic Reformation

    Telepathy [Mind-Affecting]
    Level: Psion/wilder 4
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Target: One creature
    Duration: Instantaneous
    Saving Throw: None
    Power Resistance: No
    Power Points: 7, XP; see text
    Metapsionics: None

    When this power is manifested, the subject can choose to make again all the
    decisions related to the latest level it has gained.

    The subject can undo decisions of these sorts that were made at lower
    levels, if both the subject and the manifester agree to pay the necessary XP
    before this power is manifested (see below).

    XP Cost: This power costs 50 XP to manifest to reformat choices made when
    the character reached her current level. For each additional previous level
    into which the revision reaches, the power costs an additional 50 XP. The
    manifester and subject split all XP costs evenly.

    Augmentation: For every additional power point you spend, the revision
                  reaches one level further. The XP cost is accordingly
                  increased, as specified above.


    Implementation Note: This power may optionally be nerfed via a switch,
                         changing it's behaviour to only allow reselection of
                         psionic powers gained in the reformed levels.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_alterations"

/// Determines how long to wait before restoring the target's XP value
const float XP_RESTORE_DELAY = 1.0f;

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
                                                       1, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        int nLevels   = 1 + manif.nTimesAugOptUsed_1;
        int nOrigXP   = GetXP(oTarget);
        int nOrigHD   = GetHitDice(oTarget);
        int nTargetHD = max(1, nOrigHD - nLevels);
        int nXPCost   = nLevels *
                         (GetPRCSwitch(PRC_PSI_PSYCHIC_REFORMATION_NERF) == 2 ?
                           25 : // If nerf is set, the XP cost may also be reduced to 25 per level
                           50   // Default is 50 per level
                          );

        // Targeting restrictions. Reforming your opponent mid-battle would be quite nasty, so you only get to do it to allies :P
        if(oTarget == oManifester ||
           GetIsFriend(oTarget)
           )
        {
            // Check whether a behaviour changing switch has been set
            if(!GetPRCSwitch(PRC_PSI_PSYCHIC_REFORMATION_NERF))
            {
                // Level the target down
                SetXP(oTarget, ((nTargetHD * (nTargetHD - 1)) / 2) * 1000);

                // Schedule the OnLevelDown virtual event to be run right away
                SetLocalInt(oTarget, "PRC_OnLevelDown_OldLevel", nOrigHD);
                DelayCommand(0.0f, ExecuteScript("prc_onleveldown", oTarget));
            }// end if - Default behaviour
            else
            {
                // Nerfed - Only remove powers known tied to the reformed levels
                int i = nOrigHD;
                for(; i > nTargetHD; i--)
                    RemovePowersKnownOnLevel(oTarget, i);
            }// end else - Only reform powers

            // Level reduction is immediate, so restore XP right away to avoid mess with HB detecting level loss
            if(oManifester == oTarget)
            {
                // Targeted self, pay full cost
                SetXP(oTarget, nOrigXP - nXPCost);
            }
            else
            {
                // Targeted other, manifester pays half
                SetXP(oManifester, GetXP(oManifester) - (nXPCost / 2));
                // Target pays other half
                SetXP(oTarget, nOrigXP - (nXPCost / 2));
            }
        }// end if - Targeting restrictions
    }// end if - Successfull manifestation
}
