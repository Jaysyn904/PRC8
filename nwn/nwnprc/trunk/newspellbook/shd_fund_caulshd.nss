/*
21/02/19 by Stratovarius

Caul of Shadow

Fundamental 
Level/School: 1st/Abjuration 
Range: Personal 
Target: You 
Duration: 1 minute/level

A shifting, whirling field of semisolid shadows and tiny rifts in the air rises around you.

Caul of shadow faintly darkens your form, but does not provide any bonuses on Hide checks or similar efforts. You gain a +1 deflection bonus to AC, with an additional +1 for every six caster levels (maximum bonus +4).
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"

void main()
{
    object oShadow      = OBJECT_SELF;
    // Get infinite uses at this level
    if (GetLevelByClass(CLASS_TYPE_SHADOWCASTER, oShadow) >= 14) IncrementRemainingFeatUses(oShadow, 23667);
    if(!ShadPreMystCastCode()) return;

    object oTarget      = PRCGetSpellTargetObject();
    struct mystery myst = EvaluateMystery(oShadow, oTarget, METASHADOW_EXTEND);

    if(myst.bCanMyst)
    {
        int nAC = PRCMin(4, 1 + myst.nShadowcasterLevel/6);
        myst.eLink = SupernaturalEffect(EffectLinkEffects(EffectACIncrease(nAC, AC_DEFLECTION_BONUS), EffectVisualEffect(VFX_DUR_ENTROPIC_SHIELD)));
               
        myst.fDur = 60.0 * myst.nShadowcasterLevel;       
        if(myst.bExtend) myst.fDur *= 2;
        // Duration Effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, myst.eLink, oTarget, myst.fDur, TRUE, myst.nMystId, myst.nShadowcasterLevel);               
    }
}