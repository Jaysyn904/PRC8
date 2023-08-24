//::///////////////////////////////////////////////
//:: Name      Draconic Knowledge
//:: FileName  inv_dra_dracknow.nss
//::///////////////////////////////////////////////
/*

Least Invocation
2nd Level Spell

This invocation grants you access to the great
ancestral memories of dragonkind. You gain a +6
bonus to Spellcraft and Lore for 24 hours.

*/
//::///////////////////////////////////////////////

#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    if(!PreInvocationCastCode()) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int CasterLvl = GetInvokerLevel(oCaster, GetInvokingClass());
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eSkill = EffectSkillIncrease(SKILL_SPELLCRAFT, 6);
    effect eSkill1 = EffectSkillIncrease(SKILL_LORE, 6);
    effect eLink = EffectLinkEffects(eSkill, eSkill1);
           eLink = EffectLinkEffects(eLink, eDur);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(oCaster, INVOKE_DRACONIC_KNOWLEDGE, FALSE));

    //Apply the VFX impact and effect
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(24),TRUE,-1,CasterLvl);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}