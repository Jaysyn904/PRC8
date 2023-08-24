//::///////////////////////////////////////////////
//:: Consecrate On Exit
//:: sp_consecrateb.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/* 
    
*/
//:://////////////////////////////////////////////
//:: Recreated By: Tenjac
//:: Created On: Sept 16, 2008
//:://////////////////////////////////////////////
#include "prc_inc_spells"

void main()
{
    object oTarget = GetExitingObject();

    effect eAOE;
    if(GetHasSpellEffect(SPELL_CONSECRATE, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                //If the effect was created by consecrate then remove it
                if(GetEffectSpellId(eAOE) == SPELL_CONSECRATE)
                {
                    RemoveEffect(oTarget, eAOE);
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
}