//::///////////////////////////////////////////////
//:: Name      Beguiling Influence
//:: FileName  inv_dra_beglinf.nss
//::///////////////////////////////////////////////
/*

Least Invocation
2nd Level Spell

You can invoke this ability to beguile and bewitch
your foe. You gain a +6 to Bluff, Persuade, and
Intimidate checks for 24 hours.

*/
//::///////////////////////////////////////////////

#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    if (!PreInvocationCastCode()) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int CasterLvl = GetInvokerLevel(oCaster, GetInvokingClass());
    int nSkillBonus = GetHasFeat(FEAT_MORPHEME_SAVANT) ? max(GetAbilityModifier(ABILITY_CHARISMA, oCaster) * 2, 6) : 6;
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eSkill = EffectSkillIncrease(SKILL_BLUFF, nSkillBonus);
    effect eSkill1 = EffectSkillIncrease(SKILL_INTIMIDATE, nSkillBonus);
    effect eSkill2 = EffectSkillIncrease(SKILL_PERSUADE, nSkillBonus);
    effect eLink = EffectLinkEffects(eSkill, eSkill1);
           eLink = EffectLinkEffects(eLink, eSkill2);
           eLink = EffectLinkEffects(eLink, eDur);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(oCaster, INVOKE_BEGUILING_INFLUENCE, FALSE));

    //Apply the VFX impact and effect
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(24), TRUE, -1, CasterLvl);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}