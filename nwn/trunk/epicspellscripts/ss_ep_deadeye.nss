//:://////////////////////////////////////////////
//:: FileName: "ss_ep_deadeye"
/*   Purpose: Deadeye Sense - Increases the target's AB by +20 for 20 hours.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 11, 2004
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "inc_epicspells"

void main()
{
    if (!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);

    object oCaster = OBJECT_SELF;
    if(GetCanCastSpell(oCaster, SPELL_EPIC_DEADEYE))
    {
        object oTarget = PRCGetSpellTargetObject();
        int nCasterLvl = GetTotalCastingLevel(oCaster);
        int nDuration = nCasterLvl / 4;
        if(nDuration < 5)
        nDuration = 5;

        effect eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eAttack = EffectAttackIncrease(20);
        effect eLink = EffectLinkEffects(eAttack, eDur);

        effect eImpact = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);

        if(GetIsReactionTypeFriendly(oTarget) || GetFactionEqual(oTarget))
        {
            float fDelay = PRCGetRandomDelay(0.4, 1.1);
            //Fire spell cast at event for target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_BLESS, FALSE));
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration), TRUE, -1, nCasterLvl));
        }
    }
    PRCSetSchool();
}