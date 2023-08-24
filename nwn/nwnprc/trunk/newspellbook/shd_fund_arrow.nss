/*
21/02/19 by Stratovarius

Arrow of Dusk

Fundamental 
Level/School: 1st/Evocation 
Range: Medium (100 ft. + 10 ft./level) 
Effect: Ray 
Duration: Instantaneous 
Saving Throw: None 
Spell Resistance: No

A bolt of shadow springs from your hand, draining vitality where it strikes.

You must succeed on a ranged touch attack to deal 2d4 points of damage to the target.
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"
#include "prc_inc_sp_tch"

void main()
{
    object oShadow      = OBJECT_SELF;
    // Get infinite uses at this level
    if (GetLevelByClass(CLASS_TYPE_SHADOWCASTER, oShadow) >= 14) IncrementRemainingFeatUses(oShadow, 23665);
    if(!ShadPreMystCastCode()) return;

    object oTarget      = PRCGetSpellTargetObject();
    struct mystery myst = EvaluateMystery(oShadow, oTarget, (METASHADOW_EMPOWER | METASHADOW_MAXIMIZE));

    if(myst.bCanMyst)
    {
        SignalEvent(oTarget, EventSpellCastAt(oShadow, myst.nMystId));
        effect eArrow = EffectVisualEffect(VFX_IMP_MIRV_DN_ECTO);
        
        int nAttack = PRCDoRangedTouchAttack(oTarget);
        if (nAttack > 0)
        {
            // Only creatures, and PvP check.
            if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oShadow))
            {
                int nDamage = MetashadowsDamage(myst, 4, 2);
                ApplyTouchAttackDamage(oShadow, oTarget, nAttack, nDamage, DAMAGE_TYPE_MAGICAL);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGPUR), oTarget);
            }
        }
        DelayCommand(0.1, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eArrow, oTarget));
    }
}