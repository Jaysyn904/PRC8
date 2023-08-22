//Spell script for reserve feat dimensional reach
//prc_reservdimrch
//by ebonfowl
//Dedicated to Edgar, the real Ebonfowl

#include "spinc_dimdoor"

void main()
{
    object oPC   = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    object oItem;
    int nTargetType = GetObjectType(oTarget);
    int nBonus   = GetLocalInt(oPC, "DimensionalReachBonus");
    int nMaxWeight = nBonus*2;
    int nSpellID     = PRCGetSpellId();
    float fMaxDistance = FeetToMeters(IntToFloat(nBonus*5));
    float fDistance = GetDistanceBetween(oTarget, oPC);

    if (!GetLocalInt(oPC, "DimensionalReachBonus")) 
    {
        FloatingTextStringOnCreature("You do not have a spell available of adequate level or type", oPC, FALSE);
        return;
    }
    
    //Range check
    if(fDistance > fMaxDistance)
    {
        string sPretty = FloatToString(fMaxDistance);
        sPretty = GetSubString(sPretty, 0, FindSubString(sPretty, ".") + 2); // Trunctate decimals to the last two
        sPretty += "m"; // Note the unit. Since this is SI, the letter should be universal
        FloatingTextStringOnCreature("Dimensional Reach range limited to " + sPretty, oPC, FALSE);
        return;
    }

    //Object check
    if(nTargetType == OBJECT_TYPE_ITEM)
    {
        oItem = oTarget;
    }
    else
    {
        FloatingTextStrRefOnCreature(16826245, oPC, FALSE); // "* Target is not an item *"
        return;
    }

    if(!GetIsObjectValid(oItem))
        FloatingTextStrRefOnCreature(16826245, oPC, FALSE); // "* Target is not an item *"

    // And light enough
    if(GetWeight(oItem) <= nMaxWeight)
    {
        //ActionGiveItem(oTarget, oPC);
        CopyItem(oItem, oPC, FALSE);
        MyDestroyObject(oItem); // Make sure the item does get destroyed
    }
    else
        FloatingTextStrRefOnCreature(16824062, oPC, FALSE); // "This item is too heavy for you to pick up"
}