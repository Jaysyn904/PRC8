//::///////////////////////////////////////////////
//:: Name      Chilling Tentacles - OnExit
//:: FileName  inv_chilltentb.nss
//::///////////////////////////////////////////////

//#include "prc_alterations"
#include "inv_inc_invfunc"

void main()
{
    //Declare major variables
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();
    int bValid = FALSE;
    effect eAOE;
    if(GetHasSpellEffect(INVOKE_CHILLING_TENTACLES, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eAOE) && bValid == FALSE)
        {
            if(GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                if(GetEffectType(eAOE) == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE)
                {
                    //If the effect was created by the Acid_Fog then remove it
                    if(GetEffectSpellId(eAOE) == INVOKE_CHILLING_TENTACLES)
                    {
                        RemoveEffect(oTarget, eAOE);
                        bValid = TRUE;
                    }
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
}