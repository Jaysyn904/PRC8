/*::///////////////////////////////////////////////
//:: [Daze]
//:: [NW_S0_Daze.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 15, 2001
//:: Update Pass By: Preston W, On: July 27, 2001
//:: modified by mr_bumpkin Dec 4, 2003
//:: modified by xwarren Jul 22, 2010
//:://////////////////////////////////////////////
//::
//:: Daze
//::
//:: Enchantment (Compulsion) [Mind-Affecting]
//:: Level: Brd 0, Sor/Wiz 0
//:: Components: V, S, M
//:: Casting Time: 1 standard action
//:: Range: Close (25 ft. + 5 ft./2 levels)
//:: Target: One humanoid creature of 4 HD or less
//:: Duration: 1 round
//:: Saving Throw: Will negates
//:: Spell Resistance: Yes
//::
//:: This enchantment clouds the mind of a humanoid
//:: creature with 4 or fewer Hit Dice so that it
//:: takes no actions. Humanoids of 5 or more HD are
//:: not affected. A dazed subject is not stunned,
//:: so attackers get no special advantage against it.
//::
//:: Material Component
//:: A pinch of wool or similar substance.
//::
//:://////////////////////////////////////////////
//::
//:: Daze Monster
//::
//:: Enchantment (Compulsion) [Mind-Affecting]
//:: Level: Beguiler 2, Brd 2, Sor/Wiz 2
//:: Components: V, S, M
//:: Casting Time: 1 standard action
//:: Range: Medium (100 ft. + 10 ft./level)
//:: Target: One living creature of 6 HD or less
//:: Duration: 1 round
//:: Saving Throw: Will negates
//:: Spell Resistance: Yes
//::
//:: This enchantment clouds the mind of
//:: a living creature with 6 or fewer Hit
//:: Dice so that it takes no actions. Creatures
//:: of 7 or more HD are not affected. A dazed
//:: subject is not stunned, so attackers get no
//:: special advantage against it.
//::
//:: Material Component
//:: A pinch of wool or similar substance.
//::
//::////////////////////////////////////////////*/

#include "prc_inc_spells"
#include "prc_add_spell_dc"
#include "prc_sp_func"

int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    //Declare major variables
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDaze = EffectDazed();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    effect eLink = EffectLinkEffects(eMind, eDaze);
    eLink = EffectLinkEffects(eLink, eDur);

    effect eVis = EffectVisualEffect(VFX_IMP_DAZED_S);
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nDuration = 2;
    //check meta magic for extend
    if ((nMetaMagic & METAMAGIC_EXTEND))
    {
        nDuration = 4;
    }
    int nSpellID = GetSpellId();
    int nMaxHD = nSpellID == SPELL_DAZE ? 4 : 6;
    int nPenetr = nCasterLevel + SPGetPenetr();

    //Make sure the target of Daze spell is a humaniod
    if(nSpellID == SPELL_DAZE && PRCAmIAHumanoid(oTarget) != TRUE)
        return TRUE;
    //Make sure the target of Daze Monster spell is a living creature
    if(nSpellID == SPELL_DAZE_MONSTER && PRCGetIsAliveCreature(oTarget) != TRUE)
        return TRUE;
    if(GetHitDice(oTarget) <= nMaxHD)
    {
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID));
           //Make SR check
           if (!PRCDoResistSpell(oCaster, oTarget,nPenetr))
           {
                //Make Will Save to negate effect
                if (!/*Will Save*/ PRCMySavingThrow(SAVING_THROW_WILL, oTarget, PRCGetSaveDC(oTarget, oCaster), SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    //Apply VFX Impact and daze effect
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration),TRUE,-1,nCasterLevel);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }
            }
        }
    }
    return TRUE;    //return TRUE if spell charges should be decremented
}

void main()
{
    PRCSetSchool(SPELL_SCHOOL_ENCHANTMENT);
    if (!X2PreSpellCastCode()) return;
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    object oTarget = PRCGetSpellTargetObject();
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)
        {   //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges
            return;
        }
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