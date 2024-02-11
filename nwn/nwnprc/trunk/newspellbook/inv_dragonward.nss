//::///////////////////////////////////////////////
//:: Name      Dragon Ward
//:: FileName  inv_dragonward.nss
//::///////////////////////////////////////////////
/*

Greater Invocation
6th Level Spell

This invocation makes you resistant to the special
abilities of dragons. You become immune to fear,
and gain damage resistance 20 to any fire, acid,
sonic, electric, or cold damage dealt by breath
weapons. This invocation lasts 24 hours.

*/
//::///////////////////////////////////////////////

#include "inv_inc_invfunc"
#include "inv_invokehook"

void RemoveDragonWard(object oTarget, int CurrentDragonWard)
{
    if(GetPersistantLocalInt(oTarget, "nTimesDragonWarded") != CurrentDragonWard)
        return;

    DeleteLocalInt(oTarget, "DragonWard");
}

void main()
{
    if(!PreInvocationCastCode()) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int CasterLvl = GetInvokerLevel(oCaster, GetInvokingClass());
    int nTimesDragonWarded = GetPersistantLocalInt(oTarget, "nTimesDragonWarded");
    float fDuration = HoursToSeconds(24);
    effect eImm1 = EffectImmunity(IMMUNITY_TYPE_FEAR);
    effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eImm1, eVis);
           eLink = EffectLinkEffects(eLink, eDur);

    nTimesDragonWarded++;
    if(nTimesDragonWarded > 9) nTimesDragonWarded = 0;
    SetPersistantLocalInt(oTarget, "nTimesDragonWarded", nTimesDragonWarded);
    SetLocalInt(oTarget, "DragonWard", TRUE);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, -1, CasterLvl);
    DelayCommand(fDuration, RemoveDragonWard(oTarget, nTimesDragonWarded));
}