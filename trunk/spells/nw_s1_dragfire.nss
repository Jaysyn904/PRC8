//::///////////////////////////////////////////////
//:: Dragon Breath Fire
//:: NW_S1_DragFire
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Calculates the proper damage and DC Save for the
    breath weapon based on the HD of the dragon.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 9, 2001
//:://////////////////////////////////////////////

const string DRAGBREATHLOCK = "DragonBreathLock";


//modified to use the breath include - Fox
#include "prc_inc_spells"
#include "prc_inc_breath"

void main()
{
    // Check the dragon breath delay lock
    if(GetLocalInt(OBJECT_SELF, DRAGBREATHLOCK))
    {
        SendMessageToPC(OBJECT_SELF, "You cannot use your breath weapon again so soon");
        return;
    }
	
    //Declare major variables
    int nAge = GetHitDice(OBJECT_SELF);
    int nDCBoost = nAge / 2;
    int nDamageDice;
    struct breath FireBreath;
    
    //Use the HD of the creature to determine damage and save DC
    if (nAge <= 6) //Wyrmling
    {
        nDamageDice = 2;
    }
    else if (nAge >= 7 && nAge <= 9) //Very Young
    {
        nDamageDice = 4;
    }
    else if (nAge >= 10 && nAge <= 12) //Young
    {
        nDamageDice = 6;
    }
    else if (nAge >= 13 && nAge <= 15) //Juvenile
    {
        nDamageDice = 8;
    }
    else if (nAge >= 16 && nAge <= 18) //Young Adult
    {
        nDamageDice = 10;
    }
    else if (nAge >= 19 && nAge <= 21) //Adult
    {
        nDamageDice = 12;
    }
    else if (nAge >= 22 && nAge <= 24) //Mature Adult
    {
        nDamageDice = 14;
    }
    else if (nAge >= 25 && nAge <= 27) //Old
    {
        nDamageDice = 16;
    }
    else if (nAge >= 28 && nAge <= 30) //Very Old
    {
        nDamageDice = 18;
    }
    else if (nAge >= 31 && nAge <= 33) //Ancient
    {
        nDamageDice = 20;
    }
    else if (nAge >= 34 && nAge <= 37) //Wyrm
    {
        nDamageDice = 22;
    }
    else if (nAge > 37) //Great Wyrm
    {
        nDamageDice = 24;
    }
    
    //create the breath - 40' ~ 14m? - should set it based on size later
    FireBreath = CreateBreath(OBJECT_SELF, FALSE, 40.0, DAMAGE_TYPE_FIRE, 10, nDamageDice, ABILITY_CONSTITUTION, nDCBoost);
    
    //Apply the breath
    PRCPlayDragonBattleCry();
    ApplyBreath(FireBreath, PRCGetSpellTargetLocation());
    
    //Apply the recharge lock
    SetLocalInt(OBJECT_SELF, DRAGBREATHLOCK, TRUE);

    // Schedule opening the delay lock
    float fDelay = RoundsToSeconds(FireBreath.nRoundsUntilRecharge);
    SendMessageToPC(OBJECT_SELF, "Your breath weapon will be ready again in " + IntToString(FireBreath.nRoundsUntilRecharge) + " rounds.");

    DelayCommand(fDelay, DeleteLocalInt(OBJECT_SELF, DRAGBREATHLOCK));
    DelayCommand(fDelay, SendMessageToPC(OBJECT_SELF, "Your breath weapon is ready now"));
}


