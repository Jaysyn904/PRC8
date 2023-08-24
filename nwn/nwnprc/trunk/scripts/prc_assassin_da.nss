//::///////////////////////////////////////////////
//:: Name        Assassin Death Attack
//:: FileName    prc_assassin_da
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Shane Hennessy
//:: Created On:
//:://////////////////////////////////////////////
// Death Attack for the assassin

#include "prc_alterations"
#include "NW_I0_GENERIC"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();

    // Gotta be a living critter
    int nType = MyPRCGetRacialType(oTarget);
    if ((nType == RACIAL_TYPE_CONSTRUCT) ||
        (nType == RACIAL_TYPE_UNDEAD) ||
        (nType == RACIAL_TYPE_ELEMENTAL))
    {
        FloatingTextStringOnCreature("Target must be alive", oPC);
        return;
    }
    // Assasain must not be seen
/*    if (!( (GetStealthMode(oPC) == STEALTH_MODE_ACTIVATED)  ||
           (PRCGetHasEffect(EFFECT_TYPE_INVISIBILITY,oPC)) ||
           (PRCGetHasEffect(EFFECT_TYPE_SANCTUARY,oPC)) ) )
    {
        FloatingTextStringOnCreature("Your target is aware of you, you can not perform a death attack",OBJECT_SELF);
        return;
    }*/
    // If they are in the middle of a DA or have to wait till times up they are denied
    float fApplyDATime = GetLocalFloat(oPC,"PRC_ASSN_DEATHATTACK_APPLY");
    if (fApplyDATime > 0.0)
    {
        SendMessageToPC(oPC,"You are still studying your target. Wait "+IntToString(FloatToInt(fApplyDATime))+ " second(s) before you can perform the death attack");
        return;
    }

    // Set a variable that tells us we are in the middle of a DA
    // Must study the target for three rounds
    fApplyDATime = RoundsToSeconds(3);
    SetLocalFloat(oPC,"PRC_ASSN_DEATHATTACK_APPLY",fApplyDATime );
    // save the race off so we know what racial type to slay
    SetLocalInt(oPC,"PRC_ASSN_TARGET_RACE",nType);
    //Save the target
    SetLocalObject(oPC, "PRC_DA_TARGET", oTarget);

    // Kick off a function to count down till they get the DA
    SendMessageToPC(oPC,"You begin to study your target");
    DelayCommand(6.0,ExecuteScript("prc_assn_da_hb",oPC));

}
