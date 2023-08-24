
#include "prc_inc_spells"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{

    if (!PreInvocationCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }


    //Declare major variables
    int CasterLvl = GetInvokerLevel(OBJECT_SELF, GetInvokingClass());
    object oTarget = PRCGetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eSkill = EffectSkillIncrease(SKILL_LORE, 6);
    effect eLink = EffectLinkEffects(eSkill, eDur);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, INVOKE_OTHERWORLDLY_WHISPERS, FALSE));

    //Apply the VFX impact and effect
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(24),TRUE,-1,CasterLvl);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

}
