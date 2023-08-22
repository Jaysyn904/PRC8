/*
   ----------------
   Far Hand

   psi_pow_farhand
   ----------------

   6/12/04 by Stratovarius
*/ /** @file

    Far Hand

    Psychokinesis
    Level: Psion/wilder 1
    Manifesting Time: 1 standard action
    Range: Medium (100 ft. + 10 ft./ level)
    Target: An unattended object weighing up to 5 pounds
    Duration: Instantaneous
    Saving Throw: None
    Power Resistance: No
    Power Points: 1
    Metapsionics: None

    You can mentally lift and move an object from a distance to yourself.

    Augment: For every additional power point you spend, the weight limit of the
             target increases by 2 pounds.


    Implementation note - WARNING: The method used for moving the object
    involves creating a copy and destroying the original. This may break some
    modules.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_alterations"

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
    object oItem;
    struct manifestation manif =
        EvaluateManifestation(oManifester, oTarget,
                              PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                       1, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_NONE
                              );

    if(manif.bCanManifest)
    {
        int nMaxWeight = 50 + (20 * manif.nTimesAugOptUsed_1);
        int nTargetType = GetObjectType(oTarget);

        if(nTargetType == OBJECT_TYPE_PLACEABLE)
        {
            if(GetTag(oTarget) == "BodyBag")
                oItem = GetFirstItemInInventory(oTarget);
        }
        else if(nTargetType == OBJECT_TYPE_ITEM)
        {
            oItem = oTarget;
        }
        if(!GetIsObjectValid(oItem))
            FloatingTextStrRefOnCreature(16826245, oManifester, FALSE); // "* Target is not an item *"

        // And light enough
        if(GetWeight(oItem) <= nMaxWeight)
        {
            //ActionGiveItem(oTarget, oCaster);
            CopyItem(oItem, oManifester, FALSE);
            MyDestroyObject(oItem); // Make sure the item does get destroyed
        }
        else
            FloatingTextStrRefOnCreature(16824062, oManifester, FALSE); // "This item is too heavy for you to pick up"
    }
}
