//::///////////////////////////////////////////////
//:: Name      Dark Discorporation
//:: FileName  inv_darkdiscorp.nss
//::///////////////////////////////////////////////
/*

Dark Invocation
8th Level Spell

You can abandon your body and become a swarm of
batlike shadows for up to 24 hours. In this form
you cannot attack or cast, but you are immune to
normal weapon damage and critical hits as a swarm
is. Your dexterity increases by 6, and you get a
deflection bonus to AC equal to your charisma
modifier. You also gain a swarm attack that does
4d6 damage to anyone in a square your swarm
occupies.

*/
//::///////////////////////////////////////////////

#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    object oCaster = OBJECT_SELF;
    if(GetLocalInt(oCaster, "DarkDiscorporation"))
    {
        PRCRemoveSpellEffects(INVOKE_DARK_DISCORPORATION, oCaster, oCaster);
        DeleteLocalInt(oCaster, "DarkDiscorporation");
        object oNoAtk = GetItemPossessedBy(oCaster, "prc_eldrtch_glv");
        DestroyObject(oNoAtk);
        RemoveEventScript(oCaster, EVENT_ONPLAYERUNEQUIPITEM, "inv_discorpnoatk", TRUE, FALSE);
        RemoveEventScript(oCaster, EVENT_ONUNAQUIREITEM, "inv_discorpnoatk", TRUE, FALSE);
        DeleteLocalInt(oCaster, "IgnoreSwarmDmg");
        DeleteLocalInt(oCaster, "SwarmDmgType");
        return;
    }

    if(!PreInvocationCastCode()) return;

    //Declare major variables
    int CasterLvl = GetInvokerLevel(oCaster, GetInvokingClass());
    int nChaMod = GetAbilityModifier(ABILITY_CHARISMA, oCaster);
    effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);

    effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY, 6);
    effect eCritImmune = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
    effect eWeaponImm1 = EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 100);
    effect eWeaponImm2 = EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING, 100);
    effect eWeaponImm3 = EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, 100);
    effect eAOE = EffectAreaOfEffect(INVOKE_VFX_DARK_DISCORPORATION);
    effect eArmor = EffectACIncrease(nChaMod, AC_DEFLECTION_BONUS);
    effect eLink = EffectLinkEffects(eCritImmune, eDex);
           eLink = EffectLinkEffects(eLink, eWeaponImm1);
           eLink = EffectLinkEffects(eLink, eWeaponImm2);
           eLink = EffectLinkEffects(eLink, eWeaponImm3);
           eLink = EffectLinkEffects(eLink, eAOE);
           eLink = EffectLinkEffects(eLink, eArmor);
           eLink = EffectLinkEffects(eLink, eArmor);
           eLink = EffectLinkEffects(eLink, EffectAttackDecrease(20));
           eLink = EffectLinkEffects(eLink, EffectAbilityDecrease(ABILITY_STRENGTH, 20));

    //Fire cast spell at event for the specified target
    SignalEvent(oCaster, EventSpellCastAt(oCaster, INVOKE_DARK_DISCORPORATION, FALSE));

    //Apply the VFX impact and effects
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oCaster);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, HoursToSeconds(24), TRUE, -1, CasterLvl);
    SetLocalInt(oCaster, "DarkDiscorporation", TRUE);

    object oNoAtk = CreateItemOnObject("prc_eldrtch_glv", oCaster);  
    SetDroppableFlag(oNoAtk, FALSE);
    SetItemCursedFlag(oNoAtk, TRUE);
    AssignCommand(oCaster, ActionEquipItem(oNoAtk, INVENTORY_SLOT_RIGHTHAND));
    SetLocalInt(oCaster, "IgnoreSwarmDmg", TRUE);
    SetLocalInt(oCaster, "SwarmDmgType", INVOKE_DARK_DISCORPORATION);
    ExecuteScript("inv_discorpnoatk", oCaster);
}

