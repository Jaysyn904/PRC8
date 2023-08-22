/*
02/03/21 by Stratovarius

Focalor, Prince of Tears
  
Granted Abilities: 
Focalor gives you the ability to breathe water, strike foes down with lightning, blind enemies with a puff of your breath, and cause creatures to be stricken with grief in your presence.

Aura of Sadness: You emit an aura of depression and anguish that overtakes even the strongest-willed creatures. Every adjacent creature is overcome with grief, which manifests as a 
–2 penalty on attack rolls, saving throws, and skill checks, for as long as it remains adjacent to you. You can suppress or activate this ability as a standard action. Aura of sadness is a mind-affecting ability.

OnExit
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oCreator = GetAreaOfEffectCreator();
    object oTarget  = GetExitingObject();

    // Loop over effects, removing the ones from this power
    effect eAOE;
    if(GetHasSpellEffect(VESTIGE_FOCALOR_AURA_SADNESS, oTarget))
    {
        eAOE = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eAOE))
        {
            if(GetEffectCreator(eAOE) == oCreator                            &&
               GetEffectSpellId(eAOE) == VESTIGE_FOCALOR_AURA_SADNESS        &&
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
