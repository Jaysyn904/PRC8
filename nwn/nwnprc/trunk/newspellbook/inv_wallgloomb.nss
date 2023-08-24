

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
    if(GetHasSpellEffect(INVOKE_WALL_OF_GLOOM, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE) && bValid == FALSE)
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                    //If the effect was created by either half of Fog from the Void
                    if(GetEffectSpellId(eAOE) == INVOKE_WALL_OF_GLOOM)
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

