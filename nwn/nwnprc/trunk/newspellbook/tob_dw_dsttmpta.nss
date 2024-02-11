/*
   ----------------
   Desert Tempest, Enter

   tob_dw_dsttmpta.nss
   ----------------

    29/10/07 by Stratovarius
*/ /** @file

    Desert Tempest

    Desert Wind (Strike)
    Level: Swordsage 6
    Prerequisite: Two Desert Wind maneuvers
    Initiation Action: 1 Full-round Action
    Range: Personal
    Target: You
    Duration: 1 round.

    You move in a blur, leaving scorch marks in your wake as you twirl around 
    the battlefield, slicing into your foes as you move.
    
    Move up to your speed. Each time you move next to an enemy, make a single melee attack against him.
    No enemy can be struck more than once. 
*/

#include "tob_inc_tobfunc"
#include "tob_movehook"
////#include "prc_alterations"

void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();
    object oInitiator = GetAreaOfEffectCreator();
    // Targets it can apply to
    if (oTarget != oInitiator && GetIsEnemy(oTarget, oInitiator) && !GetLocalInt(oTarget, "DesertTempest"))
    {
	    // Slap upside the head, only one AoO per round.
	    effect eNone;
        int nDamage;
        if (GetLocalInt(oInitiator, "DesertFire")) nDamage += d6();
	    DelayCommand(0.0, PerformAttack(oTarget, GetAreaOfEffectCreator(), eNone, 0.0, 0, nDamage, 0, "Desert Tempest Hit", "Desert Tempest Miss"));
	    SetLocalInt(oTarget, "DesertTempest", TRUE);
	    DelayCommand(6.0, DeleteLocalInt(oTarget, "DesertTempest"));
    }
}