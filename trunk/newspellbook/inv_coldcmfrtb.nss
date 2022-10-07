//::///////////////////////////////////////////////
//:: Name      Cold Comfort - OnExit
//:: FileName  inv_coldcmfrtb.nss
//::///////////////////////////////////////////////

#include "inv_inc_invfunc"

void main()
{
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();

    //Search through the valid effects on the target.
    effect eAOE = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eAOE))
    {
        //If the effect was created by the AoE then remove it
        if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
        {
            if(GetEffectSpellId(eAOE) == INVOKE_COLD_COMFORT)
            {
                RemoveEffect(oTarget, eAOE);
            }
        }
        eAOE = GetNextEffect(oTarget);
    }
}

