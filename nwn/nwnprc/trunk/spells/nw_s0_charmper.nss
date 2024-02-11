//::///////////////////////////////////////////////
//:: [Charm Person]
//:: [NW_S0_CharmPer.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Will save or the target is charmed for 1 round
//:: per caster level.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 29, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 5, 2001
//:: Last Updated By: Preston Watamaniuk, On: April 10, 2001
//:: VFX Pass By: Preston W, On: June 20, 2001


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
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nCasterLvl = PRCGetCasterLevel(oCaster);
    int nPenetr = nCasterLvl + SPGetPenetr();
    int nDuration = 2 + nCasterLvl/3;
    nDuration = PRCGetScaledDuration(nDuration, oTarget);

    //Make Metamagic check for extend
    if(nMetaMagic & METAMAGIC_EXTEND)
        nDuration = nDuration * 2;

    effect eVis = EffectVisualEffect(VFX_IMP_CHARM);
    effect eCharm = EffectCharmed();
           eCharm = PRCGetScaledEffect(eCharm, oTarget);
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    //Link persistant effects
    effect eLink = EffectLinkEffects(eMind, eCharm);
           eLink = EffectLinkEffects(eLink, eDur);

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_CHARM_PERSON, FALSE));
        //Make SR Check
        if (!PRCDoResistSpell(oCaster, oTarget, nPenetr))
        {
            //Verify that the Racial Type is humanoid
            if(PRCAmIAHumanoid(oTarget))
            {
                //Make a Will Save check
                if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, PRCGetSaveDC(oTarget, oCaster), SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    //Apply impact and linked effects
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration), TRUE, SPELL_CHARM_PERSON, nCasterLvl);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }
            }
        }
    }
    PRCSetSchool();
}
