/*
12/02/19 by Stratovarius

Mesmerizing Shade

Apprentice, Umbral Mind
Level/School: 1st/Enchantment (Compulsion) [MindAffecting]
Range: Close
Target: One creature
Duration: 1 round 
Saving Throw: Will partial 
Spell Resistance: Yes

Shadows flicker before the eyes and in the mind of the subject creature, which suddenly seems to be disoriented.

Shadow flickers around the subject, distracting and dazing him. The subject can avoid the daze effect with a successful Will saving throw, but still takes a –1 penalty on attack rolls, checks, and saves.

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
        myst.fDur = RoundsToSeconds(1);
        if(myst.bExtend) myst.fDur *= 2;   

        effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
        effect eDaze = EffectDazed();
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
        myst.eLink = EffectLinkEffects(eMind, eDaze);
        myst.eLink = EffectLinkEffects(myst.eLink, eDur);
        effect eVis = EffectVisualEffect(VFX_IMP_DAZED_S);  
        myst.nPen = ShadowSRPen(oShadow, myst.nShadowcasterLevel);
        
        SignalEvent(oTarget, EventSpellCastAt(oShadow, MYST_MESMERIZING_SHADE));
        
        // Only creatures, and PvP check.
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            // Check Spell Resistance
            if(!PRCDoResistSpell(oShadow, oTarget, myst.nPen) || myst.bIgnoreSR)
            {        
                if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, GetShadowcasterDC(oShadow), SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    if (myst.bIgnoreSR) myst.eLink = SupernaturalEffect(myst.eLink);
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, myst.eLink, oTarget, myst.fDur, TRUE, myst.nMystId, myst.nShadowcasterLevel);   
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }
                else
                {
                    myst.eLink = EffectLinkEffects(EffectAttackDecrease(1), EffectSkillDecrease(SKILL_ALL_SKILLS, 1));
                    myst.eLink = EffectLinkEffects(myst.eLink, EffectSavingThrowDecrease(SAVING_THROW_ALL, 1));
                    myst.eLink = EffectLinkEffects(myst.eLink, eDur);
                    if (myst.bIgnoreSR) myst.eLink = SupernaturalEffect(myst.eLink);
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, myst.eLink, oTarget, myst.fDur, TRUE, myst.nMystId, myst.nShadowcasterLevel);   
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);                
                }
            }    
        }
    }
}