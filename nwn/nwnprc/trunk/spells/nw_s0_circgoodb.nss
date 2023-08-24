//::///////////////////////////////////////////////
//:: Magic Cirle Against Good
//:: NW_S0_CircGoodB
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Add basic protection from good effects to
    entering allies.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 20, 2001
//:://////////////////////////////////////////////
#include "prc_inc_spells"

void main()
{
    PRCSetSchool(SPELL_SCHOOL_ABJURATION);

    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();

    if(GetHasSpellEffect(SPELL_MAGIC_CIRCLE_AGAINST_GOOD, oTarget))
    {
        int bValid = FALSE;
        //Search through the valid effects on the target.
        effect eAOE = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eAOE) && !bValid)
        {
            if(GetEffectCreator(eAOE) == GetAreaOfEffectCreator()
            && GetEffectSpellId(eAOE) == SPELL_MAGIC_CIRCLE_AGAINST_GOOD
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