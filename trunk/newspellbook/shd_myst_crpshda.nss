/*
12/02/19 by Stratovarius

Carpet of Shadow, OnEnter

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

void main()
{
    object oCreator = GetAreaOfEffectCreator();
    object oTarget  = GetEnteringObject();
    object oAoE     = OBJECT_SELF;
    effect eLink    = EffectLinkEffects(EffectMovementSpeedDecrease(50),
                                        EffectVisualEffect(VFX_IMP_SLOW)
                                        );

    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCreator))
    {
        if(GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL) != TRUE)
        {
            //Fire cast spell at event for the target
            SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELL_GREASE));

            //Apply reduced movement effect and VFX_Impact
            SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget, 0.0f, FALSE);
        }// end if - Immunity check
    }// end if - Difficulty check
}
