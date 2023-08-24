/*
18/02/19 by Stratovarius

Shadow Plague

Master, Shadow Calling 
Level/School: 8th/Conjuration (Creation) [Cold]

This mystery functions like the spell incendiary cloud, except that it deals cold damage rather than fire damage.
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"

void main()
{
    if(!ShadPreMystCastCode()) return;

    object oShadow      = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    struct mystery myst = EvaluateMystery(oShadow, oTarget, (METASHADOW_EXTEND | METASHADOW_EMPOWER | METASHADOW_MAXIMIZE));
    
    if (DEBUG) DoDebug(GetName(oShadow)+" is casting Shadow Plague", oShadow);    

    if(myst.bCanMyst)
    {
        location lTarget = PRCGetSpellTargetLocation();
        myst.fDur = 6.0 * myst.nShadowcasterLevel;
        if(myst.bExtend) myst.fDur *= 2;

        // Create AoE
        myst.eLink = EffectAreaOfEffect(AOE_PER_PLAGUE_SHADOW);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, myst.eLink, lTarget, myst.fDur);
        
        myst.nPen = ShadowSRPen(oShadow, myst.nShadowcasterLevel);
        myst.nSaveDC = GetShadowcasterDC(oShadow);
        SetLocalMystery(oShadow, MYST_HOLD_MYST+"4", myst);
    }
}