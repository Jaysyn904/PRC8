//::///////////////////////////////////////////////
//:: Dirge: On Exit
//:: x0_s0_dirgeET.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    MARCH 2003
    Remove the negative effects of the dirge.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
//:: Update Pass By:
//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    PRCSetSchool(SPELL_SCHOOL_EVOCATION);

    //Declare major variables
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();
    object oCaster = GetAreaOfEffectCreator();

    //bugfix - caster should not leave AOE that is centered on his body
    if(oTarget == oCaster)
        return;

    if(GetHasSpellEffect(SPELL_DIRGE, oTarget))
    {
        //Search through the valid effects on the target.
        effect eAOE = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eAOE))
        {
            //If the effect was created by the Dirge spell then remove it
            if(GetEffectCreator(eAOE) == oCaster
            && GetEffectSpellId(eAOE) == SPELL_DIRGE)
            {
                RemoveEffect(oTarget, eAOE);
                DeleteLocalInt(oTarget, "X0_L_LASTPENALTY");
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
    PRCSetSchool();
}