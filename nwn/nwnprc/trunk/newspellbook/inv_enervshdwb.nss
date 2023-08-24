//::///////////////////////////////////////////////
//:: AoE: On Exit
//:://////////////////////////////////////////////
/*
   
*/

#include "prc_alterations"
#include "inv_inc_invfunc"

void main()
{
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();
    
    if(oTarget != GetAreaOfEffectCreator())
        return;
    
    //Search through the valid effects on the target.
    effect eAOE = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eAOE))
    {
        //If the effect was created by the AoE then remove it
        if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
        {
            if(GetEffectSpellId(eAOE) == INVOKE_ENERVATING_SHADOW)
            {
                RemoveEffect(oTarget, eAOE);
            }
        }
        eAOE = GetNextEffect(oTarget);
    }

}

