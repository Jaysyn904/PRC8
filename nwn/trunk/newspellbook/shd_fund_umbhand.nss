/*
21/02/19 by Stratovarius

Umbral Hand

Fundamental 
Level/School: 1st/Transmutation 
Range: Close (25 ft. + 5 ft./ 2 levels) 
Target: One unattended object weighing up to 5 lb./level 

You point your finger at a distant object, and the shadows seem to grasp and tug at it.

This mystery functions like the power far hand.

Implementation note - WARNING: The method used for moving the object
involves creating a copy and destroying the original. This may break some
modules.
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"

void main()
{
    object oShadow      = OBJECT_SELF;
    // Get infinite uses at this level
    if (GetLevelByClass(CLASS_TYPE_SHADOWCASTER, oShadow) >= 14) IncrementRemainingFeatUses(oShadow, 23671);
    if(!ShadPreMystCastCode()) return;

    object oTarget      = PRCGetSpellTargetObject();
    struct mystery myst = EvaluateMystery(oShadow, oTarget, METASHADOW_NONE);

    if(myst.bCanMyst)
    {
        object oItem;
        int nMaxWeight = 50 * myst.nShadowcasterLevel;
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
            FloatingTextStrRefOnCreature(16826245, oShadow, FALSE); // "* Target is not an item *"

        // And light enough
        if(GetWeight(oItem) <= nMaxWeight)
        {
            //ActionGiveItem(oTarget, oCaster);
            CopyItem(oItem, oShadow, FALSE);
            MyDestroyObject(oItem); // Make sure the item does get destroyed
        }
        else
            FloatingTextStrRefOnCreature(16824062, oShadow, FALSE); // "This item is too heavy for you to pick up"              
    }
}