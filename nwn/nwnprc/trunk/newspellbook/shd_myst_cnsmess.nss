/*
18/02/19 by Stratovarius

Consume Essence

Master, Ebon Walls 
Level/School: 9th/Necromancy [Death] 
Range: Touch 
Target: One living creature 
Duration: Instantaneous, then 1 round/level 
Saving Throw: Will negates 
Spell Resistance: Yes

You reach out and peel the subject’s shadow away, then wrap it inside your own.

The target of this horrid mystery must succeed on a Will saving throw or die. If the creature succumbs to the mystery and dies, 
it immediately returns to life, gains the dark creature template, and is under your control. The creature remains in this state for 1 round per level, and then dies again.
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"
#include "prc_inc_template"

void main()
{
    if(!ShadPreMystCastCode()) return;

    object oShadow      = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    struct mystery myst = EvaluateMystery(oShadow, oTarget, METASHADOW_EXTEND);

    if(myst.bCanMyst)
    {
        myst.fDur = 6.0 * myst.nShadowcasterLevel;
        if(myst.bExtend) myst.fDur *= 2;
        myst.nPen = ShadowSRPen(oShadow, myst.nShadowcasterLevel);

        // Only creatures, and PvP check.
        if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oShadow))
        {
            // Check Spell Resistance
            if(!PRCDoResistSpell(oShadow, oTarget, myst.nPen))
            {                
                if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, GetShadowcasterDC(oShadow), SAVING_THROW_TYPE_DEATH))
                {
                    // Death Immunity check
                    if(!GetIsImmune(oTarget, IMMUNITY_TYPE_DEATH))
                    {                    
                        myst.eLink = EffectLinkEffects(EffectCutsceneDominated(), EffectVisualEffect(VFX_DUR_DEATHWARD));
                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, myst.eLink, oTarget, myst.fDur, TRUE, myst.nMystId, myst.nShadowcasterLevel);   
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DOMINATE_S), oTarget);
                        
                        ApplyTemplateToObject(TEMPLATE_DARK, oTarget);
                        
                        DelayCommand(myst.fDur, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget));
                    }
                }
            }    
        }
    }
}