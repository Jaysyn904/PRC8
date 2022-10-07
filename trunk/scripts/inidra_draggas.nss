//::///////////////////////////////////////////////
//:: Dragon Breath Gas Cloud
//:: NW_S1_DragGas
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
    int nDCBoost = 11; //mature adult form
    nDCBoost += 7; //adjustment for incorrect Con in shifted form.
    int nDamage = 7;
    struct breath WeakBreath;
    
    //create the breath - Huge dragon, so 50'
    WeakBreath = CreateBreath(OBJECT_SELF, FALSE, 50.0, -1, 10, nDamage, ABILITY_CONSTITUTION, nDCBoost, BREATH_WEAKENING);
    
    //Apply the breath
    PRCPlayDragonBattleCry();
    ApplyBreath(WeakBreath, GetSpellTargetLocation());
    
    //Apply the recharge lock
    SetLocalInt(OBJECT_SELF, DRAGBREATHLOCK, TRUE);

    // Schedule opening the delay lock
    float fDelay = RoundsToSeconds(WeakBreath.nRoundsUntilRecharge);
    SendMessageToPC(OBJECT_SELF, "Your breath weapon will be ready again in " + IntToString(WeakBreath.nRoundsUntilRecharge) + " rounds.");

    DelayCommand(fDelay, DeleteLocalInt(OBJECT_SELF, DRAGBREATHLOCK));
    DelayCommand(fDelay, SendMessageToPC(OBJECT_SELF, "Your breath weapon is ready now"));
}


