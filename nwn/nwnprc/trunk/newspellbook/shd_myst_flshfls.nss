/*
13/02/19 by Stratovarius

Flesh Fails

Apprentice, Touch of Twilight 
Level/School: 2nd/Necromancy 
Range: Touch 
Target: Living creature touched 
Duration: Instantaneous 
Saving Throw: None 
Spell Resistance: Yes

You open your enemy to the darkness, trading his physical attributes for weaker abilities belonging to creatures of shadow.

You deal either 4 points of Strength damage, 4 points of Dexterity damage, or 2 points of Constitution damage to the subject; you choose which kind of ability damage when you cast the mystery.
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"
#include "prc_inc_sp_tch"

void main()
{
    if(!ShadPreMystCastCode()) return;

    object oShadow      = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    struct mystery myst = EvaluateMystery(oShadow, oTarget, METASHADOW_NONE);

    if(myst.bCanMyst)
    {
        myst.nPen = ShadowSRPen(oShadow, myst.nShadowcasterLevel);
        
        SignalEvent(oTarget, EventSpellCastAt(oShadow, myst.nMystId));
        
        int nAttack = PRCDoMeleeTouchAttack(oTarget);
        if (nAttack > 0)
        {
            // Only creatures, and PvP check.
            if(!GetIsReactionTypeFriendly(oTarget))
            {
                // Check Spell Resistance
                if(!PRCDoResistSpell(oShadow, oTarget, myst.nPen) || myst.bIgnoreSR)
                {   
                    int nAbil = ABILITY_STRENGTH;
                    int nDam = 4;
                    if (myst.nMystId == MYST_FLESH_FAILS_DEX)
                        nAbil = ABILITY_DEXTERITY;
                    else if (myst.nMystId == MYST_FLESH_FAILS_CON)
                    {
                        nAbil = ABILITY_CONSTITUTION;
                        nDam = 2;
                    }    

                    ApplyAbilityDamage(oTarget, nAbil, nDam, DURATION_TYPE_PERMANENT, TRUE);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DISENTIGRATION_SMP), oTarget);
                }    
            }
        }
    }
}