#include "tob_inc_tobfunc"
#include "tob_inc_recovery"
#include "prc_inc_fork"

int IsUsingBloodClawWeapons(object oInitiator)
{
    object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
    int nType = GetBaseItemType(oWeap);
    if(nType == GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oInitiator))
    && (nType == BASE_ITEM_DAGGER || GetIsDisciplineWeapon(oWeap, DISCIPLINE_TIGER_CLAW)))
        return TRUE;

    return FALSE;
}

void ApplySuperiorTWF(object oInitiator)
{
    if(IsUsingBloodClawWeapons(oInitiator))
    {
        SetCompositeAttackBonus(oInitiator, "SuperiorTWF", 2);
    }
}

void RemoveSuperiorTWF(object oInitiator)
{
    if(!IsUsingBloodClawWeapons(oInitiator))
    {
        SetCompositeAttackBonus(oInitiator, "SuperiorTWF", 0);
    }
}

void ClawsOfTheBeast(object oInitiator, object oTarget)
{
    if(IsUsingBloodClawWeapons(oInitiator))
    {
        // The +1 is to round up
        int nStr = (GetAbilityModifier(ABILITY_STRENGTH, oInitiator) + 1) / 2;
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nStr), oTarget);
    }
}

void RendingClaws(object oInitiator, object oTarget)
{
    //:: Check that Rending Claws is enabled
	int bCanRend = GetLocalInt(oInitiator, "BCM_REND");
	
	// Expend a maneuver to do the rend, must be shifting
    if(bCanRend && ExpendRandomManeuver(oInitiator, GetPrimaryBladeMagicClass(oInitiator), DISCIPLINE_TIGER_CLAW)
    && GetHasSpellEffect(MOVE_BLOODCLAW_SHIFT, oTarget))
    {
        if(IsUsingBloodClawWeapons(oInitiator))
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(2)), oTarget);
        }
    }
}

void Scent(object oInitiator)
{
	effect eTest = GetFirstEffect(oInitiator);
	while (GetIsEffectValid(eTest))
	{
		if (GetEffectTag(eTest) == "BCM_SCENT_ACTIVE")
			return;
		eTest = GetNextEffect(oInitiator);
	}

	effect eLink;
	effect eScent;
	
	eScent = EffectLinkEffects(EffectSkillIncrease(SKILL_SPOT, 4), EffectSkillIncrease(SKILL_LISTEN, 4));
	eLink = EffectLinkEffects(eScent, EffectSkillIncrease(SKILL_SEARCH, 4));
	eLink = EffectLinkEffects(eLink, EffectBonusFeat(FEAT_KEEN_SENSE));
	eLink = TagEffect(eLink, "BCM_SCENT_ACTIVE");
	eLink = UnyieldingEffect(eLink);

	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oInitiator);	
}

/* void Scent(object oInitiator)
{
    object oSkin = GetPCSkin(oInitiator);
	
	effect eScent = EffectLinkEffects(EffectSkillIncrease(SKILL_SPOT, 4), EffectSkillIncrease(SKILL_LISTEN, 4));
           eScent = EffectLinkEffects(eScent, EffectSkillIncrease(SKILL_SEARCH, 4));
	
	IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_KEEN_SENSES), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eScent, oInitiator);
} */

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("tob_bloodclaw running, event: " + IntToString(nEvent));

    // Get the PC. This is event-dependent
    object oInitiator;
    switch(nEvent)
    {
        case EVENT_ONPLAYEREQUIPITEM:   oInitiator = GetItemLastEquippedBy();   break;
        case EVENT_ONPLAYERUNEQUIPITEM: oInitiator = GetItemLastUnequippedBy(); break;
        default:                        oInitiator = OBJECT_SELF;
    }

    object oItem;
    int nClass = GetPrimaryBladeMagicClass(oInitiator);
    int nMoveTotal = GetKnownManeuversModifier(oInitiator, nClass, MANEUVER_TYPE_MANEUVER);
    int nRdyTotal  = GetReadiedManeuversModifier(oInitiator, nClass);

    int nBCMLvl = GetLevelByClass(CLASS_TYPE_BLOODCLAW_MASTER, oInitiator);
    int nBCMBonusMove = (nBCMLvl + 1) / 2;
    int nMod;

    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
        // Hook in the events, needed for various abilities
        if(DEBUG) DoDebug("tob_bloodclaw: Adding eventhooks");
        AddEventScript(oInitiator, EVENT_ONPLAYEREQUIPITEM,   "tob_bloodclaw", TRUE, FALSE);
        AddEventScript(oInitiator, EVENT_ONPLAYERUNEQUIPITEM, "tob_bloodclaw", TRUE, FALSE);
        //AddEventScript(oInitiator, EVENT_ONHEARTBEAT,         "tob_bloodclaw", TRUE, FALSE);

        // Rest of the checks are in the function
        if(nBCMLvl > 1) ApplySuperiorTWF(oInitiator);
        if(nBCMLvl > 4) Scent(oInitiator);

        // Allows gaining of maneuvers by prestige classes
        nMod = nBCMBonusMove - GetPersistantLocalInt(oInitiator, "ToBBloodClawMove");
        if(nMod)
        {
            SetKnownManeuversModifier(oInitiator, nClass, nMoveTotal + nMod, MANEUVER_TYPE_MANEUVER);
            SetPersistantLocalInt(oInitiator, "ToBBloodClawMove", nBCMBonusMove);
            SetPersistantLocalInt(oInitiator, "AllowedDisciplines", DISCIPLINE_TIGER_CLAW);
        }

        if(nBCMLvl > 2 && !GetPersistantLocalInt(oInitiator, "ToBBloodClawReadied"))
        {
            SetReadiedManeuversModifier(oInitiator, nClass, nRdyTotal + 1);
            SetPersistantLocalInt(oInitiator, "ToBBloodClawReadied", 1);
        }

        // Hook to OnLevelDown to remove the maneuver slots granted here
        AddEventScript(oInitiator, EVENT_ONPLAYERLEVELDOWN, "tob_bloodclaw", TRUE, FALSE);        
    }
    else if(nEvent == EVENT_ONPLAYERLEVELDOWN)
    {
        // Has lost MAneuver, but the slot is still present
        nMod = GetPersistantLocalInt(oInitiator, "ToBBloodClawMove") - nBCMBonusMove;
        if(nMod)
        {
            SetKnownManeuversModifier(oInitiator, nClass, nMoveTotal - nMod, MANEUVER_TYPE_MANEUVER);
            SetPersistantLocalInt(oInitiator, "ToBBloodClawMove", nBCMBonusMove);
        }

        if(nBCMLvl < 3 && GetPersistantLocalInt(oInitiator, "ToBBloodClawReadied"))
        {
            SetReadiedManeuversModifier(oInitiator, nClass, nRdyTotal - 1);
            DeletePersistantLocalInt(oInitiator, "ToBBloodClawReadied");
        }

        // Remove eventhook if the character no longer has levels in Bloodclaw
        if(!nBCMLvl)
        {
            RemoveEventScript(oInitiator, EVENT_ONPLAYERLEVELDOWN, "tob_bloodclaw", TRUE, FALSE);
            DeletePersistantLocalInt(oInitiator, "ToBBloodClawMove");
        }
    }
    else if(nEvent == EVENT_ITEM_ONHIT)
    {
        oItem = GetSpellCastItem();
        // Only applies to weapons, must be melee
        if(oItem == GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oInitiator))
        {
            object oTarget = PRCGetSpellTargetObject();
            if(DEBUG) DoDebug("tob_bloodclaw: OnHit:\n" + "oInitiator = " + DebugObject2Str(oInitiator) + "\n" + "oItem = " + DebugObject2Str(oItem) + "\n" + "oTarget = " + DebugObject2Str(oTarget) + "\n");
            ClawsOfTheBeast(oInitiator, oTarget);
            if(nBCMLvl >= 5) RendingClaws(oInitiator, oTarget);
        }
    }
    // We are called from the OnPlayerEquipItem eventhook. Add OnHitCast: Unique Power to oInitiator's weapon
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    {
        oItem = GetItemLastEquipped();
        if(DEBUG) DoDebug("tob_bloodclaw - OnEquip\n" + "oInitiator = " + DebugObject2Str(oInitiator) + "\n" + "oItem = " + DebugObject2Str(oItem) + "\n");

        // Rest of the checks are in the function
        if(nBCMLvl >= 2) ApplySuperiorTWF(oInitiator);

        // Only applies to weapons
        // IPGetIsMeleeWeapon is bugged and returns true on items it should not
        if(oItem == GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oInitiator) && !GetIsShield(oItem))
        {
            // Add eventhook to the item
            AddEventScript(oItem, EVENT_ITEM_ONHIT, "tob_bloodclaw", TRUE, FALSE);

            // Add the OnHitCastSpell: Unique needed to trigger the event
            IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
    }
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oInitiator's weapon
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("tob_bloodclaw - OnUnEquip\n" + "oInitiator = " + DebugObject2Str(oInitiator) + "\n" + "oItem = " + DebugObject2Str(oItem) + "\n");

        // Rest of the checks are in the function
        if (nBCMLvl >= 2) RemoveSuperiorTWF(oInitiator);

        // Only applies to weapons
        if(IPGetIsMeleeWeapon(oItem) && !GetIsShield(oItem))
        {
            // Add eventhook to the item
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "tob_bloodclaw", TRUE, FALSE);

            // Remove the temporary OnHitCastSpell: Unique
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);
        }
    }
}