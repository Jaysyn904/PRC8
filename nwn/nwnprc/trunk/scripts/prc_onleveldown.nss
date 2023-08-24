//::///////////////////////////////////////////////
//:: OnLevelDown eventscript
//:: prc_onleveldown
//:://////////////////////////////////////////////
/** @file
    This script is a virtual event. It is fired
    when a check in module hearbeat detects a player's
    hit dice has dropped.
    It runs most of the same operations as prc_levelup
    in order to fully re-evaluate the character's
    class features that are granted by the PRC scripts.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 09.06.2005
//:://////////////////////////////////////////////

#include "prc_inc_function"
#include "psi_inc_psifunc"
#include "true_inc_trufunc"
#include "inv_inc_invfunc"
#include "tob_inc_tobfunc"
#include "tob_inc_moveknwn"

void main()
{
    object oPC    = OBJECT_SELF;
    int nOldLevel = GetLocalInt(oPC, "PRC_OnLevelDown_OldLevel");
    int nCharData = GetPersistantLocalInt(oPC, "PRC_Character_Data");
    int nHD = GetHitDice(oPC);

    // Setup class info for EvalPRCFeats()
    DeleteCharacterData(oPC);
    SetupCharacterData(oPC);

    // extract character info stored by prc_levelup.nss
    int nClass1 = nCharData & 0xFF,
        nClass2 = (nCharData >>> 8) & 0xFF,
        nClass3 = (nCharData >>> 16) & 0xFF;

    object oSkin = GetPCSkin(oPC);
    ScrubPCSkin(oPC, oSkin);
    DeletePRCLocalInts(oSkin);

    //All of the PRC feats have been hooked into EvalPRCFeats
    //The code is pretty similar, but much more modular, concise
    //And easy to maintain.
    //  - Aaon Graywolf
    EvalPRCFeats(oPC);

    int x, nClass;
    for (x = 1; x <= 3; x++)
    {
        switch(x)
        {
            case 1: nClass = nClass1; break;
            case 2: nClass = nClass2; break;
            case 3: nClass = nClass3; break;
        }

        // For psionics characters, remove powers known on all lost levels
        if(GetIsPsionicClass(nClass))
        {
            int i = nOldLevel;
            for(; i > nHD; i--)
                RemovePowersKnownOnLevel(oPC, i);
        }

        // Same for Invokers
        if(GetIsInvocationClass(nClass))
        {
            int i = nOldLevel;
            for(; i > nHD; i--)
                RemoveInvocationsKnownOnLevel(oPC, i);
        }

        // Same for Truenamers
        if(GetIsTruenamingClass(nClass))
        {
            int i = nOldLevel;
            for(; i > nHD; i--)
                RemoveUtterancesKnownOnLevel(oPC, i);
        }

        // And ToB
        if(GetIsBladeMagicClass(nClass))
        {
            int i = nOldLevel;
            for(; i > nHD; i--)
                RemoveManeuversKnownOnLevel(oPC, i);
        }
    }

    // Check to see which special prc requirements (i.e. those that can't be done)
    // through the .2da's, the newly leveled up player meets.
    ExecuteScript("prc_prereq", oPC);

    // Execute scripts hooked to this event for the player triggering it
    ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONPLAYERLEVELDOWN);

    // Clear the old level value
    DeleteLocalInt(oPC, "PRC_OnLevelDown_OldLevel");
}
