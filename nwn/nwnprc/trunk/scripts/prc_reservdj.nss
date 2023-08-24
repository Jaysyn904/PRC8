//Spell script for reserve feat dimensional jaunt
//prc_reservdj
//by ebonfowl
//Dedicated to Edgar, the real Ebonfowl

#include "spinc_dimdoor"

void main()
{
    object oPC   = OBJECT_SELF;
    int nBonus   = GetLocalInt(oPC, "DimensionalJauntBonus");
    int nSpellID     = PRCGetSpellId();
    location lPC = GetLocation(oPC);
    location lTarget = GetIsObjectValid(PRCGetSpellTargetObject()) ? // Are we teleporting to some object, or just at a spot on the ground?
                       GetLocation(PRCGetSpellTargetObject()) :      // Teleporting to some object
                       PRCGetSpellTargetLocation();                  // Teleporting to a spot on the ground

    float fMaxDistance = FeetToMeters(IntToFloat(nBonus*5));
    float fDistance = GetDistanceBetweenLocations(lPC, lTarget);

    if (!GetLocalInt(oPC, "DimensionalJauntBonus")) 
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
        //                      "You can't teleport that far, distance limited to"
        FloatingTextStringOnCreature(GetStringByStrRef(16825210) + " " + sPretty, oPC, FALSE);
        return;
    }

    SetLocalInt(oPC, "DimensionalJaunt", TRUE);

    DimensionDoor(oPC, nBonus, nSpellID, "", DIMENSIONDOOR_SELF);
}