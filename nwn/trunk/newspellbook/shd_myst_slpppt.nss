/*
18/02/19 by Stratovarius

Soul Puppet

Master, Heart and Soul 
Level/School: 8th/Enchantment (Compulsion) [Mind Affecting] 
Range: Touch 
Target: One living creature touched 
Duration: 1 day/level (D) 
Saving Throw: Will negates 
Spell Resistance: Yes

Tendrils of shadow creep from your fingers, through the Plane of Shadow, and into the soul of the subject by way of its own shadow. You now control the creature’s actions as if it were a puppet.

The control granted by soul puppet follows the same mechanics as the spell dominate monster
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
        myst.fDur = 60.0 * myst.nShadowcasterLevel;
        if(myst.bExtend) myst.fDur *= 2;
        myst.nPen = ShadowSRPen(oShadow, myst.nShadowcasterLevel);

        // Only creatures, and PvP check.
        if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oShadow))
        {
            // Check Spell Resistance
            if(!PRCDoResistSpell(oShadow, oTarget, myst.nPen))
            {                
                if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, GetShadowcasterDC(oShadow), SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    // Extra domination immunity check - using EffectCutsceneDominated(), which normally bypasses
                    if(!GetIsImmune(oTarget, IMMUNITY_TYPE_DOMINATE) && !GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS))
                    {                    
                        myst.eLink = EffectLinkEffects(EffectCutsceneDominated(), EffectVisualEffect(VFX_DUR_DEATHWARD));
                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, myst.eLink, oTarget, myst.fDur, TRUE, myst.nMystId, myst.nShadowcasterLevel);   
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DOMINATE_S), oTarget);
                    }
                }
            }    
        }
    }
}