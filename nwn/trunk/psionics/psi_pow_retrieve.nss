/*
   ----------------
   Retrieve

   psi_pow_retrieve
   ----------------

   27/3/05 by Stratovarius
*/ /** @file

    Retrieve

    Psychoportation (Teleportation)
    Level: Psion/wilder 6
    Manifesting Time: 1 standard action
    Range: Medium (100 ft. + 10 ft./ level)
    Target: One object you can hold or carry in one hand, weighing up to 10 lb./level
    Duration: Instantaneous
    Saving Throw: Will negates; see text
    Power Resistance: No
    Power Points: 11
    Metapsionics: None

    You automatically teleport an item you can see within range directly to your
    hand. If the object is in the possession of an opponent, it comes to your
    hand if your opponent fails a Will save. *

    Augment: For every additional power point you spend, the weight limit of the
             target increases by 10 pounds.


    Implementation notes:
    WARNING: The method used for moving the object involves creating a copy and
             destroying the original. This may break some modules.
    * The power will only take a weapon from the main hand if targeted at a
      creature, and only if that creature is set to be disarmable.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_inc_spells"
#include "prc_inc_teleport"

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
                              METAPSIONIC_NONE
                              );

    if(manif.bCanManifest)
    {
        int nDC        = GetManifesterDC(oManifester);
        int nMaxWeight = 100 * (manif.nManifesterLevel + manif.nTimesAugOptUsed_1); // Weight is tenths of a pound

        // Make sure the target can be teleported
        if(GetCanTeleport(oTarget, GetLocation(oTarget), TRUE))
        {
            // If target is an item
            if(GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
            {
                // And light enough
                if(GetWeight(oTarget) <= nMaxWeight)
                {
                    // Copy it
                    CopyItem(oTarget, oManifester, FALSE);
                    MyDestroyObject(oTarget); // Make sure the item does get destroyed
                }
                else
                    FloatingTextStrRefOnCreature(16824062, oManifester, FALSE); // "This item is too heavy for you to pick up"
            }// end if - Target is an item
            else if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
            {
                // Check disarmability
                if(GetIsCreatureDisarmable(oTarget) && !GetPRCSwitch(PRC_PNP_DISARM))
                {
                    // Let the AI know
                    PRCSignalSpellEvent(oTarget, TRUE, manif.nSpellID, oManifester);

                    // Save - Will negates
                    if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_NONE))
                    {
                        // Target the creature's mainhand weapon
                        oTarget = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);

                        // Check that there was anything in the slot
                        if(GetIsObjectValid(oTarget))
                        {
                            // Make sure it's light enough
                            if(GetWeight(oTarget) <= nMaxWeight)
                            {
                                // Copy it and destroy the original
                                CopyItem(oTarget, oManifester, FALSE);
                                MyDestroyObject(oTarget); // Make sure the item does get destroyed
                            }
                            else
                                FloatingTextStrRefOnCreature(16824062, oManifester, FALSE); // "This item is too heavy for you to pick up"
                        }// end if - There is a weapon to yoink
                    }// end if - Save
                }// end if - Target is disarmable
            }// end else - Target is a creature
        }// end if - Teleportability check
    }// end if - Successfull manifestation
}
