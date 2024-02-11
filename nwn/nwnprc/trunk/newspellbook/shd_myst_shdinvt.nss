/*
16/02/19 by Stratovarius

Shadow Investiture

Initiate, Body and Soul 
Level/School: 6th/Transmutation 
Range: Close (25 ft. + 5 ft./2 levels) 
Target: One creature Duration: 1 round/level 

You draw the subject’s shadow to you and sculpt it into a new shape. The subject warps even as its shadow does.

You infuse the subject with the power contained in its own shadow. This grants the creature resistance to cold 15, 
the evasion ability, and the ability to see in darkness.
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
        myst.eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_MARK_OF_THE_HUNTER), EffectUltravision());
        myst.eLink = EffectLinkEffects(myst.eLink, EffectDamageResistance(DAMAGE_TYPE_COLD, 15));
        //myst.eLink = EffectLinkEffects(myst.eLink, EffectDamageResistance(DAMAGE_TYPE_COLD, 15));
               
        myst.fDur = 6.0 * myst.nShadowcasterLevel;       
        if(myst.bExtend) myst.fDur *= 2;
        // Duration Effects
        object oSkin = GetPCSkin(oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_X_UNDEAD), oTarget);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, myst.eLink, oTarget, myst.fDur, TRUE, myst.nMystId, myst.nShadowcasterLevel);  
        IPSafeAddItemProperty(oSkin, ItemPropertyDarkvision(), myst.fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_EVASION), myst.fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    }
}
