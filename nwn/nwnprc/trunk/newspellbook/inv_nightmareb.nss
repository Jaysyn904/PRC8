

#include "prc_alterations"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{

    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();
    
    //Search through the valid effects on the target.
    effect eAOE = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eAOE))// && bValid == FALSE)
    {
        //If the effect was created by the Web then remove it
        if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
        {
            if(GetEffectSpellId(eAOE) == INVOKE_NIGHTMARES_MADE_REAL)
            {
                RemoveEffect(oTarget, eAOE);
            }
        }
        eAOE = GetNextEffect(oTarget);
    }
    
    if(oTarget != GetAreaOfEffectCreator()) return;
    //clean HIPS off creator
    object oSkin = GetPCSkin(oTarget);
    IPRemoveMatchingItemProperties(oSkin, ITEM_PROPERTY_BONUS_FEAT, DURATION_TYPE_TEMPORARY, 31);
}

