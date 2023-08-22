/*
03/03/21 by Stratovarius

Buer, Grandmother Huntress
  
Buer grants binders superior healing as well as powers against poisons and diseases.

Vestige Level: 4th
Binding DC: 20
Special Requirement: Buer requires that her seal be drawn outdoors.

Influence: Under Buer’s influence, you are plagued by momentary memory lapses. For an instant, you might forget even a piece of information as familiar as the 
name of a friend or family member. Furthermore, since Buer abhors the needless death of living creatures other than animals and vermin, the first melee 
attack you make against such a foe must be for nonlethal damage. In addition, Buer requires that you not make any coup de grace attacks.

Granted Abilities: 
Buer grants you healing powers, the ability to ignore toxins and ailments, and skills that help you navigate the natural world.

Delay Diseases and Poisons: Each ally within 30 feet of you gains immunity to poison and disease. 

OnExit
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oCreator = GetAreaOfEffectCreator();
    object oTarget  = GetExitingObject();

    // Loop over effects, removing the ones from this power
    effect eAOE;
    if(GetHasSpellEffect(VESTIGE_BUER, oTarget))
    {
        eAOE = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eAOE))
        {
            if(GetEffectCreator(eAOE) == oCreator     &&
               GetEffectSpellId(eAOE) == VESTIGE_BUER &&
               oTarget != oCreator
               )
            {
                RemoveEffect(oTarget, eAOE);
            }
            // Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }// end while - Effect loop
    }// end if - Target has been affected at all
}
