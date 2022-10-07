//::///////////////////////////////////////////////
//:: Dragon Breath Weaken
//:: NW_S1_DragWeak
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
    int nDamage = 0;
    struct breath WeakBreath;
    
    //Determine save DC and ability damage
    if (nAge <= 6) //Wyrmling
    {
        nDamage += 1;
    }
    else if (nAge >= 7 && nAge <= 9) //Very Young
    {
        nDamage += 2;
    }
    else if (nAge >= 10 && nAge <= 12) //Young
    {
        nDamage += 3;
    }
    else if (nAge >= 13 && nAge <= 15) //Juvenile
    {
        nDamage += 4;
    }
    else if (nAge >= 16 && nAge <= 18) //Young Adult
    {
        nDamage += 5;
    }
    else if (nAge >= 19 && nAge <= 21) //Adult
    {
        nDamage += 6;
    }
    else if (nAge >= 22 && nAge <= 24) //Mature Adult
    {
        nDamage += 7;
    }
    else if (nAge >= 25 && nAge <= 27) //Old
    {
        nDamage += 8;
    }
    else if (nAge >= 28 && nAge <= 30) //Very Old
    {
        nDamage += 9;
    }
    else if (nAge >= 31 && nAge <= 33) //Ancient
    {
        nDamage += 10;
    }
    else if (nAge >= 34 && nAge <= 37) //Wyrm
    {
        nDamage += 11;
    }
    else if (nAge > 37) //Great Wyrm
    {
        nDamage += 12;
    }
    
    //create the breath - 40' ~ 14m? - should set it based on size later
    WeakBreath = CreateBreath(OBJECT_SELF, FALSE, 40.0, -1, 10, nDamage, ABILITY_CONSTITUTION, nDCBoost, BREATH_WEAKENING);
    
    //Apply the breath
    PRCPlayDragonBattleCry();
    ApplyBreath(WeakBreath, PRCGetSpellTargetLocation());
    
    //Apply the recharge lock
    SetLocalInt(OBJECT_SELF, DRAGBREATHLOCK, TRUE);

    // Schedule opening the delay lock
    float fDelay = RoundsToSeconds(WeakBreath.nRoundsUntilRecharge);
    SendMessageToPC(OBJECT_SELF, "Your breath weapon will be ready again in " + IntToString(WeakBreath.nRoundsUntilRecharge) + " rounds.");

    DelayCommand(fDelay, DeleteLocalInt(OBJECT_SELF, DRAGBREATHLOCK));
    DelayCommand(fDelay, SendMessageToPC(OBJECT_SELF, "Your breath weapon is ready now"));
}


