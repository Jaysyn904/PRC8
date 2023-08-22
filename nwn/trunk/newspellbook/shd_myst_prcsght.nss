/*
13/02/19 by Stratovarius

Piercing Sight

Apprentice, Eyes of Darkness 
Level/School: 2nd/Divination 
Range: Personal 
Target: You 
Duration: 1 minute/level

You view the shadow reflection of the world around you, allowing you to penetrate darkness and mystical obstructions.

You can see invisible and ethereal creatures and objects as with the see invisibility spell. In addition, you gain darkvision out to 60 feet.
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
        myst.eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT), EffectSeeInvisible());
        if (myst.bIgnoreSR) myst.eLink = SupernaturalEffect(myst.eLink);
               
        myst.fDur = 60.0 * myst.nShadowcasterLevel;       
        if(myst.bExtend) myst.fDur *= 2;
        // Duration Effects
        object oSkin = GetPCSkin(oTarget);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, myst.eLink, oTarget, myst.fDur, TRUE, myst.nMystId, myst.nShadowcasterLevel);  
        IPSafeAddItemProperty(oSkin, ItemPropertyDarkvision(), myst.fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    }
}