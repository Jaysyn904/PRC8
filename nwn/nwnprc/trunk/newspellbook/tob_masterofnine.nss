#include "tob_inc_tobfunc"
#include "tob_inc_recovery"

void main()
{
    object oInitiator = OBJECT_SELF;
    int nEvent = GetRunningEvent();

    int nClass = GetPrimaryBladeMagicClass(oInitiator);
    int nMoveTotal = GetKnownManeuversModifier(oInitiator, nClass, MANEUVER_TYPE_MANEUVER);
    int nStncTotal = GetKnownManeuversModifier(oInitiator, nClass, MANEUVER_TYPE_STANCE);
    int nRdyTotal  = GetReadiedManeuversModifier(oInitiator, nClass);

    int nMoNLvl = GetLevelByClass(CLASS_TYPE_MASTER_OF_NINE, oInitiator);
    int nMoNBonusMove = ((nMoNLvl * 3) + 1) / 2;
    int nMoNBonusStance = nMoNLvl / 2;
    int nMod;

    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
        // Allows gaining of maneuvers by prestige classes
        nMod = nMoNBonusMove - GetPersistantLocalInt(oInitiator, "ToBMasterOfNineMove");
        if(nMod)
        {
            SetKnownManeuversModifier(oInitiator, nClass, nMoveTotal + nMod, MANEUVER_TYPE_MANEUVER);
            SetPersistantLocalInt(oInitiator, "ToBMasterOfNineMove", nMoNBonusMove);
            SetPersistantLocalInt(oInitiator, "AllowedDisciplines", 511);
        }

        nMod = nMoNBonusStance - GetPersistantLocalInt(oInitiator, "ToBMasterOfNineStance");
        if(nMod)
        {
            SetKnownManeuversModifier(oInitiator, nClass, nStncTotal + nMod, MANEUVER_TYPE_STANCE);
            SetPersistantLocalInt(oInitiator, "ToBMasterOfNineStance", nMoNBonusStance);
            SetPersistantLocalInt(oInitiator, "AllowedDisciplines", 511);
        }

        nMod = nMoNLvl - GetPersistantLocalInt(oInitiator, "ToBMasterOfNineReady");
        if(nMod)
        {
            SetReadiedManeuversModifier(oInitiator, nClass, nRdyTotal + nMod);
            SetPersistantLocalInt(oInitiator, "ToBMasterOfNineReady", nMoNLvl);
        }

        // Hook to OnLevelDown to remove the maneuver slots granted here
        AddEventScript(oInitiator, EVENT_ONPLAYERLEVELDOWN, "tob_masterofnine", TRUE, FALSE);
    }
    else if(nEvent == EVENT_ONPLAYERLEVELDOWN)
    {
        // Has lost Maneuver, but the slot is still present
        nMod = GetPersistantLocalInt(oInitiator, "ToBMasterOfNineMove") - nMoNBonusMove;
        if(nMod)
        {
            SetKnownManeuversModifier(oInitiator, nClass, nMoveTotal - nMod, MANEUVER_TYPE_MANEUVER);
            SetPersistantLocalInt(oInitiator, "ToBMasterOfNineMove", nMoNBonusMove);
        }

        nMod = GetPersistantLocalInt(oInitiator, "ToBMasterOfNineStance") - nMoNBonusStance;
        if(nMod)
        {
            SetKnownManeuversModifier(oInitiator, nClass, nMoveTotal - nMod, MANEUVER_TYPE_STANCE);
            SetPersistantLocalInt(oInitiator, "ToBMasterOfNineStance", nMoNBonusStance);
        }

        nMod = GetPersistantLocalInt(oInitiator, "ToBMasterOfNineReady") - nMoNLvl;
        if(nMod)
        {
            SetReadiedManeuversModifier(oInitiator, nClass, nRdyTotal - nMod);
            SetPersistantLocalInt(oInitiator, "ToBMasterOfNineReady", nMoNLvl);
        }

        // Remove eventhook if the character no longer has levels in Master of Nine
        if(!nMoNLvl)
        {
            RemoveEventScript(oInitiator, EVENT_ONPLAYERLEVELDOWN, "tob_masterofnine", TRUE, FALSE);
            DeletePersistantLocalInt(oInitiator, "ToBMasterOfNineMove");
            DeletePersistantLocalInt(oInitiator, "ToBMasterOfNineStance");
            DeletePersistantLocalInt(oInitiator, "ToBMasterOfNineReady");
        }
    }
}