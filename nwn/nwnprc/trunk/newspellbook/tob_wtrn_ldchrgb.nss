/*
   ----------------
   Leading the Charge, Exit

   tob_wtrn_ldchrgb.nss
   ----------------

    27/04/07 by Stratovarius
*/ /** @file

    Leading the Charge

    White Raven (Stance)
    Level: Crusader 1, Warblade 1
    Initiation Action: 1 Swift Action
    Range: 60ft. 
    Area: 60 ft radius centred on you.
    Duration: Stance.

    You fire the confidence and martial spirit of your allies,
    giving them the energy and bravery needed to make a devastating charge
    against your enemies.
    
    All allies gain a +1 damage bonus on charge attacks per initiator level. 
*/

#include "tob_inc_tobfunc"
#include "tob_movehook"
//#include "prc_alterations"

void main()
{
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();
    // Just clean up the local
    DeleteLocalInt(oTarget, "LeadingTheCharge");
}

