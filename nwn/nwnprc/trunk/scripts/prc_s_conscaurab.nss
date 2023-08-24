//::///////////////////////////////////////////////
//:: [Censure Daemons]
//:: [prc_s_censuredm.nss]
//:://////////////////////////////////////////////
//:: All allies in the area are immune to fear
//:: and other mind effects created by outsiders
//:://////////////////////////////////////////////
//:: Created By: Aaon Graywolf
//:: Created On: Mar 17, 2004
//:://////////////////////////////////////////////
#include "prc_alterations"
void main()
{
    //Declare major variables
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();
    int bValid = FALSE;
    effect eAOE;
    if(GetHasSpellEffect(1758, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                //If the effect was created by the AOE then remove it
                if(GetEffectSpellId(eAOE) == 1758)
                {
                    RemoveEffect(oTarget, eAOE);
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }

}
