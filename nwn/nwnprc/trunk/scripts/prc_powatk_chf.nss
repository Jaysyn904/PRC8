//::///////////////////////////////////////////////
//:: Power Attack - Set fives value
//:: prc_powatk_chs
//:://////////////////////////////////////////////
/*
    Sets the value on the +0,+5,+10,+15,+20 radial
    and runs the power attack applying script.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 22.05.2005
//:://////////////////////////////////////////////

#include "prc_alterations"

const int START = 2177; // Spells.2da of 0

void main()
{
    object oPC = OBJECT_SELF;
    int nPower = GetLocalInt(oPC, "PRC_PowerAttack_Level");
    int nSID = PRCGetSpellId();
    
    // Extract the old single value
    nPower = nPower % 5;
    // Add in the new fives value
    nPower += (nSID - START) * 5;
    
    // Cache the new PA level
    SetLocalInt(oPC, "PRC_PowerAttack_Level", nPower);
    
    // Run the power attack applying script
    ExecuteScript("ft_poweratk", oPC);
}