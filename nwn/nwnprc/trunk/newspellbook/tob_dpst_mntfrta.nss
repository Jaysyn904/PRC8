/*
    ----------------
    Mountain Fortress Stance

    tob_dpst_mntfrt
    ----------------

    27/01/08 by Stratovarius
*/ /** @file

    Mountain Fortress Stance

    Deepstone Sentinel level 1

    You crouch and set your feet flat on the ground, drawing 
    the resilience of the earth into your body.
    
    You gain a +1 bonus to attacks from being on higher ground, and any creature attempting to fight you in
    melee combat must attempt a DC 10 Balance check or fall prone.
    This stance ends if you move more than 5 feet for any reason.
*/

#include "tob_inc_tobfunc"
#include "tob_movehook"
////#include "prc_alterations"

void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();

    // Cleaned up on exit
    if (!GetIsSkillSuccessful(oTarget, SKILL_BALANCE, 10) && GetIsEnemy(oTarget, GetAreaOfEffectCreator()))
    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectKnockdown()), oTarget, 6.0);
}