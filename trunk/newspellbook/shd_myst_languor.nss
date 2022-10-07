/*
16/02/19 by Stratovarius

Languor

Initiate, Body and Soul 
Level/School: 5th/Enchantment (Compulsion) 
Range: Close (25 ft. + 5 ft./2 levels) 
Target: One creature or one creature/level, no two of which are more than 30 ft. apart; see text 
Duration: 1 round/2 levels 
Saving Throw: Will negates 
Spell Resistance: Yes

You channel shadowstuff into the subject’s shadow, literally weighing him down under its weight.

Languor functions like either the spell slow or the spell hold monster. You choose which version you want before the effect begins. If you choose hold monster, the mystery can affect only one subject.
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
        location lTarget = PRCGetSpellTargetLocation();
        myst.fDur = 6.0 * myst.nShadowcasterLevel/2;
        if(myst.bExtend) myst.fDur *= 2; 
        effect eVis = EffectVisualEffect(VFX_FNF_FEEBLEMIND);
        int nCount = 0;
        myst.nPen = ShadowSRPen(oShadow, myst.nShadowcasterLevel);
        
        if (myst.nMystId == MYST_LANGUOR_SLOW)
        {
            oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget);
            //Cycle through the targets within the spell shape until an invalid object is captured or the number of
            //targets affected is equal to the caster level.
            while(GetIsObjectValid(oTarget) && nCount < myst.nShadowcasterLevel)
            {
                if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oShadow))
                {
                    //Fire cast spell at event for the specified target
                    SignalEvent(oTarget, EventSpellCastAt(oShadow, myst.nMystId));
                    if (!PRCDoResistSpell(oShadow, oTarget, myst.nPen) && !/*Will Save*/ PRCMySavingThrow(SAVING_THROW_WILL, oTarget, GetShadowcasterDC(oShadow)))
                    {
                        //Apply the slow effect and VFX impact
                        myst.eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_TEMPORAL_STASIS), EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
                        myst.eLink = EffectLinkEffects(myst.eLink, EffectSlow());                        
                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, myst.eLink, oTarget, myst.fDur, TRUE, myst.nMystId, myst.nShadowcasterLevel);  
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                        //Count the number of creatures affected
                        nCount++;
                    }
                }
                //Select the next target within the spell shape.
                oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget);
            }           
        }
        else // Hold
        {
            // Only creatures, and PvP check.
            if(!GetIsReactionTypeFriendly(oTarget))
            {
                // Check Spell Resistance
                if(!PRCDoResistSpell(oShadow, oTarget, myst.nPen))
                { 
                    if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, GetShadowcasterDC(oShadow), SAVING_THROW_TYPE_MIND_SPELLS))
                    {
                        myst.eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_PARALYZE_HOLD), EffectVisualEffect(VFX_DUR_PARALYZED));
                        myst.eLink = EffectLinkEffects(myst.eLink, EffectParalyze());
                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, myst.eLink, oTarget, myst.fDur, TRUE, myst.nMystId, myst.nShadowcasterLevel);  
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    }
                }
            }    
        }    
    }
}