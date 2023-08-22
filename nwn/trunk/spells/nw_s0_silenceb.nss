 //::///////////////////////////////////////////////
//:: Silence: On Exit
//:: NW_S0_SilenceB.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The target is surrounded by a zone of silence
    that allows them to move without sound.  Spell
    casters caught in this area will be unable to cast
    spells.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin  Dec 4, 2003
#include "prc_inc_spells"

void main()
{
    PRCSetSchool(SPELL_SCHOOL_ILLUSION);

    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();

    if(GetHasSpellEffect(SPELL_SILENCE, oTarget)
    || GetHasSpellEffect(POWER_CONTROLSOUND, oTarget))
    {
        int bValid = FALSE;
        //Search through the valid effects on the target.
        effect eAOE = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eAOE) && !bValid)
        {
            //If the effect was created by the Silence then remove it
            if(GetEffectCreator(eAOE) == GetAreaOfEffectCreator()
            && (GetEffectSpellId(eAOE) == SPELL_SILENCE || GetEffectSpellId(eAOE) == POWER_CONTROLSOUND)
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