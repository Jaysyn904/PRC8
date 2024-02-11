//::///////////////////////////////////////////////
//:: Name      All Seeing Eyes
//:: FileName  inv_allseeeye.nss
//::///////////////////////////////////////////////
/*

Least Invocation
2nd Level Spell

You gain a supernaturally precise view of the world
around you. This grants you +6 to search and spot
checks. This invocation lasts for 24 hours.

*/
//::///////////////////////////////////////////////

#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    if(!PreInvocationCastCode()) return;

    //Declare major variables
    int CasterLvl = GetInvokerLevel(OBJECT_SELF, GetInvokingClass());
    object oTarget = PRCGetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eSkill = EffectSkillIncrease(SKILL_SEARCH, 6);
    effect eSkill1 = EffectSkillIncrease(SKILL_SPOT, 6);
    effect eLink = EffectLinkEffects(eSkill, eSkill1);
           eLink = EffectLinkEffects(eLink, eDur);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, INVOKE_ALL_SEEING_EYES, FALSE));

    //Apply the VFX impact and effect
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(24), TRUE, -1, CasterLvl);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}