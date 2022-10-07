//::///////////////////////////////////////////////
//:: Name      Chilling Fog - OnExit
//:: FileName  inv_dra_chilfogb.nss
//::///////////////////////////////////////////////

#include "inv_inc_invfunc"

void main()
{
    //Declare major variables
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();
    int bValid = FALSE;
    effect eAOE;
    if(GetHasSpellEffect(INVOKE_CHILLING_FOG, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE) && bValid == FALSE)
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                //If the effect was created by Chillign Fog
                if(GetEffectSpellId(eAOE) == INVOKE_CHILLING_FOG)
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