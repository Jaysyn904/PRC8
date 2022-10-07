/*
15/02/19 by Stratovarius

Curtain of Shadows

Initiate, Veil of Shadows 
Level/School: 5th/Transmutation 
Range: Close (25 ft. + 5 ft./2 levels) 
Effect: Shadowy wall 
Duration: 1 minute/level 
Saving Throw: None 
Spell Resistance: No

You create a wall of frigid shadow that wracks all who pass through it with cold.

You create a wall of shadow. Any creature passing through the wall takes 1d6 points of cold damage per caster level (maximum 15d6).
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
        myst.fDur = TurnsToSeconds(myst.nShadowcasterLevel);
        if(myst.bExtend) myst.fDur *= 2;

        // Create AoE
        myst.eLink = EffectAreaOfEffect(AOE_PER_CURTAIN_SHADOWS);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, myst.eLink, lTarget, myst.fDur);
        
        object oAoE = GetAreaOfEffectObject(lTarget, "VFX_PER_BLACKFIRE");
        SetAllAoEInts(myst.nMystId, oAoE, GetShadowcasterDC(oShadow), 0, myst.nShadowcasterLevel);
        SetLocalMystery(oShadow, MYST_HOLD_MYST+"3", myst);
    }
}