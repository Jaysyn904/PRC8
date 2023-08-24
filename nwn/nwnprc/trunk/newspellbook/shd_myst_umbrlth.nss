/*
13/02/19 by Stratovarius

Umbral Touch

Apprentice, Touch of  Twilight 
Level/School: 3rd/Conjuration 
Range: Touch 
Target: Creature or creatures touched 
Duration: 1 minute/level (D); see text 
Saving Throw: Fortitude partial
Spell Resistance: Yes

Darkness surrounds your hand, turning it into a deadly weapon.

Umbral touch infuses one of your hands with dark, shadowy energy, allowing you to make debilitating melee touch attacks. A successful strike deals 5d6 points of damage to a 
target, which must succeed on a Fortitude saving throw or also be slowed for one round. You may make one touch attack per caster level.

*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"
#include "prc_inc_sp_tch"
#include "prc_sp_func"

int DoMyst(object oShadow, object oTarget, struct mystery myst)
{
    myst.fDur = RoundsToSeconds(1);
    if(myst.bExtend) myst.fDur *= 2;   
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
                int nDamage = MetashadowsDamage(myst, 6, 5);
                ApplyTouchAttackDamage(oShadow, oTarget, nAttack, nDamage, DAMAGE_TYPE_MAGICAL);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY), oTarget);
                
                if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, GetShadowcasterDC(oShadow), SAVING_THROW_TYPE_SPELL))
                {
                    myst.eLink = EffectSlow();
                    if (myst.bIgnoreSR) myst.eLink = SupernaturalEffect(myst.eLink);
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, myst.eLink, oTarget, myst.fDur, TRUE, myst.nMystId, myst.nShadowcasterLevel);               
                }
            }    
        }
    }
    
    return nAttack;
}

void main()
{
    if(!ShadPreMystCastCode()) return;
    object oShadow = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    struct mystery myst;
    int nEvent = GetLocalInt(oShadow, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        myst = EvaluateMystery(oShadow, oTarget, (METASHADOW_EXTEND | METASHADOW_EMPOWER | METASHADOW_MAXIMIZE));

        if(myst.bCanMyst)
        {
            if(GetLocalInt(oShadow, PRC_SPELL_HOLD) && oShadow == oTarget)
            {   //holding the charge, mystesting power on self
                SetLocalSpellVariables(oShadow, myst.nShadowcasterLevel);   //change 1 to number of charges
                SetLocalMystery(oShadow, MYST_HOLD_MYST+"5", myst);
                return;
            }
            DoMyst(oShadow, oTarget, myst);
        }
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            myst = GetLocalMystery(oShadow, MYST_HOLD_MYST+"5");
            if(DoMyst(oShadow, oTarget, myst))
                DecrementSpellCharges(oShadow);
        }
    }
}