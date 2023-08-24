//::///////////////////////////////////////////////
//:: Feeblemind
//:: [NW_S0_FeebMind.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Target must make a Will save or take ability
//:: damage to Intelligence equaling 1d4 per 4 levels.
//:: Duration of 1 rounds per 2 levels.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 2, 2001
//:://////////////////////////////////////////////
//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_DIVINATION);

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int CasterLvl = PRCGetCasterLevel(oCaster);
    int nPenetr = CasterLvl + SPGetPenetr();
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nDuration = CasterLvl/2;
    int nDice = CasterLvl/4;

    if(nMetaMagic & METAMAGIC_EXTEND)
       nDuration *= 2;

    //effect eFeeb;
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    effect eRay = EffectBeam(VFX_BEAM_MIND, oCaster, BODY_NODE_HAND);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_FEEBLEMIND));
        //bug fix - apply the ray effect first, than check SR
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.0, FALSE);
        //Make SR check
        if(!PRCDoResistSpell(oCaster, oTarget, nPenetr))
        {
            //Make an will save
            int nDC = PRCGetSaveDC(oTarget, oCaster);
            if (GetLevelByTypeArcane(oTarget) > 0) nDC += 4;
            int nWillResult =  WillSave(oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS);
            if(nWillResult == 0)
            {
                int nLoss = GetAbilityScore(oTarget, ABILITY_INTELLIGENCE) - 1;
                ApplyAbilityDamage(oTarget, ABILITY_INTELLIGENCE, nLoss, DURATION_TYPE_PERMANENT, FALSE);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
            else
            // * target was immune
            if(nWillResult == 2)
            {
                SendMessageToPCByStrRef(oCaster, 40105);
            }
        }
    }
    PRCSetSchool();
}