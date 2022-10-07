#include "tob_inc_tobfunc"
#include "tob_inc_recovery"
#include "prc_craft_inc"

void ArmouredStealth(object oInitiator)
{
    object oHide = GetPCSkin(oInitiator);
    int nHide = GetItemArmourCheckPenalty(GetItemInSlot(INVENTORY_SLOT_CHEST, oInitiator));
    SetCompositeBonus(oHide, "ArmouredStealth", nHide, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
}

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("tob_rubyknight running, event: " + IntToString(nEvent));

    // Get the PC. This is event-dependent
    object oInitiator;
    switch(nEvent)
    {
        case EVENT_ONPLAYEREQUIPITEM:   oInitiator = GetItemLastEquippedBy();   break;
        case EVENT_ONPLAYERUNEQUIPITEM: oInitiator = GetItemLastUnequippedBy(); break;
        default:                        oInitiator = OBJECT_SELF;
    }

    int nClass = GetPrimaryBladeMagicClass(oInitiator);
    int nMoveTotal = GetKnownManeuversModifier(oInitiator, nClass, MANEUVER_TYPE_MANEUVER);
    int nStncTotal = GetKnownManeuversModifier(oInitiator, nClass, MANEUVER_TYPE_STANCE);
    int nRdyTotal  = GetReadiedManeuversModifier(oInitiator, nClass);

DoDebug("nMoveTotal = "+IntToString(nMoveTotal));
DoDebug("nStncTotal = "+IntToString(nStncTotal));
DoDebug("nRdyTotal = "+IntToString(nRdyTotal));

    int nRubyLvl = GetLevelByClass(CLASS_TYPE_RUBY_VINDICATOR, oInitiator);
    int nRubyBonusMove = nRubyLvl / 2;
    int nRubyBonusStance = 1;
    if (nRubyLvl >= 6) nRubyBonusStance = 2; 
    int nRubyBonusReady = nRubyLvl > 8 ? 2 : nRubyLvl > 4 ? 1 : 0;
    int nMod;
DoDebug("nRubyBonusMove = "+IntToString(nRubyBonusMove));
DoDebug("nRubyBonusStance = "+IntToString(nRubyBonusStance));
DoDebug("nRubyBonusReady = "+IntToString(nRubyBonusReady));

    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
        // Hook in the events, needed for various abilities
        if(nRubyLvl > 4)
        {
            if(DEBUG) DoDebug("tob_rubyknight: Adding eventhooks");
            AddEventScript(oInitiator, EVENT_ONPLAYEREQUIPITEM,   "tob_rubyknight", TRUE, FALSE);
            AddEventScript(oInitiator, EVENT_ONPLAYERUNEQUIPITEM, "tob_rubyknight", TRUE, FALSE);

            ArmouredStealth(oInitiator);
        }

        // Allows gaining of maneuvers by prestige classes
        nMod = nRubyBonusMove - GetPersistantLocalInt(oInitiator, "ToBRubyKnightMove");
        if(nMod)
        {
            SetKnownManeuversModifier(oInitiator, nClass, nMoveTotal + nMod, MANEUVER_TYPE_MANEUVER);
            SetPersistantLocalInt(oInitiator, "ToBRubyKnightMove", nRubyBonusMove);
            SetPersistantLocalInt(oInitiator, "AllowedDisciplines", 354);//DISCIPLINE_DEVOTED_SPIRIT + DISCIPLINE_SHADOW_HAND + DISCIPLINE_STONE_DRAGON + DISCIPLINE_WHITE_RAVEN
        }

        nMod = nRubyBonusStance - GetPersistantLocalInt(oInitiator, "ToBRubyKnightStance");
        if(nMod)
        {
            SetKnownManeuversModifier(oInitiator, nClass, nStncTotal + nMod, MANEUVER_TYPE_STANCE);
            SetPersistantLocalInt(oInitiator, "ToBRubyKnightStance", nRubyBonusStance);
            SetPersistantLocalInt(oInitiator, "AllowedDisciplines", 354);//DISCIPLINE_DEVOTED_SPIRIT + DISCIPLINE_SHADOW_HAND + DISCIPLINE_STONE_DRAGON + DISCIPLINE_WHITE_RAVEN
        }

        nMod = nRubyBonusReady - GetPersistantLocalInt(oInitiator, "ToBRubyKnightReady");
        if(nMod)
        {
            SetReadiedManeuversModifier(oInitiator, nClass, nRdyTotal + nMod);
            SetPersistantLocalInt(oInitiator, "ToBRubyKnightReady", nRubyBonusReady);
        }

        // Hook to OnLevelDown to remove the maneuver slots granted here
        AddEventScript(oInitiator, EVENT_ONPLAYERLEVELDOWN, "tob_rubyknight", TRUE, FALSE);
    }
    else if(nEvent == EVENT_ONPLAYERLEVELDOWN)
    {
        // Has lost Maneuver, but the slot is still present
        nMod = GetPersistantLocalInt(oInitiator, "ToBRubyKnightMove") - nRubyBonusMove;
        if(nMod)
        {
            SetKnownManeuversModifier(oInitiator, nClass, nMoveTotal - nMod, MANEUVER_TYPE_MANEUVER);
            SetPersistantLocalInt(oInitiator, "ToBRubyKnightMove", nRubyBonusMove);
        }

        nMod = GetPersistantLocalInt(oInitiator, "ToBRubyKnightStance") - nRubyBonusStance;
        if(nMod)
        {
            SetKnownManeuversModifier(oInitiator, nClass, nMoveTotal - nMod, MANEUVER_TYPE_STANCE);
            SetPersistantLocalInt(oInitiator, "ToBRubyKnightStance", nRubyBonusStance);
        }

        nMod = GetPersistantLocalInt(oInitiator, "ToBRubyKnightReady") - nRubyBonusReady;
        if(nMod)
        {
            SetReadiedManeuversModifier(oInitiator, nClass, nRdyTotal - nMod);
            SetPersistantLocalInt(oInitiator, "ToBRubyKnightReady", nRubyBonusReady);
        }

        // Remove eventhook if the character no longer has levels in Ruby Knight
        if(!nRubyLvl)
        {
            RemoveEventScript(oInitiator, EVENT_ONPLAYERLEVELDOWN, "tob_rubyknight", TRUE, FALSE);
            DeletePersistantLocalInt(oInitiator, "ToBRubyKnightMove");
            DeletePersistantLocalInt(oInitiator, "ToBRubyKnightStance");
            DeletePersistantLocalInt(oInitiator, "ToBRubyKnightReady");
        }
    }
    // We are called from the OnPlayerEquipItem or OnPlayerUnEquipItem eventhook.
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM
          || nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        ArmouredStealth(oInitiator);
    }
}