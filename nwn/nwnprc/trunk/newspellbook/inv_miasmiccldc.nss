/*
   ----------------
   Fog from the Void, Exit

   true_utr_fogvodc
   ----------------

    1/9/06 by Stratovarius
*/ /** @file

    Fog from the Void

    Level: Perfected Map 1
    Range: 100 feet
    Area: 20' Radius 
    Duration: 1 Minute
    Spell Resistance: No
    Save: None
    Metautterances: Extend

    At your words, moisture in the air and ground condenses into a thick mist.
    You create a thick, roiling cloud of fog like the fog cloud spell.
    If you add 10 to the DC of your Truespeak check, you can create a solid fog, as the spell.
*/

#include "inv_inc_invfunc"
#include "inv_invokehook"
#include "prc_alterations"

void main()
{
    //Declare major variables
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();
    int bValid = FALSE;
    effect eAOE;
    if(GetHasSpellEffect(INVOKE_MIASMIC_CLOUD, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE) && bValid == FALSE)
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                    //If the effect was created by either half of Fog from the Void
                    if(GetEffectSpellId(eAOE) == INVOKE_MIASMIC_CLOUD)
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

