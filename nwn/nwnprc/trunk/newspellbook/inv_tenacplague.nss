
#include "prc_alterations"
#include "inc_utility"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void BuffSummon(int nAOE, location lTarget, object oCaster)
{
    
    int i = 1;
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF, i);
    if(DEBUG) DoDebug("inv_tenacplague: First Summon is " + DebugObject2Str(oSummon));
    while(GetIsObjectValid(oSummon))
    {
        i++;
        oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF, i);
        if(DEBUG) DoDebug("inv_tenacplague: Next Summon is " + DebugObject2Str(oSummon));
    }
    oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF, i - 1);
    if(DEBUG) DoDebug("inv_tenacplague: Final Summon is " + DebugObject2Str(oSummon));
    
    effect eAOE = EffectAreaOfEffect(nAOE);
    effect eCritImmune = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
    effect eWeaponImm1 = EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 100);
    effect eWeaponImm2 = EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING, 100);
    effect eWeaponImm3 = EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, 100);
    effect eLink = EffectLinkEffects(eCritImmune, eWeaponImm1);
    eLink = EffectLinkEffects(eLink, eWeaponImm2);
    eLink = EffectLinkEffects(eLink, eWeaponImm3);
    eLink = EffectLinkEffects(eLink, eAOE);
    eLink = EffectLinkEffects(eLink, EffectCutsceneParalyze());
    eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_FLIES));
    SetLocalInt(oSummon, "IgnoreSwarmDmg", TRUE);
    SetLocalInt(oCaster, "SwarmDmgType", INVOKE_TENACIOUS_PLAGUE);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(eLink), oSummon);
}

void main()
{
    if (!PreInvocationCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
    
    //Declare major variables
    int nCasterLvl = GetInvokerLevel(OBJECT_SELF, GetInvokingClass());
    effect eSummon = EffectSummonCreature("prc_tplagueswarm");
    int nAOE;
    if(nCasterLvl > 17)
        nAOE = INVOKE_AOE_SWARMDMG_6;
    else if(nCasterLvl > 14)
        nAOE = INVOKE_AOE_SWARMDMG_5;
    else if(nCasterLvl > 11)
        nAOE = INVOKE_AOE_SWARMDMG_4;
    else if(nCasterLvl > 8)
        nAOE = INVOKE_AOE_SWARMDMG_3;
    else if(nCasterLvl > 5)
        nAOE = INVOKE_AOE_SWARMDMG_2;
    else
        nAOE = INVOKE_AOE_SWARMDMG;
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
    float fDuration = TurnsToSeconds(nCasterLvl);
    
    //Apply the VFX impact and summon effect
    MultisummonPreSummon();
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, PRCGetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, PRCGetSpellTargetLocation(), fDuration);
    
    DelayCommand(0.1, BuffSummon(nAOE, PRCGetSpellTargetLocation(), OBJECT_SELF));

}

