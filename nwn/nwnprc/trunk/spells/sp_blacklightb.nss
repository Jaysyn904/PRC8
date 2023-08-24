#include "prc_inc_spells"

const int SPELL_UR_BLACKLIGHT = 2091;

void main()
{

    PRCSetSchool(SPELL_SCHOOL_EVOCATION);

    object oTarget = GetExitingObject();
    object oCreator = GetAreaOfEffectCreator();

    //Search through the valid effects on the target.
    effect eAOE = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eAOE))
    {
        int nID = GetEffectSpellId(eAOE);

        if( nID== SPELL_UR_BLACKLIGHT)
        {
           if (GetEffectCreator(eAOE) == oCreator)
              RemoveEffect(oTarget, eAOE);

        }

        //Get next effect on the target
        eAOE = GetNextEffect(oTarget);
    }
    
    PRCSetSchool();

}
