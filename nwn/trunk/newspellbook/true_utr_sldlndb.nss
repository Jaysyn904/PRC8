/*
   ----------------
   Shield of the Landscape, Exit

   true_utr_sldlndb
   ----------------

    1/9/06 by Stratovarius
*/ /** @file

    Shield of the Landscape

    Level: Perfected Map 1
    Range: 100 feet
    Area: 20' Radius, Centred on Caster 
    Duration: 1 Minute
    Spell Resistance: No
    Save: None
    Metautterances: Extend

    You cause the ground to alter its basic form, creating cover for you allies.
    All allies (including you) in the area gain 20% concealment vs Ranged attacks.
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
    if(GetHasSpellEffect(UTTER_SHIELD_LANDSCAPE, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE) && bValid == FALSE)
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                    //If the effect was created by either half of Fog from the Void
                    if(GetEffectSpellId(eAOE) == UTTER_SHIELD_LANDSCAPE)
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

