/*
12/02/19 by Stratovarius

Carpet of Shadow

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

#include "shd_inc_shdfunc"
#include "shd_mysthook"

void main()
{
    if(!ShadPreMystCastCode()) return;

    object oShadow      = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    struct mystery myst = EvaluateMystery(oShadow, oTarget, METASHADOW_EXTEND);

    if(myst.bCanMyst)
    {
        location lTarget = PRCGetSpellTargetLocation();
        effect eImpact   = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_GREASE);
        myst.fDur = 60.0 * myst.nShadowcasterLevel;
        if(myst.bExtend) myst.fDur *= 2;

        // Do impact VFX
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);

        // Create AoE
        myst.eLink = EffectAreaOfEffect(AOE_PER_CARPET_SHADOW);
        if (myst.bIgnoreSR) myst.eLink = SupernaturalEffect(myst.eLink);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, myst.eLink, lTarget, myst.fDur);
    }
}