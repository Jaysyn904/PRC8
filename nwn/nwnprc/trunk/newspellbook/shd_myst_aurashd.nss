/*
13/02/19 by Stratovarius

Aura of Shade

Initiate, Elemental Shadows 
Level/School: 4th/Abjuration [Cold] 
Range: Touch 
Target: Creature touched
Duration: 1 round/level 

The environment grows immediately more comfortable as you surround yourself with an aura of protective shadow.

You protect the subject from low temperatures and cold energy with a thin layer of that energy’s shadowy reflection. This absorbs cold damage from attacks and effects. When an aura of shade absorbs a total of 12 points of cold damage per caster level (maximum 120), it expires. For as long as the aura is active, the subject’s weapon or natural weapon melee attacks deal an extra 1d6 points of cold damage. 
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
        int nAmount = PRCMin(120, myst.nShadowcasterLevel * 10);
        myst.eLink = EffectLinkEffects(EffectDamageResistance(DAMAGE_TYPE_COLD, nAmount, nAmount), EffectVisualEffect(VFX_DUR_PROTECTION_ENERGY_COLD));
        myst.eLink = EffectLinkEffects(myst.eLink, EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_COLD));
               
        myst.fDur = 6.0 * myst.nShadowcasterLevel;       
        if(myst.bExtend) myst.fDur *= 2;
        // Duration Effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, myst.eLink, oTarget, myst.fDur, TRUE, myst.nMystId, myst.nShadowcasterLevel);               
    }
}