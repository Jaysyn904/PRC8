//::///////////////////////////////////////////////
//:: Dragon Breath Negative Energy
//:: NW_S1_DragNeg
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
    int nLevelDrain; //drain was commented out, kept just in case
    struct breath NegBreath;
    
    //Determine save DC and ability damage
    if (nAge <= 6) //Wyrmling
    {
    	nLevelDrain = 1;
        nDamageDice = 2;
    }
    else if (nAge >= 7 && nAge <= 9) //Very Young
    {
    	nLevelDrain = 1;
        nDamageDice = 4;
    }
    else if (nAge >= 10 && nAge <= 12) //Young
    {
    	nLevelDrain = 1;
        nDamageDice = 6;
    }
    else if (nAge >= 13 && nAge <= 15) //Juvenile
    {
    	nLevelDrain = 2;
        nDamageDice = 8;
    }
    else if (nAge >= 16 && nAge <= 18) //Young Adult
    {
    	nLevelDrain = 2;
        nDamageDice = 10;
    }
    else if (nAge >= 19 && nAge <= 21) //Adult
    {
    	nLevelDrain = 3;
        nDamageDice = 12;
    }
    else if (nAge >= 22 && nAge <= 24) //Mature Adult
    {
    	nLevelDrain = 4;
        nDamageDice = 14;
    }
    else if (nAge >= 25 && nAge <= 27) //Old
    {
    	nLevelDrain = 5;
        nDamageDice = 16;
    }
    else if (nAge >= 28 && nAge <= 30) //Very Old
    {
    	nLevelDrain = 5;
        nDamageDice = 18;
    }
    else if (nAge >= 31 && nAge <= 33) //Ancient
    {
    	nLevelDrain = 6;
        nDamageDice = 20;
    }
    else if (nAge >= 34 && nAge <= 37) //Wyrm
    {
    	nLevelDrain = 7;
        nDamageDice = 22;
    }
    else if (nAge > 37) //Great Wyrm
    {
    	nLevelDrain = 8;
        nDamageDice = 24;
    }
    
    //create the breath - 40' ~ 14m? - should set it based on size later
    NegBreath = CreateBreath(OBJECT_SELF, FALSE, 40.0, DAMAGE_TYPE_NEGATIVE, 8, nDamageDice, ABILITY_CONSTITUTION, nDCBoost);
    
    //Apply the breath - note: Level drain was included but commented out in the original, thus not currently implemented in the include.
    //Information on the level drain amount is kept just in case.
    PRCPlayDragonBattleCry();
    ApplyBreath(NegBreath, PRCGetSpellTargetLocation());
    
    //Apply the recharge lock
    SetLocalInt(OBJECT_SELF, DRAGBREATHLOCK, TRUE);

    // Schedule opening the delay lock
    float fDelay = RoundsToSeconds(NegBreath.nRoundsUntilRecharge);
    SendMessageToPC(OBJECT_SELF, "Your breath weapon will be ready again in " + IntToString(NegBreath.nRoundsUntilRecharge) + " rounds.");

    DelayCommand(fDelay, DeleteLocalInt(OBJECT_SELF, DRAGBREATHLOCK));
    DelayCommand(fDelay, SendMessageToPC(OBJECT_SELF, "Your breath weapon is ready now"));
}