//::///////////////////////////////////////////////
//:: Dragon Breath Sleep
//:: NW_S1_DragSleep
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Calculates the proper DC Save for the
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
    int nCount = d6();
    struct breath SleepBreath;
    
    //Determine save DC and duration of effect
    if (nAge <= 6) //Wyrmling
    {
        nCount += 1;
    }
    else if (nAge >= 7 && nAge <= 9) //Very Young
    {
        nCount += 2;
    }
    else if (nAge >= 10 && nAge <= 12) //Young
    {
        nCount += 3;
    }
    else if (nAge >= 13 && nAge <= 15) //Juvenile
    {
        nCount += 4;
    }
    else if (nAge >= 16 && nAge <= 18) //Young Adult
    {
        nCount += 5;
    }
    else if (nAge >= 19 && nAge <= 21) //Adult
    {
        nCount += 6;
    }
    else if (nAge >= 22 && nAge <= 24) //Mature Adult
    {
        nCount += 7;
    }
    else if (nAge >= 25 && nAge <= 27) //Old
    {
        nCount += 8;
    }
    else if (nAge >= 28 && nAge <= 30) //Very Old
    {
        nCount += 9;
    }
    else if (nAge >= 31 && nAge <= 33) //Ancient
    {
        nCount += 10;
    }
    else if (nAge >= 34 && nAge <= 37) //Wyrm
    {
        nCount += 11;
    }
    else if (nAge > 37) //Great Wyrm
    {
        nCount += 12;
    }
    
    //create the breath - 40' ~ 14m? - should set it based on size later
    SleepBreath = CreateBreath(OBJECT_SELF, FALSE, 40.0, -1, 10, nCount, ABILITY_CONSTITUTION, nDCBoost, BREATH_SLEEP);
    
    //Apply the breath
    PRCPlayDragonBattleCry();
    ApplyBreath(SleepBreath, PRCGetSpellTargetLocation());
    
    //Apply the recharge lock
    SetLocalInt(OBJECT_SELF, DRAGBREATHLOCK, TRUE);

    // Schedule opening the delay lock
    float fDelay = RoundsToSeconds(SleepBreath.nRoundsUntilRecharge);
    SendMessageToPC(OBJECT_SELF, "Your breath weapon will be ready again in " + IntToString(SleepBreath.nRoundsUntilRecharge) + " rounds.");

    DelayCommand(fDelay, DeleteLocalInt(OBJECT_SELF, DRAGBREATHLOCK));
    DelayCommand(fDelay, SendMessageToPC(OBJECT_SELF, "Your breath weapon is ready now"));
}


