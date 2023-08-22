/*
14/02/19 by Stratovarius

Shadow Vision

Initiate, Veil of Shadows 
Level/School: 4th/Transmutation 
Range: Medium (100 ft. + 10 ft./level)
Target: One creature with an Intelligence of 3 or higher 
Duration: 1 round/level 
Saving Throw: Will negates 
Spell Resistance: Yes

The subject’s vision overlaps the Plane of Shadow, causing him to see flickering images, areas of darkness, and other  visual discrepancies  with the material world.

You impede the subject’s vision and its ability to determine what’s happening around it. The subject takes a –4 penalty on attack rolls, saves, and skill checks. In addition, you have total concealment with respect to the subject.
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"
#include "prc_inc_sp_tch"

void main()
{
    if(!ShadPreMystCastCode()) return;

    object oShadow      = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    struct mystery myst = EvaluateMystery(oShadow, oTarget, METASHADOW_EXTEND);

    if(myst.bCanMyst)
    {
        myst.nPen = ShadowSRPen(oShadow, myst.nShadowcasterLevel);
        
        SignalEvent(oTarget, EventSpellCastAt(oShadow, myst.nMystId));
        
        // Only creatures, and PvP check.
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            // Check Spell Resistance
            if(!PRCDoResistSpell(oShadow, oTarget, myst.nPen))
            {   
                if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, GetShadowcasterDC(oShadow), SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    myst.fDur = 6.0 * myst.nShadowcasterLevel;       
                    if(myst.bExtend) myst.fDur *= 2;
                    
                    myst.eLink = EffectLinkEffects(EffectMissChance(50), EffectAttackDecrease(4));
                    myst.eLink = EffectLinkEffects(myst.eLink, EffectSavingThrowDecrease(SAVING_THROW_ALL, 4));
                    myst.eLink = EffectLinkEffects(myst.eLink, EffectSkillDecrease(SKILL_ALL_SKILLS, 4));
                    myst.eLink = EffectLinkEffects(myst.eLink, EffectVisualEffect(VFX_DUR_BRIGHT_LIGHT_INDIGO_PULSE_SLOW));
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, myst.eLink, oTarget, myst.fDur, TRUE, myst.nMystId, myst.nShadowcasterLevel);  
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BLINDDEAD_DN_PURPLE), oTarget);             
                }    
            }    
        }
    }
}