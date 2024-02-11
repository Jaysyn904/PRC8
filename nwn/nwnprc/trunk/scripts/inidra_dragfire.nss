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
    int nDCBoost = 11; //mature adult form
    int nDamageDice = 14;
    struct breath FireBreath;

    //shifted Con is 10, should be 19 for Gold and 21 for Red.  Comment this section out if/when this is fixed.
    if (GetAppearanceType(OBJECT_SELF)==APPEARANCE_TYPE_DRAGON_GOLD)
    {
        nDCBoost += 7; //adjustment for incorrect Con in shifted form.
    }
    else if (GetAppearanceType(OBJECT_SELF)==APPEARANCE_TYPE_DRAGON_RED)
    {
        nDCBoost += 8; //adjustment for incorrect Con in shifted form.
    }
   
    //create the breath - Huge dragon, so 50'
    FireBreath = CreateBreath(OBJECT_SELF, FALSE, 50.0, DAMAGE_TYPE_FIRE, 10, nDamageDice, ABILITY_CONSTITUTION, nDCBoost);
    
    //Apply the breath
    PRCPlayDragonBattleCry();
    ApplyBreath(FireBreath, GetSpellTargetLocation());
    
    //Apply the recharge lock
    SetLocalInt(OBJECT_SELF, DRAGBREATHLOCK, TRUE);

    // Schedule opening the delay lock
    float fDelay = RoundsToSeconds(FireBreath.nRoundsUntilRecharge);
    SendMessageToPC(OBJECT_SELF, "Your breath weapon will be ready again in " + IntToString(FireBreath.nRoundsUntilRecharge) + " rounds.");

    DelayCommand(fDelay, DeleteLocalInt(OBJECT_SELF, DRAGBREATHLOCK));
    DelayCommand(fDelay, SendMessageToPC(OBJECT_SELF, "Your breath weapon is ready now"));
}


