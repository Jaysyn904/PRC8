//::///////////////////////////////////////////////
//:: Power Attack - Set single value
//:: prc_powatk_chs
//:://////////////////////////////////////////////
/*
    Sets the value on the +0,+1,+2,+3,+4 radial
    and runs the power attack applying script.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 22.05.2005
//:://////////////////////////////////////////////
#include "prc_alterations"

const int START = 2171; // Spells.2da of 0

void main()
{
    object oPC = OBJECT_SELF;
    int nPower = GetLocalInt(oPC, "PRC_PowerAttack_Level");
    int nSID = PRCGetSpellId();
    
    // Extract the old fives value
    nPower = (nPower / 5) * 5;
    // Add in the new single value
    nPower += nSID - START;
    
    // Cache the new PA level
    SetLocalInt(oPC, "PRC_PowerAttack_Level", nPower);
    
    // Run the power attack applying script
    ExecuteScript("ft_poweratk", oPC);
}