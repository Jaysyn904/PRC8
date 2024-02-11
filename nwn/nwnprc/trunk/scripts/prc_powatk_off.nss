//::///////////////////////////////////////////////
//:: Power Attack - Off
//:: prc_powatk_off
//:://////////////////////////////////////////////
/*
    Turns Power Attack off.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 22.05.2005
//:://////////////////////////////////////////////

void main()
{
    object oPC = OBJECT_SELF;
    SetLocalInt(oPC, "PRC_PowerAttack_Level", 0);
    
    // Run the power attack applying script
    ExecuteScript("ft_poweratk", oPC);
}