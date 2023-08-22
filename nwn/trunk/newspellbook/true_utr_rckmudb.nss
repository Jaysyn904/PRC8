/*
   ----------------
   Speak Rock to Mud, Exit

   true_utr_rckmudb
   ----------------

    2/9/06 by Stratovarius
*/ /** @file

    Speak Rock to Mud

    Level: Perfected Map 2
    Range: 100 feet
    Area: 20' Radius
    Duration: 1 Minute
    Spell Resistance: No
    Save: None
    Metautterances: Extend

    With a word, you create an area of viscous, sucking mud.
    Every creature in the area has their speed reduced by 80%, and take a -2 penalty to AC and Attack.
*/

#include "true_inc_trufunc"
#include "true_utterhook"
//#include "prc_alterations"

void main()
{
    //Declare major variables
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();
    int bValid = FALSE;
    effect eAOE;
    if(GetHasSpellEffect(UTTER_SPEAK_ROCK_MUD, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE) && bValid == FALSE)
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                    //If the effect was created by either half of Fog from the Void
                    if(GetEffectSpellId(eAOE) == UTTER_SPEAK_ROCK_MUD)
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

