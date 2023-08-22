/*
    ----------------
    Roots of the Mountain, Enter

    tob_stdr_rtmntna
    ----------------

    18/08/07 by Stratovarius
*/ /** @file

    Roots of the Mountain

    Stone Dragon (Stance)
    Level: Crusader 3, Swordsage 3, Warblade 3
    Initiation Action: 1 Swift Action
    Range: Personal
    Target: You
    Duration: Stance

    You crouch and set your feet flat on the ground, rooting yourself to the spot you stand. Nothing can move you from this place.
    
    You gain a +10 bonus on all ability checks for grapples, trips, overruns and bull rushes. Any creature that attempts
    to move past you gains a -10 penalty to Tumble, and you gain DR 2/-.
    This stance ends if you move more than 5 feet for any reason.
*/

#include "tob_inc_tobfunc"
#include "tob_movehook"
//#include "prc_alterations"

void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();
    effect eSkill = EffectSkillDecrease(SKILL_TUMBLE, 10);

    // Cleaned up on exit
    if (GetIsEnemy(oTarget, GetAreaOfEffectCreator())) SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eSkill, oTarget);
}