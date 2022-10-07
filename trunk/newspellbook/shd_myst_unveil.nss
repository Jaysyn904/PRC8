/*
16/02/19 by Stratovarius

Unveil

Initiate, Veil of Shadows 
Level/School: 6th/Divination 
Range: Touch 
Target: Creature touched 
Duration: Instantaneous 

Reaching into the shadow of the creature, you grasp the shadows of the deleterious things that affect it and tear them away.

This mystery immediately ends any of the following adverse conditions: ability damage, blinded, confused, dazed, dazzled, deafened, 
diseased, exhausted, fatigued, immobilized, insanity, nauseated, sickened, stunned, and poisoned. In addition, it negates the effects 
of the mysteries mesmerizing shade and shadow hood, and cancels curses as the spell remove curse.
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
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SOUL_TRAP), oTarget);
        
        //Remove Curse and named mysteries
        PRCRemoveEffectsFromSpell(oTarget, MYST_MESMERIZING_SHADE);        
        PRCRemoveEffectsFromSpell(oTarget, FUND_SHADOW_HOOD);
        PRCRemoveEffectsFromSpell(oTarget, SPELL_GHOUL_GAUNTLET);   
        PRCRemoveEffectsFromSpell(oTarget, SPELL_TOUCH_OF_JUIBLEX);   
        PRCRemoveEffectsFromSpell(oTarget, SPELL_EVIL_EYE);           
    
        effect eBad = GetFirstEffect(oTarget);
        //Search for negative effects
        while(GetIsEffectValid(eBad))
        {
            int nInt = GetEffectSpellId(eBad);
            if (GetEffectType(eBad) == EFFECT_TYPE_ABILITY_DECREASE ||
                GetEffectType(eBad) == EFFECT_TYPE_CONFUSED ||
                GetEffectType(eBad) == EFFECT_TYPE_DAZED ||
                GetEffectType(eBad) == EFFECT_TYPE_DISEASE ||
                GetEffectType(eBad) == EFFECT_TYPE_CUTSCENEIMMOBILIZE ||
                GetEffectType(eBad) == EFFECT_TYPE_STUNNED ||
                GetEffectType(eBad) == EFFECT_TYPE_POISON ||
                GetEffectType(eBad) == EFFECT_TYPE_BLINDNESS ||
                GetEffectType(eBad) == EFFECT_TYPE_DEAF ||
                GetEffectType(eBad) == EFFECT_TYPE_CURSE ||
                GetEffectType(eBad) == EFFECT_TYPE_PARALYZE)
                {
                    //Remove effect if it is negative.
                    if(nInt != SPELL_INTUITIVE_ATK)
                    {
                        RemoveEffect(oTarget, eBad);
                    }
                }
            eBad = GetNextEffect(oTarget);
        }             
    }
}