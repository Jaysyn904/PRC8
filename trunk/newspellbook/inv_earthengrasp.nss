//::///////////////////////////////////////////////
//:: Name      Earthen Grasp
//::           Stony Grasp
//:: FileName  inv_earthengrasp.nss
//::///////////////////////////////////////////////
/*

Least Invocation
2nd Level Spell

You can summon up an immobile hand of dirt and
grass which grapples any creature nearby. The hand
lasts for 2 rounds per level, has an AC of 15,
hardness of 4, and has 3 HP per level.

Lesser Invocation
3rd Level Spell

You can summon up an immobile hand of rock and
stone which grapples any creature nearby. The hand
lasts for 1 round per level, has an AC of 18,
hardness of 8, and has 4 HP per level.

*/
//::///////////////////////////////////////////////

#include "inv_inc_invfunc"
#include "inv_invokehook"

void BuffSummon(int nDuration, object oCaster, int nSpellID)
{
    int i = 1;
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster, i);
    if(DEBUG) DoDebug("inv_tenacplague: First Summon is " + DebugObject2Str(oSummon));
    while(GetIsObjectValid(oSummon))
    {
        i++;
        oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster, i);
        if(DEBUG) DoDebug("inv_tenacplague: Next Summon is " + DebugObject2Str(oSummon));
    }
    oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster, i - 1);
    if(DEBUG) DoDebug("inv_tenacplague: Final Summon is " + DebugObject2Str(oSummon));

    effect eDR = EffectDamageReduction(4, DAMAGE_POWER_ENERGY);
    effect eHP = EffectTemporaryHitpoints(nDuration * 3 - 3);
    effect eHand = EffectVisualEffect(VFX_DUR_BIGBYS_GRASPING_HAND);
    if(nSpellID == INVOKE_STONY_GRASP)
    {
        eDR = EffectDamageReduction(8, DAMAGE_POWER_ENERGY);
        eHP = EffectTemporaryHitpoints(nDuration * 4 - 4);
    }
    effect eAOE = EffectAreaOfEffect(INVOKE_AOE_EARTHEN_GRASP_GRAPPLE);
    SetLocalInt(oSummon, "SourceOfGrapple", TRUE);
    eAOE = EffectLinkEffects(eAOE, EffectCutsceneParalyze());
    effect eLink = EffectLinkEffects(eDR, eHP);
    eLink = EffectLinkEffects(eLink, eHand);
    eLink = EffectLinkEffects(eLink, eAOE);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oSummon);
}

void main()
{
    if(!PreInvocationCastCode()) return;

    object oCaster = OBJECT_SELF;
    object oArea = GetArea(OBJECT_SELF);
    int nSpellID = GetSpellId();
    if(nSpellID == INVOKE_EARTHEN_GRASP && 
       GetIsAreaNatural(oArea) != AREA_NATURAL && 
       GetIsAreaAboveGround(oArea) != AREA_ABOVEGROUND)
    {
        FloatingTextStringOnCreature("You can only use this invocation in natural, above-ground areas.", oCaster, FALSE);
        return;
    }

    //Declare major variables
    location lTarget = PRCGetSpellTargetLocation();
    int nDuration = GetInvokerLevel(oCaster, GetInvokingClass());
    effect eSummon = EffectSummonCreature("inv_earthenhand");
    float fDuration = RoundsToSeconds(nDuration * 2);
    if(nSpellID == INVOKE_STONY_GRASP)
    {
        eSummon = EffectSummonCreature("inv_stonyhand");
        fDuration = RoundsToSeconds(nDuration);
    }
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);

    //Apply the VFX impact and summon effect
    MultisummonPreSummon();
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, lTarget);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, lTarget, fDuration);
    DelayCommand(0.1, BuffSummon(nDuration, oCaster, nSpellID));
}