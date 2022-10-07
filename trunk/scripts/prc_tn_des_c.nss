//::///////////////////////////////////////////////
//:: Desecrate
//:: prc_tn_des_b
//:://////////////////////////////////////////////
/*
    You create an aura that boosts the undead
    around you.
*/
#include "prc_alterations"
#include "prc_spell_const"

void main()
{
    object oTarget = GetExitingObject();

    if(GetHasSpellEffect(SPELL_DES_100, oTarget))
    {
        //Search through the valid effects on the target.
        effect eAOE = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eAOE))
        {
            if(GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                if(GetEffectSpellId(eAOE) == SPELL_DES_100)
                    RemoveEffect(oTarget, eAOE);
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
}