
#include "prc_alterations"
#include "inc_utility"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void BuffSummon(object oCaster)
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
    
    SetLocalInt(oSummon,"X2_L_CREATURE_NEEDS_CONCENTRATION",TRUE);
    SetLocalInt(oSummon, "IgnoreSwarmDmg", TRUE);
    SetLocalInt(OBJECT_SELF, "SwarmDmgType", INVOKE_SUMMON_SWARM_BAT);
    effect eAOE = EffectAreaOfEffect(INVOKE_VFX_HUNGRY_DARKNESS);
    eAOE = EffectLinkEffects(eAOE, EffectCutsceneParalyze());
    effect eCritImmune = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
    effect eWeaponImm1 = EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 100);
    effect eWeaponImm2 = EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING, 100);
    effect eWeaponImm3 = EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, 100);
    effect eLink = EffectLinkEffects(eCritImmune, eWeaponImm1);
    eLink = EffectLinkEffects(eLink, eWeaponImm2);
    eLink = EffectLinkEffects(eLink, eWeaponImm3);
    eLink = EffectLinkEffects(eLink, eAOE);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oSummon);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectUltravision(), oSummon);
    itemproperty ipWounding =  ItemPropertyOnHitProps(IP_CONST_ONHIT_WOUNDING, IP_CONST_ONHIT_SAVEDC_26, 1);
    object oBite = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oSummon);
    AddItemProperty(DURATION_TYPE_PERMANENT, ipWounding, oBite);
    SetLocalObject(OBJECT_SELF, "SwarmWeapon", oBite);
}

void main()
{
    if (!PreInvocationCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
    
    //Declare major variables
    int nDuration = GetInvokerLevel(OBJECT_SELF, GetInvokingClass());
    effect eSummon = EffectSummonCreature("prc_bat_swarm");
    eSummon = EffectSummonCreature("prc_bat_swarm");
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
    float fDuration = RoundsToSeconds(nDuration);
    if(GetPRCSwitch(PRC_SUMMON_ROUND_PER_LEVEL))
        fDuration = RoundsToSeconds(nDuration*GetPRCSwitch(PRC_SUMMON_ROUND_PER_LEVEL));
    
    //Apply the VFX impact and summon effect
    MultisummonPreSummon();
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, PRCGetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, PRCGetSpellTargetLocation(), fDuration);
    DelayCommand(0.1, BuffSummon(OBJECT_SELF));
}

