/*
18/02/19 by Stratovarius

Umbral Body

Master, Dark Metamorphosis 
Level/School: 8th/Transmutation 
Range: Personal 
Target: You 
Duration: 1 round/level

You become a being of shadow, rather than one of substance.

You gain the incorporeal subtype.
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
        myst.fDur = 6.0 * myst.nShadowcasterLevel;       
        if(myst.bExtend) myst.fDur *= 2;
        SetIncorporeal(oShadow, myst.fDur, 0);              
    }
}