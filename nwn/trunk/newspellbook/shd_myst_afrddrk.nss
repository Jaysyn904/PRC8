/*
13/02/19 by Stratovarius

Afraid of the Dark

Apprentice, Umbral Mind 
Level/School: 3rd/Illusion (Mind-Affecting, Shadow)
Range: Medium (100 ft. + 10 ft./level) 
Target: One living creature 
Duration: Instantaneous 
Saving Throw: Will half 
Spell Resistance: Yes

A shadowy image of your foe appears before him and reaches out to clutch him before vanishing.

You draw forth a twisted reflection of your foe from the Plane of Shadow. The image unerringly touches the subject, causing Wisdom damage equal to 1d6 points +1 point per four caster levels (maximum +5). A Will saving throw halves the Wisdom damage.
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"
#include "prc_inc_sp_tch"

void main()
{
    if(!ShadPreMystCastCode()) return;

    object oShadow      = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    struct mystery myst = EvaluateMystery(oShadow, oTarget, (METASHADOW_EMPOWER | METASHADOW_MAXIMIZE));

    if(myst.bCanMyst)
    {
        myst.nPen = ShadowSRPen(oShadow, myst.nShadowcasterLevel);
        
        SignalEvent(oTarget, EventSpellCastAt(oShadow, myst.nMystId));
        
        // Only creatures, and PvP check.
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            // Check Spell Resistance
            if(!PRCDoResistSpell(oShadow, oTarget, myst.nPen) || myst.bIgnoreSR)
            {   
                int nDam = MetashadowsDamage(myst, 6, 1, min(5, myst.nShadowcasterLevel/4));
                if (PRCMySavingThrow(SAVING_THROW_WILL, oTarget, GetShadowcasterDC(oShadow), SAVING_THROW_TYPE_MIND_SPELLS))
                    nDam/2;
                    
                ApplyAbilityDamage(oTarget, ABILITY_WISDOM, nDam, DURATION_TYPE_PERMANENT, TRUE);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DISENTIGRATION_SMP), oTarget);             
            }    
        }
    }
}