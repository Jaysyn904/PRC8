//::///////////////////////////////////////////////
//:: Battletide
//:: X2_S0_BattTideB
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    You create an aura that steals energy from your
    enemies. Your enemies suffer a -2 circumstance
    penalty on saves, attack rolls, and damage rolls,
    once entering the aura. On casting, you gain a
    +2 circumstance bonus to your saves, attack rolls,
    and damage rolls.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Dec 04, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs 06/06/03

//:: modified by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);

    //Declare major variables
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();
    object oCaster = GetAreaOfEffectCreator();

    //bugfix - caster should not leave AOE that is centered on his body
    if(oTarget == oCaster)
        return;

    if(GetHasSpellEffect(SPELL_BATTLETIDE, oTarget))
    {
        int bValid = FALSE;
        //Search through the valid effects on the target.
        effect eAOE = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eAOE) && !bValid)
        {
            //If the effect was created by the Battletide then remove it
            if(GetEffectCreator(eAOE) == oCaster
            && GetEffectSpellId(eAOE) == SPELL_BATTLETIDE)
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