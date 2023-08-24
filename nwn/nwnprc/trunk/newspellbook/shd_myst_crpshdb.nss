/*
12/02/19 by Stratovarius

Carpet of Shadow, OnExit

Apprentice, Dark Terrain 
Level/School: 1st/Conjuration (Creation) 
Range: Close (25 ft. + 5 ft./2 levels) 
Area: 10-ft. square
Duration: 1 minute/level 
Saving Throw: None 
Spell Resistance: No

The ground becomes rough and hazardous, the real floor superimposed with irregular terrain of the Plane of Shadow.

You cloak the ground with an uneven and hard to traverse surface. All movement speed is halved.
*/

#include "prc_inc_spells"
#include "shd_myst_const"

void main()
{
    object oCreator = GetAreaOfEffectCreator();
    object oTarget  = GetExitingObject();

    // Loop over effects, removing the ones from this power
    effect eAOE;
    if(GetHasSpellEffect(MYST_CARPET_SHADOW, oTarget))
    {
        eAOE = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eAOE))
        {
            if(GetEffectCreator(eAOE) == oCreator                            &&
               GetEffectType(eAOE)    == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE &&
               GetEffectSpellId(eAOE) == MYST_CARPET_SHADOW
               )
            {
                RemoveEffect(oTarget, eAOE);
            }
            // Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }// end while - Effect loop
    }// end if - Target has been affected at all
}
