//::///////////////////////////////////////////////
//:: Vine Mine, Entangle B: On Exit
//:: X2_S0_VineMEntB
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Removes the entangle effect after the AOE dies.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 25, 2002
//:://////////////////////////////////////////////

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_inc_spells"


#include "prc_add_spell_dc"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);

    //Declare major variables
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();
    effect eAOE;
    if(GetHasSpellEffect(SPELL_VINE_MINE_ENTANGLE, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                if(GetEffectType(eAOE) == EFFECT_TYPE_ENTANGLE)
                {
                    //If the effect was created by the Acid_Fog then remove it
                    if(GetEffectSpellId(eAOE) == SPELL_VINE_MINE_ENTANGLE)
                    {
                        RemoveEffect(oTarget, eAOE);
                    }
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school

}

