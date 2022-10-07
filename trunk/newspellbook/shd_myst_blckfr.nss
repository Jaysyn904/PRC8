/*
13/02/19 by Stratovarius

Black Fire

Apprentice, Dark Terrain 
Level/School: 2nd/Evocation [Cold] 
Range: Close (25 ft. + 5 ft./2 levels) 
Area: Wall of Black Flame
Duration: 1 round/level 
Saving Throw: Reflex negates
Spell Resistance: Yes

You open a conduit to the Plane of Shadow, drawing its elements into the world and igniting a black fire on the ground.

You create a shadowy curtain of black flame that covers the affected squares. The fire deals 1d6 points of cold damage per two caster levels, Reflex negates.
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"

void main()
{
    if(!ShadPreMystCastCode()) return;

    object oShadow      = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    struct mystery myst = EvaluateMystery(oShadow, oTarget, (METASHADOW_EXTEND | METASHADOW_EMPOWER | METASHADOW_MAXIMIZE));

    if(myst.bCanMyst)
    {
        location lTarget = PRCGetSpellTargetLocation();
        SetLocalLocation(oShadow, "BlackFire_Loc",lTarget);
        myst.fDur = RoundsToSeconds(myst.nShadowcasterLevel);
        if(myst.bExtend) myst.fDur *= 2;

        // Create AoE
        myst.eLink = EffectAreaOfEffect(AOE_PER_BLACKFIRE);
        if (myst.bIgnoreSR) myst.eLink = SupernaturalEffect(myst.eLink);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, myst.eLink, lTarget, myst.fDur);
        myst.nPen = ShadowSRPen(oShadow, myst.nShadowcasterLevel);
        myst.nSaveDC = GetShadowcasterDC(oShadow);
        SetLocalMystery(oShadow, MYST_HOLD_MYST+"1", myst);
    }
}