/*
13/02/19 by Stratovarius

Shadow Skin

Apprentice, Shutters and Clouds 
Level/School: 2nd/Abjuration
Range: Personal 
Target: You 
Duration: 1 round

Semisolid shadows rise up and serve as protectors, flickering around you and absorbing some of the damage you might otherwise have taken.

You can cast this mystery as an immediate action. You gain damage reduction according to your caster level.

Caster Level DR 
Up to 4th 5/+1 
5th–9th   10/+1 
10th–14th 10/+2 
15th–19th 15/+2 
20th      15/—
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
        if (myst.nShadowcasterLevel >= 20)
        {
            myst.eLink = EffectLinkEffects(EffectDamageResistance(DAMAGE_TYPE_SLASHING, 15), EffectDamageResistance(DAMAGE_TYPE_PIERCING, 15));
            myst.eLink = EffectLinkEffects(myst.eLink, EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, 15));
        }    
        else if (myst.nShadowcasterLevel >= 15)
            myst.eLink = EffectDamageReduction(15, DAMAGE_POWER_PLUS_TWO);
        else if (myst.nShadowcasterLevel >= 10)
            myst.eLink = EffectDamageReduction(10, DAMAGE_POWER_PLUS_TWO);
        else if (myst.nShadowcasterLevel >= 5)
            myst.eLink = EffectDamageReduction(10, DAMAGE_POWER_PLUS_ONE);
        else 
            myst.eLink = EffectDamageReduction(5, DAMAGE_POWER_PLUS_ONE);           
        
        myst.eLink = EffectLinkEffects(myst.eLink, EffectVisualEffect(PSI_DUR_SHADOW_BODY));
        if (myst.bIgnoreSR) myst.eLink = SupernaturalEffect(myst.eLink);
               
        myst.fDur = 6.0;       
        if(myst.bExtend) myst.fDur *= 2;
        // Duration Effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, myst.eLink, oTarget, myst.fDur, TRUE, myst.nMystId, myst.nShadowcasterLevel);               
    }
}