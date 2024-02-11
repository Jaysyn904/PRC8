/*
13/02/19 by Stratovarius

Clinging Darkness

Apprentice, Dark Terrain 
Level/School: 3rd/Conjuration (Creation) 
Range: Close (25 ft. + 5 ft./2 levels) 
Area: 20-ft.-radius emanation 
Duration: 1 minute/level 
Saving Throw: Reflex negates
Spell Resistance: Yes

Shadow oozes out of the floors, the walls, even the air, filling the area with wisps of writhing blackness. Creatures within the area become coated in these clinging shadows.

Any creature affected by this mystery must make a Reflex save or become immobilized for one round. This applies each round they are in the area of effect.
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
        myst.fDur = 60.0 * myst.nShadowcasterLevel;
        if(myst.bExtend) myst.fDur *= 2;

        // Create AoE
        myst.eLink = EffectAreaOfEffect(AOE_PER_CLINGING_DARKNESS);
        if (myst.bIgnoreSR) myst.eLink = SupernaturalEffect(myst.eLink);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, myst.eLink, lTarget, myst.fDur);
        myst.nPen = ShadowSRPen(oShadow, myst.nShadowcasterLevel);
        myst.nSaveDC = GetShadowcasterDC(oShadow);
        SetLocalMystery(oShadow, MYST_HOLD_MYST+"2", myst);
    }
}