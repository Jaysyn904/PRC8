/*
13/02/19 by Stratovarius

Thoughts of Shadow

Apprentice, Umbral Mind 
Level/School: 2nd/Transmutation 
Range: Touch 
Target: Creature touched 
Duration: 1 minute/level
Saving Throw: None
Spell Resistance: No

You open the subject’s mind to shadow, and the new perceptions it offers.

You grant the subject a +4 enhancement bonus to Intelligence, Wisdom, or Charisma. You decide which ability you are enhancing when you cast the mystery, and you may not later alter your choice
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
        effect eVis;
        if (myst.nMystId == MYST_THOUGHTS_SHADOW_INT)
        {
            myst.eLink = EffectAbilityIncrease(ABILITY_INTELLIGENCE, 4);
            eVis = EffectVisualEffect(VFX_IMP_BONUS_INTELLIGENCE);
        }    
        else if (myst.nMystId == MYST_THOUGHTS_SHADOW_WIS)
        {
            myst.eLink = EffectAbilityIncrease(ABILITY_WISDOM, 4);
            eVis = EffectVisualEffect(VFX_IMP_BONUS_WISDOM);
        } 
        else 
        {
            myst.eLink = EffectAbilityIncrease(ABILITY_CHARISMA, 4);
            eVis = EffectVisualEffect(VFX_IMP_BONUS_CHARISMA);
        }         
        
        myst.eLink = EffectLinkEffects(myst.eLink, EffectVisualEffect(VFX_DUR_PROT_PRC_SHADOW_ARMOR));
               
        myst.fDur = 60.0 * myst.nShadowcasterLevel;       
        if(myst.bExtend) myst.fDur *= 2;
        // Duration Effects
        if (myst.bIgnoreSR) myst.eLink = SupernaturalEffect(myst.eLink);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, myst.eLink, oTarget, myst.fDur, TRUE, myst.nMystId, myst.nShadowcasterLevel);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
}