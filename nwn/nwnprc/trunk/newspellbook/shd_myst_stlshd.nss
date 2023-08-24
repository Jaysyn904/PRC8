/*
09/02/19 by Stratovarius

Steel Shadows

Apprentice, Cloak of Shadows 
Level/School: 1st/Abjuration 
Range: Personal 
Target: You 
Duration: 10 minutes/level

Darkness coalesces about your body, forming a shadow-shape of armor and another that looks like a shield. Although they are as weightless as the air, you know they’ll protect you as well as if they were made of steel.

Steel shadows grants you a +3 armor bonus and a +3 shield bonus to AC.
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
        myst.eLink = EffectLinkEffects(EffectACIncrease(3, AC_SHIELD_ENCHANTMENT_BONUS), EffectACIncrease(3, AC_ARMOUR_ENCHANTMENT_BONUS));
        myst.eLink = EffectLinkEffects(myst.eLink, EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR));
               
        myst.fDur = 600.0 * myst.nShadowcasterLevel;       
        if(myst.bExtend) myst.fDur *= 2;
        // Duration Effects
        if (myst.bIgnoreSR) myst.eLink = SupernaturalEffect(myst.eLink);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, myst.eLink, oTarget, myst.fDur, TRUE, myst.nMystId, myst.nShadowcasterLevel);               
    }
}