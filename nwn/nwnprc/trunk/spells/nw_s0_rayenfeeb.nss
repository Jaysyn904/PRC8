//::///////////////////////////////////////////////
//:: Ray of EnFeeblement
//:: [NW_S0_rayEnfeeb.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Target must make a Fort save or take ability
//:: damage to Strength equaling 1d6 +1 per 2 levels,
//:: to a maximum of +5.  Duration of 1 round per
//:: caster level.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 2, 2001
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff

//::Added hold ray functionality - HackyKid


#include "prc_inc_sp_tch"
#include "prc_add_spell_dc"
#include "prc_sp_func"

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nSaveDC = PRCGetSaveDC(oTarget, oCaster);
    int nPenetr = nCasterLevel + SPGetPenetr();
    int nDuration = nCasterLevel ;
    int nBonus = nDuration / 2;
    //Limit bonus ability damage
    if (nBonus > 5)
    {
        nBonus = 5;
    }
    if(nBonus == 0)
    {
        nBonus = 1;
    }
    int nLoss = d6() + nBonus;
    effect eFeeb;
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    effect eRay;
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    int iAttackRoll = 0;

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RAY_OF_ENFEEBLEMENT));
        eRay = EffectBeam(VFX_BEAM_ODD, OBJECT_SELF, BODY_NODE_HAND);

        // attack roll
        iAttackRoll = PRCDoRangedTouchAttack(oTarget);;
        if(iAttackRoll > 0)
        {
             //Make SR check
             if (!PRCDoResistSpell(OBJECT_SELF, oTarget,nPenetr))
             {

                //Make a Fort save to negate
                if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, PRCGetSaveDC(oTarget, OBJECT_SELF), SAVING_THROW_TYPE_NEGATIVE))
                {
                    //Enter Metamagic conditions
                    if ((nMetaMagic & METAMAGIC_MAXIMIZE))
                    {
                        nLoss = 6 + nBonus;
                    }
                    if ((nMetaMagic & METAMAGIC_EMPOWER))
                    {
                         nLoss = nLoss + (nLoss/2);
                    }
                    if ((nMetaMagic & METAMAGIC_EXTEND))
                    {
                        nDuration = nDuration * 2;
                    }
                    //Set ability damage effect
                    //eFeeb = EffectAbilityDecrease(ABILITY_STRENGTH, nLoss);
                    //effect eLink = EffectLinkEffects(eFeeb, eDur);

                   //Apply the ability damage effect and VFX impact
                    //SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration),TRUE,-1,nCasterLevel);
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFeeb, oTarget, TurnsToSeconds(nDuration),TRUE,-1,nCasterLevel);
                    ApplyAbilityDamage(oTarget, ABILITY_STRENGTH, nLoss, DURATION_TYPE_TEMPORARY, TRUE, TurnsToSeconds(nDuration), TRUE);
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget,0.0f,FALSE);
                }
             }
         }
    }
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.0);

    return iAttackRoll;    //return TRUE if spell charges should be decremented
}

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    PRCSetSchool(GetSpellSchool(PRCGetSpellId()));
    if (!X2PreSpellCastCode()) return;
    object oTarget = PRCGetSpellTargetObject();
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        if (GetLocalInt(oCaster, PRC_SPELL_HOLD) && GetHasFeat(FEAT_EF_HOLD_RAY, oCaster) && oCaster == oTarget)
        {   //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges
            return;
        }
	if (oCaster != oTarget)	//cant target self with this spell, only when holding charge
	        DoSpell(oCaster, oTarget, nCasterLevel, nEvent);
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            if(DoSpell(oCaster, oTarget, nCasterLevel, nEvent))
                DecrementSpellCharges(oCaster);
        }
    }
    PRCSetSchool();
}
