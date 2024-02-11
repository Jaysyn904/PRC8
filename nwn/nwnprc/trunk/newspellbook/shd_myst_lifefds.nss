/*
12/02/19 by Stratovarius

Life Fades

Apprentice, Touch of Twilight 
Level/School: 1st/Necromancy 
Range: Touch 
Target: Creature touched 
Duration: Instantaneous 
Saving Throw: Fortitude partial 
Spell Resistance: Yes

A wave of darkness washes over the subject, sapping his energy into the Plane of Shadow.

Your touch deals 1d6 points of damage per caster level (maximum 5d6) and causes the subject to become fatigued for 1 round per caster level (a Fortitude save negates the fatigue). 
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"
#include "prc_inc_sp_tch"

void main()
{
    if(!ShadPreMystCastCode()) return;

    object oShadow      = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    struct mystery myst = EvaluateMystery(oShadow, oTarget, (METASHADOW_EXTEND | METASHADOW_EMPOWER | METASHADOW_MAXIMIZE));

    if(myst.bCanMyst)
    {
        int nDie = min(myst.nShadowcasterLevel, 5);
        myst.fDur = RoundsToSeconds(myst.nShadowcasterLevel);
        if(myst.bExtend) myst.fDur *= 2;   
        myst.nPen = ShadowSRPen(oShadow, myst.nShadowcasterLevel);
        
        SignalEvent(oTarget, EventSpellCastAt(oShadow, MYST_LIFE_FADES));
        
        int nAttack = PRCDoMeleeTouchAttack(oTarget);
        if (nAttack > 0)
        {
            // Only creatures, and PvP check.
            if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oShadow))
            {
                // Check Spell Resistance
                if(!PRCDoResistSpell(oShadow, oTarget, myst.nPen) || myst.bIgnoreSR)
                {                
                    int nDamage = MetashadowsDamage(myst, 6, nDie);
                    ApplyTouchAttackDamage(oShadow, oTarget, nAttack, nDamage, DAMAGE_TYPE_MAGICAL);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY), oTarget);
                    
                    if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, GetShadowcasterDC(oShadow), SAVING_THROW_TYPE_SPELL))
                    {
                        myst.eLink = EffectFatigue();
                        if (myst.bIgnoreSR) myst.eLink = SupernaturalEffect(myst.eLink);
                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, myst.eLink, oTarget, myst.fDur, TRUE, myst.nMystId, myst.nShadowcasterLevel);               
                    }
                }    
            }
        }
    }
}