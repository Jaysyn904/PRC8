//::///////////////////////////////////////////////
//:: Obscuring Mist
//:: sp_obscmist_exit.nss
//:://////////////////////////////////////////////
/*
    All people within the AoE get 20% conceal.
*/
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    //Declare major variables
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();
    effect eAOE;
    if(GetHasSpellEffect(SPELL_OBSCURING_MIST, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                if(GetEffectType(eAOE) == EFFECT_TYPE_CONCEALMENT)
                {
                    //If the effect was created by the Mist then remove it
                    if(GetEffectSpellId(eAOE) == SPELL_OBSCURING_MIST)
                    {
                        RemoveEffect(oTarget, eAOE);
                    }
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }

    PRCSetSchool();
}