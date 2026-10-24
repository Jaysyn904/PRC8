//::///////////////////////////////////////////////
//:: Werewolf bite: trip and curse of lycanthropy
//:: prc_wwcurse
//:://////////////////////////////////////////////
/*
    D&D 3.0 werewolf bite behavior:
      * a successful bite permits a free trip attempt;
      * failure never permits a counter-trip;
      * a humanoid target must pass a DC 15 Fortitude save or gain the
        acquired werewolf template.

    The source item is checked explicitly because the legacy polymorph
    assets also put the Unique Power property on werewolf claws.
*/

#include "x2_inc_switches"
#include "prc_alterations"
#include "prc_inc_spells"
#include "prc_inc_template"
#include "prc_inc_wwolf"

int PRCWWTripSizeModifier(object oCreature)
{
    return (GetCreatureSize(oCreature) - CREATURE_SIZE_MEDIUM) * 4;
}

void PRCWWBiteTrip(object oAttacker, object oTarget)
{
    int nAttackerSize = GetCreatureSize(oAttacker);
    int nTargetSize = GetCreatureSize(oTarget);

    // General trip rules: the target may be no more than one category larger.
    if(nTargetSize > nAttackerSize + 1)
        return;

    int nAttackMod = GetAbilityModifier(ABILITY_STRENGTH, oAttacker)
        + PRCWWTripSizeModifier(oAttacker);
    int nDefenseMod = GetAbilityModifier(ABILITY_STRENGTH, oTarget);
    int nDexMod = GetAbilityModifier(ABILITY_DEXTERITY, oTarget);
    if(nDexMod > nDefenseMod)
        nDefenseMod = nDexMod;
    nDefenseMod += PRCWWTripSizeModifier(oTarget);

    int nAttackCheck;
    int nDefenseCheck;
    do
    {
        nAttackCheck = d20() + nAttackMod;
        nDefenseCheck = d20() + nDefenseMod;
    }
    while(nAttackCheck == nDefenseCheck && nAttackMod == nDefenseMod);

    int bSuccess = nAttackCheck > nDefenseCheck
        || (nAttackCheck == nDefenseCheck && nAttackMod > nDefenseMod);

    if(GetIsPC(oAttacker))
        SendMessageToPC(oAttacker, "Werewolf bite trip: "
            + IntToString(nAttackCheck) + " vs " + IntToString(nDefenseCheck));

    if(bSuccess)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
            ExtraordinaryEffect(EffectKnockdown()), oTarget, RoundsToSeconds(1));
    }
}

void main()
{
    int nEvent = GetRunningEvent();
    int nItemEvent = GetUserDefinedItemEventNumber();
    if(nEvent != EVENT_ITEM_ONHIT && nItemEvent != X2_ITEM_EVENT_ONHITCAST)
        return;

    object oItem = PRCGetSpellCastItem();
    object oTarget = PRCGetSpellTargetObject();

    if(!GetIsObjectValid(oItem) || !GetIsObjectValid(oTarget))
        return;

    string sResRef = GetResRef(oItem);
    if(sResRef != "werewolfbite" && sResRef != "werewolfbitel"
    && sResRef != "tmp_wwbite")
        return;

    object oAttacker = GetItemPossessor(oItem);
    if(!GetIsObjectValid(oAttacker))
        oAttacker = OBJECT_SELF;

    PRCWWBiteTrip(oAttacker, oTarget);

    // D&D 3.0 applies the curse to humanoids, not only player characters.
    // Standard PRC NPC heartbeat scripts dispatch the same template
    // maintenance hook used by PCs.
    if(!PRCWWIsHumanoid(oTarget))
    {
        PRCWWDebug("infection-skipped", oTarget, "reason=not-humanoid");
        if(PRCWWDebugEnabled() && GetIsPC(oAttacker))
            SendMessageToPC(oAttacker,
                "[WWTPL DEBUG] Infection skipped: target is not humanoid.");
        return;
    }

    if(PRCWWIsWerewolf(oTarget))
    {
        PRCWWDebug("infection-skipped", oTarget, "reason=already-werewolf");
        if(PRCWWDebugEnabled() && GetIsPC(oAttacker))
            SendMessageToPC(oAttacker,
                "[WWTPL DEBUG] Infection skipped: target is already a werewolf.");
        return;
    }

    int bSaved = PRCMySavingThrow(SAVING_THROW_FORT, oTarget, 15,
        SAVING_THROW_TYPE_NONE, oAttacker);
    PRCWWDebug("infection-save", oTarget,
        "dc=15 result=" + (bSaved ? "PASS" : "FAIL")
        + " source=" + GetName(oAttacker));

    if(bSaved)
    {
        if(GetIsPC(oAttacker))
            SendMessageToPC(oAttacker, GetName(oTarget)
                + " resists the lycanthropic curse (Fortitude DC 15).");
        return;
    }

    if(ApplyTemplateToObject(TEMPLATE_LYCAN_ACQ_WOLF, oTarget))
    {
        // The victim does not recognize the affliction until an
        // involuntary episode is followed by a DC 15 Wisdom check.
        PRCWWResetRuntimeState(oTarget);
        SetPersistantLocalInt(oTarget, "PRC_WW_Aware", FALSE);
        DeletePersistantLocalInt(oTarget,
            PRC_WW_SELUNITE_AWARE_GRANTED);
        PRCWWSyncSeluniteControl(oTarget);
        DeletePersistantLocalInt(oTarget, "PRC_WW_Embraced");
        SetPersistantLocalInt(oTarget, "PRC_WW_InfectionDate", PRCWWDateKey());
        SetPersistantLocalInt(oTarget, "PRC_WW_InfectionHour", GetTimeHour());
        SetPersistantLocalInt(oTarget, "PRC_WW_InfectionHourKey", PRCWWHourKey());
        DeletePersistantLocalInt(oTarget, "PRC_WW_Manifested");

        PRCWWDebug("infection-applied", oTarget,
            "template=" + IntToString(TEMPLATE_LYCAN_ACQ_WOLF)
            + " aware=" + IntToString(
                GetPersistantLocalInt(oTarget, "PRC_WW_Aware"))
            + " manifested=0"
            + " date=" + IntToString(PRCWWDateKey())
            + " hour=" + IntToString(GetTimeHour())
            + " source=" + GetName(oAttacker));

        if(GetIsPC(oAttacker))
            SendMessageToPC(oAttacker, GetName(oTarget)
                + " has contracted lycanthropy.");
    }
    else
    {
        PRCWWDebug("infection-apply-failed", oTarget,
            "template=" + IntToString(TEMPLATE_LYCAN_ACQ_WOLF));
        if(PRCWWDebugEnabled() && GetIsPC(oAttacker))
            SendMessageToPC(oAttacker,
                "[WWTPL DEBUG] Infection save failed, but the template could not be applied.");
    }
}
