//::///////////////////////////////////////////////
//:: [Charm Monster]
//:: [NW_S0_CharmMon.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Will save or the target is charmed for 1 round
//:: per 2 caster levels.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 29, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: July 25, 2001
//:: modified by mr_bumpkin Dec 4, 2003

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    if (!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_ENCHANTMENT);

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int CasterLvl = PRCGetCasterLevel(oCaster);
    int nPenetr = CasterLvl + SPGetPenetr();
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nDuration = 3 + CasterLvl/2;
    nDuration = PRCGetScaledDuration(nDuration, oTarget);
    //Metamagic extend check
    if(nMetaMagic & METAMAGIC_EXTEND)
        nDuration *= 2;

    effect eVis   = EffectVisualEffect(VFX_IMP_CHARM);
    effect eCharm = EffectCharmed();
           eCharm = PRCGetScaledEffect(eCharm, oTarget);
    effect eMind  = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDur   = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    //Link effects
    effect eLink  = EffectLinkEffects(eMind, eCharm);
           eLink  = EffectLinkEffects(eLink, eDur);

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_CHARM_MONSTER, FALSE));
        // Make SR Check
        if (!PRCDoResistSpell(oCaster, oTarget, nPenetr))
        {
            // Make Will save vs Mind-Affecting
            if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, PRCGetSaveDC(oTarget, oCaster), SAVING_THROW_TYPE_MIND_SPELLS))
            {
                //Apply impact and linked effect
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration), TRUE, SPELL_CHARM_MONSTER, CasterLvl);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
    }
    PRCSetSchool();
}
