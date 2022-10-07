/*
23/1/20 by Stratovarius

Spine Enhancement

Beginning at 2nd level, you can use your essentia to boost the power of your spines in combat. 
As a swift action, you can invest essentia in your spines as if they were a soulmeld. Doing so 
grants you an enhancement bonus equal to the points of essentia invested on attack rolls and 
damage rolls with your spines. Unlike your soulmelds or other incarnum-fueled abilities, your 
spines have a special essentia capacity (and thus a maximum enhancement bonus) equal to 
one-half your spinemeld warrior level. 
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nEssentia      = GetEssentiaInvested(oMeldshaper, MELD_SPINE_ENHANCEMENT);

    object oRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oMeldshaper);
    object oLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oMeldshaper);
    if (GetTag(oRight) == "skarn_spine") IPSafeAddItemProperty(oRight, ItemPropertyEnhancementBonus(nEssentia), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
    if (GetTag(oLeft) == "skarn_spine") IPSafeAddItemProperty(oLeft, ItemPropertyEnhancementBonus(nEssentia), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
}