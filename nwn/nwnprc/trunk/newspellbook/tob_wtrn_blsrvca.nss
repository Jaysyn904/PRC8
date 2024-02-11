/*
   ----------------
   Bolstering Voice, Enter

   tob_wtrn_blsrvca.nss
   ----------------

    27/04/07 by Stratovarius
*/ /** @file

    Bolstering Voice

    White Raven (Stance)
    Level: Crusader 1, Warblade 1
    Initiation Action: 1 Swift Action
    Range: 60ft. 
    Area: 60 ft radius centred on you.
    Duration: Stance.

    Your clarion voice strengthens the will of your comrades. So long
    as you remain on the field of battle, your allies are strengthened against
    attacks and effects that seek to subvert their willpower.
    
    All allies gain a +2 Will save bonus.
*/

#include "tob_inc_tobfunc"
#include "tob_movehook"
//#include "prc_alterations"

void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();
    effect eWill = EffectSavingThrowIncrease(SAVING_THROW_WILL, 2);
           eWill = ExtraordinaryEffect(eWill);
    // Targets it can apply to
    if (oTarget != GetAreaOfEffectCreator() && 
        GetIsFriend(oTarget, GetAreaOfEffectCreator()))
    {
    	// Lasts until they leave the AoE
    	SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eWill, oTarget);
    }
}