#include "prc_alterations"

void main()
{


    //Declare major variables
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();
    object oCreator = GetAreaOfEffectCreator();
    effect eAOE;
    //Search through the valid effects on the target.
    eAOE = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eAOE))
    {
        int nID = GetEffectSpellId(eAOE);

        if(nID == SPELL_DSL_SONG_STRENGTH)
        {
           if (GetEffectCreator(eAOE) == oCreator)
              RemoveEffect(oTarget, eAOE);

        }

        //Get next effect on the target
        eAOE = GetNextEffect(oTarget);
    }

}
