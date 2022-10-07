/*
18/02/19 by Stratovarius

Reflection of Things to Come

Master, Eyes of the Night Sky 
Level/School: 9th/Divination 
Range: Personal 
Target: You 
Duration: 10 minutes/level

Using the greatest of magic, you peer through the Plane of Shadow back into the Material Plane, and view shadows and reflections of events that have not yet happened.
This mystery grants you knowledge of what will occur (or at least what is likely to occur), granting you several benefits. You gain the uncanny dodge ability, a +10 
bonus to Armor Class, and the improved initiative feat.
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
        myst.fDur = 600.0 * myst.nShadowcasterLevel;       
        if(myst.bExtend) myst.fDur *= 2;
        
        object oSkin = GetPCSkin(oShadow);
        itemproperty ipUD;
        if(GetHasFeat(FEAT_UNCANNY_DODGE_1, oShadow))
            ipUD = PRCItemPropertyBonusFeat(IP_CONST_FEAT_UNCANNY_DODGE2);
        else
            ipUD = PRCItemPropertyBonusFeat(IP_CONST_FEAT_UNCANNY_DODGE1);

        IPSafeAddItemProperty(oSkin, ipUD, myst.fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);   
        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_INIT), myst.fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); 
        
        myst.eLink = EffectLinkEffects(EffectVisualEffect(PSI_DUR_TIMELESS_BODY), EffectACIncrease(10, AC_DEFLECTION_BONUS));
        
        // Duration Effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, myst.eLink, oTarget, myst.fDur, TRUE, myst.nMystId, myst.nShadowcasterLevel);               
    }
}