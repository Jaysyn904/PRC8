/*
23/1/21 by Stratovarius

A soulspark attacks by focusing soul energy on its target as a ranged attack. This doesn’t provoke attacks of opportunity.
*/

//::///////////////////////////////////////////////
//:: Custom Beholder AI
//:: x2_ai_behold
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This is the Hordes of the Underdark campaign
    Mini AI run on the beholders.

    It does not use any spells assigned to the
    beholder, if you want to make a custom beholder
    you need to deactivate this AI by removing the
    approriate variable from your beholder creature
    in the toolset

    Short overview:

    Beholder will always use its eyes, unless

    a) If threatened in melee, it will try to move away or float away
       to the nearest waypoint tagged X2_WP_BEHOLDER_TUNNEL

    b) If threatened in melee and below 1/5 hp it will always try to float

    b) If affected by antimagic itself, it melee attack

    c) If target is affected by petrification, it will melee attack

    Logic for eye ray usage are in the appropriate spellscripts


    setting X2_BEHOLDER_AI_NOJUMP to 1 will prevent the beholders from
    jumping, even if there are jump points nearby




*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-08-21
//:://////////////////////////////////////////////

#include "nw_i0_generic"
#include "x0_i0_spells"
#include "x2_inc_switches"

void main()
{
    //return;
    //The following two lines should not be touched
    object oIntruder = GetCreatureOverrideAIScriptTarget();


    ClearCreatureOverrideAIScriptTarget();
    SetCreatureOverrideAIScriptFinished();

    /*if (GetLocalString(OBJECT_SELF,"UID") =="")
    {
            SetLocalString(OBJECT_SELF,"UID",RandomName());
    }
    string UID =   GetLocalString(OBJECT_SELF,"UID");

    if (GetLocalInt(GetModule(),"TEST")>0 )
    {
        if (GetLocalInt(GetModule(),"TEST") ==2)
        {
            if (!GetLocalInt (OBJECT_SELF,"IN_DEBUG") ==0)
            {
              return;
            }
        }
        SetLocalInt(GetModule(),"TEST",2);
        SpawnScriptDebugger();
        SetLocalInt (OBJECT_SELF,"IN_DEBUG",TRUE);
    }
    */



    // ********************* Start of custom AI script ****************************


    // Here you can write your own AI to run in place of DetermineCombatRound.
    // The minimalistic approach would be something like
    //
    // TalentFlee(oTarget); // flee on any combat activity


    if(GetAssociateState(NW_ASC_IS_BUSY))
    {
        return;
    }

    if(BashDoorCheck(oIntruder)) {return;}

    // * BK: stop fighting if something bizarre that shouldn't happen, happens
    if (bkEvaluationSanityCheck(oIntruder, GetFollowDistance()) == TRUE)
        return;


    int nDiff = GetCombatDifficulty();
    SetLocalInt(OBJECT_SELF, "NW_L_COMBATDIFF", nDiff);


    if (GetIsObjectValid(oIntruder) == FALSE)
        oIntruder = bkAcquireTarget();


    if (GetIsObjectValid(oIntruder) == FALSE)
    {

            oIntruder = GetNearestSeenOrHeardEnemy();
    }


    if (GetIsObjectValid(oIntruder) == FALSE)
    {
            oIntruder = GetLastAttacker();
    }


    if (GetIsObjectValid(oIntruder) && GetIsDead(oIntruder) == TRUE)
    {
        return;
    }


    if (__InCombatRound() == TRUE)
    {
        return;
    }

    __TurnCombatRoundOn(TRUE);


    //SpeakString("AI Target: " + GetName(oIntruder));

    if(GetIsObjectValid(oIntruder))
    {


        // * Will put up things like Auras quickly
        if(TalentPersistentAbilities())
        {

         __TurnCombatRoundOn(FALSE);
            return;
        }

        if(TalentHealingSelf() == TRUE)
        {

            __TurnCombatRoundOn(FALSE);
            return;
        }


        if(TalentUseProtectionOnSelf() == TRUE)
        {
            __TurnCombatRoundOn(FALSE);
            return;
        }


        //Used for Potions of Enhancement and Protection
        if(TalentBuffSelf() == TRUE)
        {
            __TurnCombatRoundOn(FALSE);
            return;
        }

        if(TalentAdvancedProtectSelf() == TRUE)
        {
            __TurnCombatRoundOn(FALSE);
            return;
        }


        ClearAllActions();
        ActionCastSpellAtObject(18956,oIntruder,METAMAGIC_ANY,TRUE,0,PROJECTILE_PATH_TYPE_DEFAULT,TRUE);

       __TurnCombatRoundOn(FALSE);
       return;
    }
    else
    {

    }
     __TurnCombatRoundOn(FALSE);

    //This is a call to the function which determines which
    // way point to go back to.
    ClearAllActions(TRUE);
    SetLocalObject(OBJECT_SELF, "NW_GENERIC_LAST_ATTACK_TARGET", OBJECT_INVALID);
    WalkWayPoints();

}