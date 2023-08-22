/*
18/02/19 by Stratovarius

Shadow Surge

Master, Heart and Soul 
Level/School: 9th/Enchantment (Compulsion) [Mind Affecting] 
Range: Close (25 ft. + 5 ft./2 levels) 
Target: Up to one living creature/level, no two of which are more than 30 ft. apart 
Duration: 1 round 
Saving Throw: Will negates 
Spell Resistance: Yes

You send the nearby souls plummeting into darkness, leaving their bodies empty  vessels that follow your will.

This mystery functions like the spell dominate monster, except as noted above.
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
        myst.nPen = ShadowSRPen(oShadow, myst.nShadowcasterLevel);
        myst.fDur = 9.0;
        if(myst.bExtend) myst.fDur += 6.0;        
        
        effect eImplode= EffectVisualEffect(VFX_IMP_SOUND_SYMBOL_INSANITY);
        //Apply the implode effect
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImplode, PRCGetSpellTargetLocation());
        int nCount = 0;
        //Get the first target in the shape
        oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, PRCGetSpellTargetLocation());
        while (GetIsObjectValid(oTarget) && 11 > nCount)
        {
            if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oShadow))
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
                nCount++; //Only count living creatures
            }
            //Get next target in the shape
            oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, PRCGetSpellTargetLocation());
        }
    }
}