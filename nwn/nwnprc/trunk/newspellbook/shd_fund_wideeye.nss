/*
21/02/19 by Stratovarius

Widened Eyes

Fundamental 
Level/School: 1st/Divination 
Range: Personal
Target: You 
Duration: 10 minutes/level

You cover your eyes with a filter of shadow that channels and enhances incoming light.

You gain low-light vision, enabling you to see twice as far as a human in starlight, moonlight, torchlight, shadowy illumination, and similar conditions of poor illumination. If you already have low-light vision, these effects stack, enabling you to see four times as far as a human in poor illumination.
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"

void main()
{
    object oShadow      = OBJECT_SELF;
    // Get infinite uses at this level
    if (GetLevelByClass(CLASS_TYPE_SHADOWCASTER, oShadow) >= 14) IncrementRemainingFeatUses(oShadow, 23672);
    if(!ShadPreMystCastCode()) return;

    object oTarget      = PRCGetSpellTargetObject();
    struct mystery myst = EvaluateMystery(oShadow, oTarget, METASHADOW_EXTEND);

    if(myst.bCanMyst)
    {
        myst.fDur = 600.0 * myst.nShadowcasterLevel;       
        if(myst.bExtend) myst.fDur *= 2;
        // Duration Effects
        object oSkin = GetPCSkin(oShadow);
        itemproperty ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_LOWLIGHT_VISION);
        IPSafeAddItemProperty(oSkin, ipIP, myst.fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);        
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_ULTRAVISION), oTarget, myst.fDur, TRUE, myst.nMystId, myst.nShadowcasterLevel);               
    }
}