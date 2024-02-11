//::///////////////////////////////////////////////
//:: Name      Voidsense
//:: FileName  inv_dra_voidsnse.nss
//::///////////////////////////////////////////////
/*

Lesser Invocation
4th Level Spell

You sharpen your hearing and sight, gaining
blindsense for 24 hours.

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
    object oSkin = GetPCSkin(oTarget);
    float fDuration = HoursToSeconds(24);
    effect eVis = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eSight = EffectSeeInvisible();
    effect eSight2 = EffectUltravision();
    //blindsense allows noticing of hidden characters without spot/listen checks
    effect eSight3 = EffectSkillIncrease(SKILL_LISTEN, 80);
    effect eSight4 = EffectSkillIncrease(SKILL_SPOT, 80);
    effect eLink = EffectLinkEffects(eVis, eSight);
    eLink = EffectLinkEffects(eLink, eSight2);
    eLink = EffectLinkEffects(eLink, eSight3);
    eLink = EffectLinkEffects(eLink, eSight4);
    eLink = EffectLinkEffects(eLink, eDur);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(oCaster, INVOKE_VOIDSENSE, FALSE));
    int CasterLvl = GetInvokerLevel(oCaster, GetInvokingClass());

    //Apply the VFX impact and effect
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration,TRUE,-1,CasterLvl);
    IPSafeAddItemProperty(oSkin, ItemPropertyDarkvision(), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
}