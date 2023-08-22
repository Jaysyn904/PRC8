/*
   ----------------
   Bolstering Voice, Exit

   tob_wtrn_blsrvcb.nss
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
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();
    int bValid = FALSE;
    effect eAOE;
    if(GetHasSpellEffect(MOVE_WR_BOLSTERING_VOICE, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE) && bValid == FALSE)
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                    //If the effect was created by MOVE_WR_BOLSTERING_VOICE
                    if(GetEffectSpellId(eAOE) == MOVE_WR_BOLSTERING_VOICE)
                    {
                        RemoveEffect(oTarget, eAOE);
                        bValid = TRUE;
                    }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
}

