#include "tob_inc_tobfunc"
#include "tob_inc_recovery"
#include "prc_inc_fork"

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("tob_deepstone running, event: " + IntToString(nEvent));

    // Get the PC. This is event-dependent
    object oInitiator;
    switch(nEvent)
    {
        case EVENT_ONPLAYEREQUIPITEM:   oInitiator = GetItemLastEquippedBy();   break;
        case EVENT_ONPLAYERUNEQUIPITEM: oInitiator = GetItemLastUnequippedBy(); break;
        default:                       oInitiator = OBJECT_SELF;
    }

    object oItem;
    int nClass = GetPrimaryBladeMagicClass(oInitiator);
    int nMoveTotal = GetKnownManeuversModifier(oInitiator, nClass, MANEUVER_TYPE_MANEUVER);
    int nRdyTotal  = GetReadiedManeuversModifier(oInitiator, nClass);

    int nDSLvl = GetLevelByClass(CLASS_TYPE_DEEPSTONE_SENTINEL, oInitiator);
    int nDSBonusMove = (nDSLvl + 1) / 2;
    int nMod;

    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
        // Hook in the events, needed from level 4 for Stone Curse
        if(DEBUG) DoDebug("tob_deepstone: Adding eventhooks");
        if(nDSLvl > 3)
        {
            AddEventScript(oInitiator, EVENT_ONPLAYEREQUIPITEM,   "tob_deepstone", TRUE, FALSE);
            AddEventScript(oInitiator, EVENT_ONPLAYERUNEQUIPITEM, "tob_deepstone", TRUE, FALSE);
            //AddEventScript(oInitiator, EVENT_ONHEARTBEAT,         "tob_deepstone", TRUE, FALSE);
        }

        // Allows gaining of maneuvers by prestige classes
        nMod = nDSBonusMove - GetPersistantLocalInt(oInitiator, "ToBDeepstoneMove");
        if(nMod)
        {
            SetKnownManeuversModifier(oInitiator, nClass, nMoveTotal + nMod, MANEUVER_TYPE_MANEUVER);
            SetPersistantLocalInt(oInitiator, "ToBDeepstoneMove", nDSBonusMove);
            SetPersistantLocalInt(oInitiator, "AllowedDisciplines", DISCIPLINE_STONE_DRAGON);
        }

        if(nDSLvl > 2 && !GetPersistantLocalInt(oInitiator, "ToBDeepstoneReadied"))
        {
            SetReadiedManeuversModifier(oInitiator, nClass, nRdyTotal + 1);
            SetPersistantLocalInt(oInitiator, "ToBDeepstoneReadied", 1);
        }

        // Hook to OnLevelDown to remove the maneuver slots granted here
        AddEventScript(oInitiator, EVENT_ONPLAYERLEVELDOWN, "tob_deepstone", TRUE, FALSE);        
    }
    else if(nEvent == EVENT_ONPLAYERLEVELDOWN)
    {
        // Has lost MAneuver, but the slot is still present
        nMod = GetPersistantLocalInt(oInitiator, "ToBDeepstoneMove") - nDSBonusMove;
        if(nMod)
        {
            SetKnownManeuversModifier(oInitiator, nClass, nMoveTotal - nMod, MANEUVER_TYPE_MANEUVER);
            SetPersistantLocalInt(oInitiator, "ToBDeepstoneMove", nDSBonusMove);
        }

        if(nDSLvl < 3 && GetPersistantLocalInt(oInitiator, "ToBDeepstoneReadied"))
        {
            SetReadiedManeuversModifier(oInitiator, nClass, nRdyTotal - 1);
            DeletePersistantLocalInt(oInitiator, "ToBDeepstoneReadied");
        }

        // Remove eventhook if the character no longer has levels in Deepstone
        if(!nDSLvl)
        {
            RemoveEventScript(oInitiator, EVENT_ONPLAYERLEVELDOWN, "tob_deepstone", TRUE, FALSE);
            DeletePersistantLocalInt(oInitiator, "ToBDeepstoneMove");
        }
    }
    else if(nEvent == EVENT_ITEM_ONHIT && !GetLocalInt(oInitiator, "DSPStoneCurse"))
    {
        oItem          = GetSpellCastItem();
        object oTarget = PRCGetSpellTargetObject();
        if(DEBUG) DoDebug("tob_deepstone: OnHit:\n"
                        + "oInitiator = " + DebugObject2Str(oInitiator) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                        + "oTarget = " + DebugObject2Str(oTarget) + "\n"
                          );

        // Only applies to weapons, must be melee
        if(oItem == GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator))
        {
            // Saving Throw
            if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, (10 + GetHitDice(oInitiator)/2 + GetAbilityModifier(ABILITY_STRENGTH, oInitiator))))
            {
                effect eLink = ExtraordinaryEffect(EffectLinkEffects(EffectCutsceneImmobilize(), EffectVisualEffect(VFX_IMP_DOOM)));
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0);
            }
            // Once a round
            SetLocalInt(oInitiator, "DSPStoneCurse", TRUE);
            DelayCommand(6.0, DeleteLocalInt(oInitiator, "DSPStoneCurse"));
        }
    }
    // We are called from the OnPlayerEquipItem eventhook. Add OnHitCast: Unique Power to oInitiator's weapon
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    {
        oItem = GetItemLastEquipped();
        if(DEBUG) DoDebug("tob_deepstone - OnEquip\n"
                        + "oInitiator = " + DebugObject2Str(oInitiator) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        // Only applies to weapons
        if(IPGetIsMeleeWeapon(oItem))
        {
            // Add eventhook to the item
            AddEventScript(oItem, EVENT_ITEM_ONHIT, "tob_deepstone", TRUE, FALSE);

            // Add the OnHitCastSpell: Unique needed to trigger the event
            IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
    }
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oInitiator's weapon
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("tob_deepstone - OnUnEquip\n"
                        + "oInitiator = " + DebugObject2Str(oInitiator) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        // Only applies to weapons
        if(IPGetIsMeleeWeapon(oItem))
        {
            // Add eventhook to the item
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "tob_deepstone", TRUE, FALSE);

            // Remove the temporary OnHitCastSpell: Unique
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);
        }
    }
}
