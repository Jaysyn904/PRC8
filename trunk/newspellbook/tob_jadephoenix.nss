#include "tob_inc_tobfunc"
#include "tob_inc_recovery"

void main()
{
    int nEvent = GetRunningEvent();
    object oInitiator = OBJECT_SELF;

    int nClass = GetPrimaryBladeMagicClass(oInitiator);
    int nMoveTotal = GetKnownManeuversModifier(oInitiator, nClass, MANEUVER_TYPE_MANEUVER);
    int nStncTotal = GetKnownManeuversModifier(oInitiator, nClass, MANEUVER_TYPE_STANCE);
    int nRdyTotal = GetReadiedManeuversModifier(oInitiator, nClass);

    int nJPMLevel = GetLevelByClass(CLASS_TYPE_JADE_PHOENIX_MAGE, oInitiator);
    int nJPMBonusMove = (nJPMLevel + 1) / 2;
    int nJPMBonusReadied = nJPMLevel / 3;
    int nMod;

    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
        // Allows gaining of maneuvers by prestige classes
        nMod = nJPMBonusMove - GetPersistantLocalInt(oInitiator, "ToBJadePhoenixMove");
        if(nMod)
        {
            SetKnownManeuversModifier(oInitiator, nClass, nMoveTotal + nMod, MANEUVER_TYPE_MANEUVER);
            SetPersistantLocalInt(oInitiator, "ToBJadePhoenixMove", nJPMBonusMove);
            SetPersistantLocalInt(oInitiator, "AllowedDisciplines", 3);//DISCIPLINE_DEVOTED_SPIRIT + DISCIPLINE_DESERT_WIND
        }

        nMod = nJPMBonusReadied - GetPersistantLocalInt(oInitiator, "ToBJadePhoenixReadied");
        if(nMod)
        {
            SetReadiedManeuversModifier(oInitiator, nClass, nRdyTotal + nMod);
            SetPersistantLocalInt(oInitiator, "ToBJadePhoenixReadied", nJPMBonusReadied);
        }

        if(nJPMLevel >= 5 && !GetPersistantLocalInt(oInitiator, "ToBJadePhoenixStance"))
        {
            SetKnownManeuversModifier(oInitiator, nClass, ++nStncTotal, MANEUVER_TYPE_STANCE);
            SetPersistantLocalInt(oInitiator, "ToBJadePhoenixStance", TRUE);
            SetPersistantLocalInt(oInitiator, "AllowedDisciplines", 3);//DISCIPLINE_DEVOTED_SPIRIT + DISCIPLINE_DESERT_WIND
        }

        // Hook to OnLevelDown to remove the maneuver slots granted here
        AddEventScript(oInitiator, EVENT_ONPLAYERLEVELDOWN, "tob_jadephoenix", TRUE, FALSE);
    }
    else if(nEvent == EVENT_ONPLAYERLEVELDOWN)
    {
        // Has lost Maneuver, but the slot is still present
        nMod = GetPersistantLocalInt(oInitiator, "ToBJadePhoenixMove") - nJPMBonusMove;
        if(nMod)
        {
            SetKnownManeuversModifier(oInitiator, nClass, nMoveTotal - nMod, MANEUVER_TYPE_MANEUVER);
            SetPersistantLocalInt(oInitiator, "ToBJadePhoenixMove", nJPMBonusMove);
        }

        nMod = GetPersistantLocalInt(oInitiator, "ToBJadePhoenixReadied") - nJPMBonusReadied;
        if(nMod)
        {
            SetReadiedManeuversModifier(oInitiator, nClass, nRdyTotal - nMod);
            SetPersistantLocalInt(oInitiator, "ToBJadePhoenixReadied", nJPMBonusReadied);
        }

        if(nJPMLevel < 5 && GetPersistantLocalInt(oInitiator, "ToBJadePhoenixStance"))
        {
            SetKnownManeuversModifier(oInitiator, nClass, --nStncTotal, MANEUVER_TYPE_STANCE);
            DeletePersistantLocalInt(oInitiator, "ToBJadePhoenixStance");
        }

        // Remove eventhook if the character no longer has levels in Jade Phoenix
        if(!nJPMLevel)
        {
            RemoveEventScript(oInitiator, EVENT_ONPLAYERLEVELDOWN, "tob_jadephoenix", TRUE, FALSE);
            DeletePersistantLocalInt(oInitiator, "ToBJadePhoenixMove");
            DeletePersistantLocalInt(oInitiator, "ToBJadePhoenixReadied");
        }
    }
}