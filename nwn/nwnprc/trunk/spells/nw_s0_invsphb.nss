//::///////////////////////////////////////////////
//:: Invisibility Sphere: On Exit
//:: NW_S0_InvSphA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All allies within 15ft are rendered invisible.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
#include "prc_inc_spells"

void main()
{
    PRCSetSchool(SPELL_SCHOOL_ILLUSION);

    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();

    if(GetHasSpellEffect(SPELL_INVISIBILITY_SPHERE, oTarget))
    {
        int bValid = FALSE;
        //Search through the valid effects on the target.
        effect eAOE = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eAOE) && !bValid)
        {
            //If the effect was created by the Invisibility Sphere then remove it
            if(GetEffectCreator(eAOE) == GetAreaOfEffectCreator()
            && GetEffectSpellId(eAOE) == SPELL_INVISIBILITY_SPHERE
            && GetEffectType(eAOE) != EFFECT_TYPE_AREA_OF_EFFECT)
            {
                RemoveEffect(oTarget, eAOE);
                bValid = TRUE;
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
    PRCSetSchool();
}