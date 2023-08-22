/*
    ----------------
    Roots of the Mountain, Exit

    tob_stdr_rtmntnb
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
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();
    int bValid = FALSE;
    effect eAOE;
    if(GetHasSpellEffect(MOVE_SD_ROOT_MOUNTAIN, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE) && bValid == FALSE)
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                    //If the effect was created by MOVE_DS_IRON_GUARDS_GLARE
                    if(GetEffectSpellId(eAOE) == MOVE_SD_ROOT_MOUNTAIN)
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

