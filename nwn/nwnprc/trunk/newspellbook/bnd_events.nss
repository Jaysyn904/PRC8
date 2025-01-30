//::///////////////////////////////////////////////
//:: Binding events
//:: bnd_events
//::///////////////////////////////////////////////
/** @file
    Does all Binding content that require event scripting.

    @author Stratovarius
    @date   Created - 2021.02.03
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "bnd_inc_bndfunc"
#include "prc_inc_unarmed"
#include "prc_inc_fork"

//////////////////////////////////////////////////
/*             Internal Functions               */
//////////////////////////////////////////////////

void CheckIsDropped(object oBinder, object oItem)
{
	if(DEBUG) DoDebug("bnd_events: CheckIsDropped()");
	
    if(GetItemPossessor(oItem) == oBinder)
    {
	    if(DEBUG) DoDebug("bnd_events:GetItemPosessor(oItem) == oBinder");
        // No check for commandability here. Let's not break any cutscenes
        // If cheating does occur, set the char to commandable first here.
        //And remember to restore the setting.

        AssignCommand(oBinder, ClearAllActions());
        AssignCommand(oBinder, ActionPutDownItem(oItem));

        DelayCommand(2.0, CheckIsDropped(oBinder, oItem));
    }
}

//////////////////////////////////////////////////
/*             Content Functions                */
//////////////////////////////////////////////////

void AymHaloOfFire(object oBinder, object oTarget)
{
	if (GetDistanceBetween(oBinder, oTarget) <= FeetToMeters(10.0f))
	{
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(1), DAMAGE_TYPE_FIRE), oTarget);
	}	
}

void NaberiusHeal(object oBinder)
{
	int nCount = GetLocalInt(oBinder, "NaberiusCount");
	//FloatingTextStringOnCreature("Naberius heal has spell effect, nCount: "+IntToString(nCount), oBinder, FALSE);
	if (nCount == 20) // Default timer is 2 real world minutes to an hour
	{
		RecoverUnHealableAbilityDamage(oBinder, ABILITY_STRENGTH, 1);
		RecoverUnHealableAbilityDamage(oBinder, ABILITY_DEXTERITY, 1);
		RecoverUnHealableAbilityDamage(oBinder, ABILITY_CONSTITUTION, 1);
		RecoverUnHealableAbilityDamage(oBinder, ABILITY_INTELLIGENCE, 1);
		RecoverUnHealableAbilityDamage(oBinder, ABILITY_WISDOM, 1);
		RecoverUnHealableAbilityDamage(oBinder, ABILITY_CHARISMA, 1);
		// Reset the number
		nCount -= 20;
	}	
	
	effect eEffect = GetFirstEffect(oBinder);
    while(GetIsEffectValid(eEffect) && !GetLocalInt(oBinder, "NaberiusHealLock"))
    {
    	// Is it an ability decrease?
        if(GetEffectType(eEffect) == EFFECT_TYPE_ABILITY_DECREASE)
        {
        	string sTag = GetEffectTag(eEffect);
        	//FloatingTextStringOnCreature("Effect tag is "+sTag, oBinder, FALSE);
        	int nAbil = StringToInt(GetSubString(sTag, 0, 1));
        	//FloatingTextStringOnCreature("Effect ability is "+IntToString(nAbil), oBinder, FALSE);
        	int nAmount = StringToInt(GetSubString(sTag, 1, 2));
        	//FloatingTextStringOnCreature("Effect ability is "+IntToString(nAmount), oBinder, FALSE);
        	
        	SetLocalInt(oBinder, "NaberiusHealLock", TRUE);
        	DelayCommand(nAmount * 6.0, RemoveEffect(oBinder, eEffect));
        	DelayCommand(nAmount * 6.0, DeleteLocalInt(oBinder, "NaberiusHealLock"));
        	//DelayCommand(nAmount * 6.0, FloatingTextStringOnCreature("Naberius heal removed nAmount: "+IntToString(nAmount), oBinder, FALSE));
        }    
        eEffect = GetNextEffect(oBinder);
    }
    SetLocalInt(oBinder, "NaberiusCount", nCount+1);
}

void HaagentiTrans(object oBinder)
{
	effect eEffect = GetFirstEffect(oBinder);
    while(GetIsEffectValid(eEffect))
    {
    	// Is it poly or petr
        if(GetEffectType(eEffect) == EFFECT_TYPE_PETRIFY || GetEffectType(eEffect) == EFFECT_TYPE_POLYMORPH)
        	RemoveEffect(oBinder, eEffect);

        eEffect = GetNextEffect(oBinder);
    }
}

void AndrasInfluence(object oBinder)
{
	int nCombat = GetIsInCombat(oBinder);
	int nCount  = GetLocalInt(oBinder, "AndrasCombat");
	if (nCombat)
	{
		nCount += 1;
		SetLocalInt(oBinder, "AndrasCombat", nCount);
		if (nCount >= 10)
		{
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectExhausted()), oBinder, HoursToSeconds(1));
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectFrightened()), oBinder, RoundsToSeconds(d4()));
		}
	}
	else
		DeleteLocalInt(oBinder, "AndrasCombat");
}

void EurynomePoisonBloodDelay(object oBinder, object oTarget, int nDC)
{
	if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_POISON))
	{
		int nDice = PRCMin(5, GetBinderLevel(oBinder, VESTIGE_EURYNOME)/3);
    	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_ACID_S), oTarget);
    	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(nDice), DAMAGE_TYPE_ACID), oTarget);
    }
}

void EurynomePoisonBlood(object oBinder, object oTarget)
{
	// Enemy in vaguely melee range, wolves and other long creatures can actually hit outside of 10.0 
	if (GetDistanceBetween(oBinder, oTarget) <= FeetToMeters(15.0f))
	{
		// No weapon equipped, and the target has a bite attack
		if (!GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget)) && GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oTarget)))
		{
			int nDC = GetBinderDC(oBinder, VESTIGE_EURYNOME);
		    if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_POISON))
		    {
        		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_ACID_S), oTarget);
        		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(), DAMAGE_TYPE_ACID), oTarget);
    		}		
    		DelayCommand(60.0, EurynomePoisonBloodDelay(oBinder, oTarget, nDC));
		}
	}	
}

void TenebrousVoid(object oBinder, object oTarget)
{
	if (!GetLocalInt(oBinder, "TenebrousVoidStrike"))
	{
		int nDice = 1 + (GetBinderLevel(oBinder, VESTIGE_TENEBROUS)-7)/4;
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d8(nDice), DAMAGE_TYPE_COLD), oTarget);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FROST_L), oTarget);
		SetLocalInt(oBinder, "TenebrousVoidStrike", TRUE);
		DelayCommand(4.5, DeleteLocalInt(oBinder, "TenebrousVoidStrike"));
	}	
}

void ReapplyTenebrous(object oBinder)
{
	SetLocalInt(GetModule(), PRC_SPELL_TARGET_OBJECT_OVERRIDE, TRUE);
	SetLocalObject(GetModule(), PRC_SPELL_TARGET_OBJECT_OVERRIDE, oBinder);
	DoBindingCheck(oBinder, 18);
	DelayCommand(0.1, ApplyVestige(oBinder, VESTIGE_TENEBROUS)); // Tenebrous vestiges.2da rowid
	DelayCommand(1.0, DeleteLocalInt(GetModule(), PRC_SPELL_TARGET_OBJECT_OVERRIDE));
	DelayCommand(1.0, DeleteLocalObject(GetModule(), PRC_SPELL_TARGET_OBJECT_OVERRIDE));
}	

void SavnokInfluence(object oBinder, object oItem)
{
	if (GetItemACValue(oItem) && !GetLocalInt(oBinder, "SavnokDelay"))
	{
    	int nBase = GetBaseItemType(oItem);
    	AssignCommand(oBinder, ClearAllActions());
    	if (nBase == BASE_ITEM_SMALLSHIELD || nBase == BASE_ITEM_LARGESHIELD || nBase == BASE_ITEM_TOWERSHIELD)		
			AssignCommand(oBinder, ActionEquipItem(oItem, INVENTORY_SLOT_LEFTHAND));
		if (nBase == BASE_ITEM_ARMOR)		
			AssignCommand(oBinder, ActionEquipItem(oItem, INVENTORY_SLOT_CHEST));
			
		SetLocalInt(oBinder, "SavnokDelay", TRUE);
		DelayCommand(0.5, DeleteLocalInt(oBinder, "SavnokDelay"));
		DelayCommand(0.5, ExecuteScript("prc_speed", oBinder));
	}
}

void ExpelledVestigeCleanup(object oBinder)
{
	if (!GetHasSpellEffect(VESTIGE_ANDROMALIUS, oBinder))
	{
		DeleteLocalInt(oBinder, "AndroSneak");
    	DelayCommand(0.1, ExecuteScript("prc_sneak_att", oBinder));    			
	}
	if (!GetHasSpellEffect(VESTIGE_MALPHAS, oBinder))
	{
		DeleteLocalInt(oBinder, "MalphasSneak");
    	DelayCommand(0.1, ExecuteScript("prc_sneak_att", oBinder));    			
	}
	if (!GetHasSpellEffect(VESTIGE_FOCALOR, oBinder))
	{
		PRCRemoveSpellEffects(VESTIGE_FOCALOR_AURA_SADNESS, oBinder, oBinder);  			
		PRCRemoveSpellEffects(VESTIGE_FOCALOR_AURA_SADNESS, oBinder, oBinder);
	}	
	if (!GetHasSpellEffect(VESTIGE_RONOVE, oBinder))
	{
		DeleteLocalInt(oBinder, "RonovesFists");
	}	
    if (!GetHasSpellEffect(VESTIGE_SAVNOK, oBinder) && GetIsObjectValid(GetItemPossessedBy(oBinder, "SavnokCallArmor")))
    {
	    object oArmor = GetItemPossessedBy(oBinder, "SavnokCallArmor");
		SetPlotFlag(oArmor, FALSE);
		DestroyObject(oArmor);	        
    }
    if (!GetHasSpellEffect(VESTIGE_EURYNOME, oBinder) && GetIsObjectValid(GetItemPossessedBy(oBinder, "bnd_eury_hammer")))
    {
	    object oHammer = GetItemPossessedBy(oBinder, "bnd_eury_hammer");
		SetPlotFlag(oHammer, FALSE);
		AssignCommand(oHammer, SetIsDestroyable(TRUE, TRUE, TRUE));
		DestroyObject(oHammer);	        
    }
	// Using Disguise Self strips the hide of all the vestige feats, this reapplies them
	// Checks for having naberius, but not the disguise self feat
	if (GetHasSpellEffect(VESTIGE_NABERIUS, oBinder) && !GetHasFeat(9033, oBinder))
	{
    	int i;
    	for(i = VESTIGE_AMON; i <= VESTIGE_ABYSM; i++)
    	{
    		if(GetHasSpellEffect(i, oBinder)) 
    		{
    			ApplyVestige(oBinder, i);
    			//FloatingTextStringOnCreature("Applying vestige "+IntToString(i), oBinder, FALSE);
    		}
    	}	
	} 
	if (!GetHasSpellEffect(VESTIGE_ACERERAK, oBinder)) DeleteLocalInt(oBinder, "AcererakHealing");
	if (!GetHasSpellEffect(VESTIGE_ARETE, oBinder))
	{
		PRCRemoveSpellEffects(VESTIGE_ARETE_RESIST, oBinder, oBinder);
		GZPRCRemoveSpellEffects(VESTIGE_ARETE_RESIST, oBinder, FALSE);	
	}	
}

void ChupoclopsEth(object oBinder)
{
    // Check to see if the WP is valid
    string sWPTag = "bnd_eventsWP_" + GetName(oBinder);
    object oTestWP = GetWaypointByTag(sWPTag);
    if (!GetIsObjectValid(oTestWP))
    {
        // Create waypoint for the movement
        CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", GetLocation(oBinder), FALSE, sWPTag);
        if(DEBUG) DoDebug("bnd_events: Chupoclops WP for " + DebugObject2Str(oBinder) + " didn't exist, creating. Tag: " + sWPTag);
    }
    else // We have a test waypoint, now to check the distance
    {
        // Distance moved in the last round
        float fDist = GetDistanceBetween(oBinder, oTestWP);
        // Distance needed to move
        float fCheck = FeetToMeters(10.0);

        // Now clean up the WP and create a new one for next round's check
        DestroyObject(oTestWP);
        CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", GetLocation(oBinder), FALSE, sWPTag);

        if(DEBUG) DoDebug("bnd_events: Moved enough: " + DebugBool2String(fDist >= fCheck));

        // Moved too far or in combat
        if (fDist >= fCheck || GetIsInCombat(oBinder))
        {
			PRCRemoveSpellEffects(VESTIGE_CHUPOCLOPS_ETHEREAL_WATCHER, oBinder, oBinder);
			GZPRCRemoveSpellEffects(VESTIGE_CHUPOCLOPS_ETHEREAL_WATCHER, oBinder, FALSE);
			BindAbilCooldown(oBinder, VESTIGE_CHUPOCLOPS_ETHEREAL_WATCHER, VESTIGE_CHUPOCLOPS);
        }
    }
}

void ShaxStormStrike(object oBinder, object oTarget)
{
	if (!GetLocalInt(oBinder, "ShaxStormStrike"))
	{
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(), DAMAGE_TYPE_SONIC), oTarget);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SONIC), oTarget);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(), DAMAGE_TYPE_ELECTRICAL), oTarget);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SPARKS), oTarget);		
		SetLocalInt(oBinder, "ShaxStormStrike", TRUE);
		DelayCommand(4.5, DeleteLocalInt(oBinder, "ShaxStormStrike"));
	}
}

void VanusDisdain(object oBinder, object oTarget)
{
	if (GetHitDice(oBinder) > GetHitDice(oTarget))
	{
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(), DAMAGE_TYPE_DIVINE), oTarget);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SPARKS), oTarget);
	}	
}

void VanusInfluence(object oBinder)
{
	if (!GetLocalInt(oBinder, "PactQuality"+IntToString(VESTIGE_VANUS)))
	{
		int nCombat = GetLocalInt(oBinder, "VanusInfluence");
		int nCurrent = GetIsInCombat(oBinder);
		// We just left combat
		if (nCurrent == FALSE && nCombat == TRUE)
		{
			SetCutsceneMode(oBinder, TRUE);
			FloatingTextStringOnCreature("Victory over my enemies!", oBinder);
			AssignCommand(oBinder, ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING, 1.0, 6.0));
			DelayCommand(6.0, SetCutsceneMode(oBinder, FALSE));
		}	
		//FloatingTextStringOnCreature("Vanus Combat State "+IntToString(nCurrent), oBinder); 
    	SetLocalInt(oBinder, "VanusInfluence", nCurrent);
    }
}    

void CityDweller(object oBinder)
{
	object oArea = GetArea(oBinder);
	// Urban environment, so not natural and aboveground
	if (GetIsAreaNatural(oArea) != AREA_NATURAL && GetIsAreaAboveGround(oArea) == AREA_ABOVEGROUND)
	{
		SetLocalInt(oBinder, "DesharisSpeed", TRUE);
		ExecuteScript("prc_speed", oBinder);
	}
	else
	{
		DeleteLocalInt(oBinder, "DesharisSpeed");
		ExecuteScript("prc_speed", oBinder);
	}	
}

void EligorChromatic(object oBinder, object oTarget)
{
	if (!GetLocalInt(oBinder, "EligorStrikeTimer"))
	{
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(), GetLocalInt(oBinder, "EligorStrike")), oTarget);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FAERIE_FIRE), oTarget);
		SetLocalInt(oBinder, "EligorStrikeTimer", TRUE);
		DelayCommand(4.5, DeleteLocalInt(oBinder, "EligorStrikeTimer"));
	}	
}

void MarchosiasRetribution(object oBinder, object oTarget)
{
	// Skirmish or sneak attack
	if (GetLevelByClass(CLASS_TYPE_SCOUT, oTarget) || GetTotalSneakAttackDice(oTarget))
	{
		if (GetDistanceBetween(oBinder, oTarget) < FeetToMeters(30.0))
		{
			ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(3), DAMAGE_TYPE_FIRE), oTarget);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SPARKS), oTarget);
		}	
	}	
}

/*
	All of this below here is for the Karsite suppress item ability
*/

void SuppressItem(object oTrueSpeaker, object oTarget, int nBeats);

object GetChest(object oCreature)
{
    object oChest = GetObjectByTag("npf_chest" + ObjectToString(oCreature));
    if(oChest == OBJECT_INVALID)
    {
        object oWP = GetWaypointByTag("npf_wp_chest_sp");
        oChest = CreateObject(OBJECT_TYPE_PLACEABLE, "npf_keep_chest", GetLocation(oWP), FALSE,
                    "npf_chest" + ObjectToString(oCreature));
    }
    return oChest;
}

void RemoveAllProperties(object oItem, object oPC)
{
    if(DEBUG) DoDebug("ture_utr_supitem: About to remove properties from item: " + DebugObject2Str(oItem));

    if(oItem == OBJECT_INVALID)
        return;

    int nType = GetBaseItemType(oItem);
    if(nType == BASE_ITEM_TORCH
    || nType == BASE_ITEM_TRAPKIT
    || nType == BASE_ITEM_HEALERSKIT
    || nType == BASE_ITEM_GRENADE
    || nType == BASE_ITEM_THIEVESTOOLS
    || nType == BASE_ITEM_CRAFTMATERIALMED
    || nType == BASE_ITEM_CRAFTMATERIALSML
    || nType == 112)//craftbase
        return;

    object oWP = GetWaypointByTag("npf_wp_chest_sp");

    // Generate UID
    int nKey = GetLocalInt(GetModule(), "PRC_NullPsionicsField_Item_UID_Counter") + 1;
               SetLocalInt(GetModule(), "PRC_NullPsionicsField_Item_UID_Counter", nKey);
    string sKey = IntToString(nKey);
    if(DEBUG) DoDebug("prc_pow_npfent: Removing itemproperties from item " + DebugObject2Str(oItem) + " with key value of '" + sKey + "' of creature " + DebugObject2Str(oPC));

    //object oChest = GetChest(oPC);
    //object oCopy = CopyObject(oItem, GetLocation(oChest), oChest);

    // copying  original item to a secluded waypoint in the area
    // and giving it a tag that contains the key string
    object oCopy = CopyObject(oItem, GetLocation(oWP), OBJECT_INVALID, "npf_item" + sKey);

    //storing the key value on the original item (key value would point to the copy item)
    SetLocalString(oItem, "PRC_NullPsionicsField_Item_UID", sKey);

    //SetLocalObject(oItem, "ITEM_CHEST", oChest); // so the chest can be found
    //SetLocalObject(oChest, sKey, oCopy); // and referenced in the chest

    // Stripping original item from all properties
    itemproperty ip = GetFirstItemProperty(oItem);
    while(GetIsItemPropertyValid(ip))
    {
        RemoveItemProperty(oItem, ip);
        ip = GetNextItemProperty(oItem);
    }
}

void RestoreAllProperties(object oItem, object oPC, int nSlot = -1)
{
    if(DEBUG) DoDebug("psi_pow_npfext: Attempting to restore itemproperties to: " + DebugObject2Str(oItem));
    
    if(oPC != OBJECT_INVALID) // this is a pc object that has an item in inventory slot or normal inventory
    {
        if(oItem == OBJECT_INVALID)
            oItem = GetItemInSlot(nSlot, oPC);
        if(oItem == OBJECT_INVALID)
            return;
    }
    //object oChest = GetLocalObject(oItem, "ITEM_CHEST");
    // getting the key value - this points to the tag of the copy item
    string sKey = GetLocalString(oItem, "PRC_NullPsionicsField_Item_UID");
    // retrieving the copy item that is in this area
    object oOriginalItem = GetObjectByTag("npf_item" + sKey);
    if(DEBUG) DoDebug("psi_pow_npfext: Restoring itemproperties to item: " + DebugObject2Str(oItem) + " with key value of '" + sKey + "' for creature " + DebugObject2Str(oPC));

    //object oOriginalItem = GetLocalObject(oChest, sKey);

    object oNewItem;
    if(oOriginalItem != OBJECT_INVALID) // item has not been restored yet
    {
        // replace current item with original
        IPCopyItemProperties(oOriginalItem, oItem);
        DestroyObject(oOriginalItem); // destroy dup item on player
        //DeleteLocalObject(oChest, GetResRef(oItem)); // so it won't be restored again
        DeleteLocalString(oItem, "PRC_NullPsionicsField_Item_UID");
    }
}

void SuppressItem(object oTrueSpeaker, object oTarget, int nBeats)
{
	// Break if they fail concentration or it runs out
	if (GetBreakConcentrationCheck(oTrueSpeaker) || nBeats == 0) return;

	// Remove and restore the properties
	RemoveAllProperties(oTarget, GetItemPossessor(oTarget));
	// Has to run before RemoveAll is called again
	DelayCommand(5.8, RestoreAllProperties(oTarget, GetItemPossessor(oTarget)));
	
	// Apply VFX
	effect eImp = EffectVisualEffect(VFX_IMP_PULSE_BOMB);
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eImp, GetItemPossessor(oTarget));
	
	DelayCommand(6.0, SuppressItem(oTrueSpeaker, oTarget, nBeats - 1));
}

void KarsiteOnHit(object oBinder, object oTarget)
{
	// If the target succeeds, bail
	if(PRCMySavingThrow(SAVING_THROW_WILL, oTarget, 10 + GetAbilityModifier(ABILITY_CHARISMA, oBinder), SAVING_THROW_TYPE_NONE)) return;
	
	object oItem;
	
	// If the right hand isn't suppressed, that gets priority
	if (!GetLocalInt(oTarget, "KarsiteSuppressRight"))
	{
		oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
		SuppressItem(oBinder, oItem, 1);
		SetLocalInt(oTarget, "KarsiteSuppressRight", TRUE);
		DelayCommand(5.8, DeleteLocalInt(oTarget, "KarsiteSuppressRight"));
	}
	else if (!GetLocalInt(oTarget, "KarsiteSuppressChest"))
	{
		oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget);
		SuppressItem(oBinder, oItem, 1);
		SetLocalInt(oTarget, "KarsiteSuppressChest", TRUE);
		DelayCommand(5.8, DeleteLocalInt(oTarget, "KarsiteSuppressChest"));
	}
	else if (!GetLocalInt(oTarget, "KarsiteSuppressLeft"))
	{
		oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
		SuppressItem(oBinder, oItem, 1);
		SetLocalInt(oTarget, "KarsiteSuppressLeft", TRUE);
		DelayCommand(5.8, DeleteLocalInt(oTarget, "KarsiteSuppressLeft"));
	}
}

//////////////////////////////////////////////////
/*       Void Main and Event Triggers           */
//////////////////////////////////////////////////

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("bnd_events running, event: " + IntToString(nEvent));

    // Get the PC. This is event-dependent
    object oBinder;
    switch(nEvent)
    {
        case EVENT_ITEM_ONHIT:          oBinder = OBJECT_SELF;               break;
        case EVENT_ONPLAYEREQUIPITEM:   oBinder = GetItemLastEquippedBy();   break;
        case EVENT_ONPLAYERUNEQUIPITEM: oBinder = GetItemLastUnequippedBy(); break;
        case EVENT_ONHEARTBEAT:         oBinder = OBJECT_SELF;               break;
        case EVENT_ONPLAYERREST_FINISHED:   oBinder = GetLastBeingRested();  break;
        case EVENT_ONACQUIREITEM:       oBinder = GetModuleItemAcquiredBy(); break;

        default:
            oBinder = OBJECT_SELF;
    }

    object oItem;
	object oSkin = GetPCSkin(oBinder);
	
    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
        // Hook in the events
        if(DEBUG) DoDebug("bnd_events: Adding eventhooks");
        AddEventScript(oBinder, EVENT_ONPLAYEREQUIPITEM,     "bnd_events", TRUE, FALSE);
        AddEventScript(oBinder, EVENT_ONPLAYERUNEQUIPITEM,   "bnd_events", TRUE, FALSE);
        AddEventScript(oBinder, EVENT_ONHEARTBEAT,           "bnd_events", TRUE, FALSE);
        AddEventScript(oBinder, EVENT_ONPLAYERREST_FINISHED, "bnd_events", TRUE, FALSE); 
        AddEventScript(oBinder, EVENT_ONACQUIREITEM        , "bnd_events", TRUE, FALSE); 
        
        if (GetHasSpellEffect(VESTIGE_RONOVE, oBinder) && !GetIsVestigeExploited(oBinder, VESTIGE_RONOVE_FISTS))
        {
        	SetLocalInt(oBinder, CALL_UNARMED_FEATS, TRUE);
        	SetLocalInt(oBinder, CALL_UNARMED_FISTS, TRUE); 
        }
    }
    else if(nEvent == EVENT_ITEM_ONHIT)
    {
        oItem          = GetSpellCastItem();
        object oTarget = PRCGetSpellTargetObject();
        if(DEBUG) DoDebug("bnd_events: OnHit:\n"
                        + "oBinder = " + DebugObject2Str(oBinder) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                        + "oTarget = " + DebugObject2Str(oTarget) + "\n"
                          );
        if(GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
        {
            if (GetHasSpellEffect(VESTIGE_AYM, oBinder) && GetLevelByClass(CLASS_TYPE_BINDER, oBinder) && !GetIsVestigeExploited(oBinder, VESTIGE_AYM_HALO_FIRE))
				AymHaloOfFire(oBinder, oTarget);
			if (GetHasSpellEffect(VESTIGE_EURYNOME, oBinder) && !GetIsVestigeExploited(oBinder, VESTIGE_EURYNOME_POISON))	
				EurynomePoisonBlood(oBinder, oTarget);
        }
        else // This is always a weapon
        {
        	if (GetHasSpellEffect(VESTIGE_VANUS, oBinder) && !GetIsVestigeExploited(oBinder, VESTIGE_VANUS_DISDAIN)) VanusDisdain(oBinder, oTarget);
        	if (GetHasSpellEffect(VESTIGE_MARCHOSIAS, oBinder) && !GetIsVestigeExploited(oBinder, VESTIGE_MARCHOSIAS_RETRIBUTION)) MarchosiasRetribution(oBinder, oTarget);
        }	
        // Melee weapon checks
        if(IPGetIsMeleeWeapon(oItem))
        {
        	if (GetHasSpellEffect(VESTIGE_TENEBROUS, oBinder) && !GetIsVestigeExploited(oBinder, VESTIGE_TENEBROUS_TOUCH_VOID))	TenebrousVoid(oBinder, oTarget);
        	if (GetHasSpellEffect(VESTIGE_SHAX, oBinder) && !GetIsVestigeExploited(oBinder, VESTIGE_SHAX_STORM_STRIKE))	ShaxStormStrike(oBinder, oTarget);
        	if (GetHasSpellEffect(VESTIGE_ELIGOR, oBinder) && !GetIsVestigeExploited(oBinder, VESTIGE_ELIGOR_STRIKE))	EligorChromatic(oBinder, oTarget);
        	if (GetRacialType(oBinder) == RACIAL_TYPE_KARSITE) KarsiteOnHit(oBinder, oTarget);
        }
    }// end if - Running OnHit event
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    {
        oItem = GetItemLastEquipped();
        if(DEBUG) DoDebug("bnd_events - OnEquip\n"
                        + "oBinder = " + DebugObject2Str(oBinder) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );
        if(GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
        {
        	// Can't get Aym from Bind Vestige feat
            if (GetHasSpellEffect(VESTIGE_AYM, oBinder) && GetLevelByClass(CLASS_TYPE_BINDER, oBinder) && !GetIsVestigeExploited(oBinder, VESTIGE_AYM_HALO_FIRE) || 
                (GetHasSpellEffect(VESTIGE_EURYNOME, oBinder) && !GetIsVestigeExploited(oBinder, VESTIGE_EURYNOME_POISON)) )
            {
		    	IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
		    	AddEventScript(oItem, EVENT_ITEM_ONHIT, "bnd_events", TRUE, FALSE);        	            
            }
        }
        // Melee weapon checks
        if(IPGetIsMeleeWeapon(oItem))
        {         
        	if (GetHasSpellEffect(VESTIGE_AYM, oBinder) && GetLevelByClass(CLASS_TYPE_BINDER, oBinder) && GetBinderLevel(oBinder, VESTIGE_AYM) >= 10 && !GetIsVestigeExploited(oBinder, VESTIGE_AYM_RUINOUS_ATTACK))
        	{
       			IPSafeAddItemProperty(oItem, ItemPropertyAttackBonus(5), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);        	
       			IPSafeAddItemProperty(oItem, ItemPropertyAttackPenalty(5), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);        	
       		}  
        	if (GetHasSpellEffect(VESTIGE_RONOVE, oBinder) && !GetIsVestigeExploited(oBinder, VESTIGE_RONOVE_COLD_IRON))
        	{
        		int nBonus = 1;
        		if (GetBinderLevel(oBinder, VESTIGE_RONOVE) >= 7) nBonus = 3;
       			IPSafeAddItemProperty(oItem, ItemPropertyAttackBonus(nBonus), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);        	
       			IPSafeAddItemProperty(oItem, ItemPropertyAttackPenalty(nBonus), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);        	
       		}  
       		if ((GetHasSpellEffect(VESTIGE_VANUS, oBinder) && !GetIsVestigeExploited(oBinder, VESTIGE_VANUS_DISDAIN)) ||
       		    (GetHasSpellEffect(VESTIGE_MARCHOSIAS, oBinder) && !GetIsVestigeExploited(oBinder, VESTIGE_MARCHOSIAS_RETRIBUTION)) ||
       		    (GetRacialType(oBinder) == RACIAL_TYPE_KARSITE)) 
       		{
            	AddEventScript(oItem, EVENT_ITEM_ONHIT, "bnd_events", TRUE, FALSE);
                IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);       		
            }    
       	}
       	// Any weapon
       	if (GetIsWeapon(oItem))
       	{
			if (GetLevelByClass(CLASS_TYPE_KNIGHT_SACRED_SEAL, oBinder))       	
			{
       			IPSafeAddItemProperty(oItem, ItemPropertyAttackBonus(3), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);        	
       			IPSafeAddItemProperty(oItem, ItemPropertyAttackPenalty(3), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);          	
       		}	
       	}
       	if (GetWeaponRanged(oItem))
       	{
       		if ((GetHasSpellEffect(VESTIGE_VANUS, oBinder) && !GetIsVestigeExploited(oBinder, VESTIGE_VANUS_DISDAIN)) ||
       		    (GetHasSpellEffect(VESTIGE_MARCHOSIAS, oBinder) && !GetIsVestigeExploited(oBinder, VESTIGE_MARCHOSIAS_RETRIBUTION)) )   
       		{
	        	IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            	AddEventScript(oItem, EVENT_ITEM_ONHIT, "bnd_events", TRUE, FALSE);
        
            	object oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS, oBinder);
            	IPSafeAddItemProperty(oAmmo, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            	AddEventScript(oAmmo, EVENT_ITEM_ONHIT, "bnd_events", TRUE, FALSE);
        
            	oAmmo = GetItemInSlot(INVENTORY_SLOT_BULLETS, oBinder);
            	IPSafeAddItemProperty(oAmmo, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            	AddEventScript(oAmmo, EVENT_ITEM_ONHIT, "bnd_events", TRUE, FALSE);

            	oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS, oBinder);
            	IPSafeAddItemProperty(oAmmo, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            	AddEventScript(oAmmo, EVENT_ITEM_ONHIT, "bnd_events", TRUE, FALSE);
            }          	
        }    
    }
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oBinder's weapon
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("bnd_events - OnUnEquip\n"
                        + "oBinder = " + DebugObject2Str(oBinder) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

		if (GetHasSpellEffect(VESTIGE_SAVNOK, oBinder) && !GetLocalInt(oBinder, "PactQuality"+IntToString(VESTIGE_SAVNOK)))
		{
			SavnokInfluence(oBinder, oItem);
		}
                          
        // Only applies to armours
        if(GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
        {
            // Remove the temporary OnHitCastSpell: Unique
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "bnd_events", TRUE, FALSE);       
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", 1, DURATION_TYPE_TEMPORARY);
        } 
        // Clean up weapons
        if(GetIsWeapon(oItem))
        {
            // Remove the attack bonus
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS, -1, -1, 1, "", -1, DURATION_TYPE_TEMPORARY);
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER, -1, -1, 1, "", -1, DURATION_TYPE_TEMPORARY);

            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "bnd_events", TRUE, FALSE);
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);
            object oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS, oBinder);
            RemoveSpecificProperty(oAmmo, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);
            oAmmo = GetItemInSlot(INVENTORY_SLOT_BULLETS, oBinder);
            RemoveSpecificProperty(oAmmo, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);
            oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS, oBinder);
            RemoveSpecificProperty(oAmmo, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);            
        }    
    }
    else if(nEvent == EVENT_ONHEARTBEAT)
    {
    	ExpelledVestigeCleanup(oBinder);
    	if (GetHasSpellEffect(VESTIGE_NABERIUS, oBinder) && GetLevelByClass(CLASS_TYPE_BINDER, oBinder) && !GetIsVestigeExploited(oBinder, VESTIGE_NABERIUS_ABILITY_HEALING)) NaberiusHeal(oBinder);
    	if (GetHasSpellEffect(VESTIGE_HAAGENTI, oBinder)) HaagentiTrans(oBinder);
        if (GetHasSpellEffect(VESTIGE_PAIMON, oBinder) && GetLevelByClass(CLASS_TYPE_BINDER, oBinder) && !GetIsVestigeExploited(oBinder, VESTIGE_PAIMON_BLADES)) 
        {
        	int nType = GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oBinder));
        	if (nType == BASE_ITEM_RAPIER || nType == BASE_ITEM_SHORTSWORD)
        		IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_FINESSE), 5.999, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);    	
        }	        
        if (GetHasSpellEffect(VESTIGE_ANDRAS, oBinder) && !GetLocalInt(oBinder, "PactQuality"+IntToString(VESTIGE_ANDRAS))) AndrasInfluence(oBinder);
        if (GetHasSpellEffect(VESTIGE_TENEBROUS, oBinder) && !GetIsVestigeExploited(oBinder, VESTIGE_TENEBROUS_SEE_DARKNESS)) ActionCastSpellOnSelf(SPELL_DARKVISION);
        if (GetHasSpellEffect(VESTIGE_GERYON, oBinder) && !GetIsVestigeExploited(oBinder, VESTIGE_GERYON_DARKNESS)) ActionCastSpellOnSelf(SPELL_DARKVISION);
		if (GetIsPatronVestigeBound(oBinder) && GetLevelByClass(CLASS_TYPE_KNIGHT_SACRED_SEAL, oBinder) >= 5)
		{
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageReduction(10, DAMAGE_POWER_PLUS_ONE), oBinder, 6.0);
			IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_OUTSIDER_RACIAL_TYPE), 5.999, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    	
		}
		if (GetHasSpellEffect(VESTIGE_CHUPOCLOPS_ETHEREAL_WATCHER, oBinder)) ChupoclopsEth(oBinder);
		if (GetHasSpellEffect(VESTIGE_VANUS, oBinder)) VanusInfluence(oBinder);
		if (GetHasSpellEffect(VESTIGE_DESHARIS, oBinder) && !GetIsVestigeExploited(oBinder, VESTIGE_DESHARIS_CITY_DWELLER)) CityDweller(oBinder);
	}	
    else if(nEvent == EVENT_ONPLAYERREST_FINISHED)    
    {
    	if (GetHasFeat(FEAT_RAPID_PACT_MAKING, oBinder)) DeleteLocalInt(oBinder, "RapidPactMaking");
		// Naberius's Skills
    	int i;
    	for(i = 0; i < 40 ; i++)
    	    DeleteLocalInt(oBinder, "NaberiusSkill"+IntToString(i));
    	DeleteLocalInt(oBinder, "RonovesFists");
    	DeleteLocalInt(oBinder, "AndrasMount");
    	DeleteLocalInt(oBinder, "AmonRam");
    	DeleteLocalInt(oBinder, "ExploitVestige");
    	if (GetLevelByClass(CLASS_TYPE_ANIMA_MAGE, oBinder))
    	{
    		SetLocalInt(oBinder, "BinderRested", TRUE);
    		DelayCommand(30.0, DeleteLocalInt(oBinder, "BinderRested"));
    	}	
    	DeleteLocalInt(oBinder, "PRC_WoLUses" + IntToString(VESTIGE_KARSUS_DISPEL));
    	DeleteLocalInt(oBinder, "PRC_WoLUses" + IntToString(VESTIGE_TENEBROUS_FLICKER));
    	DeleteLocalInt(oBinder, "PRC_WoLUses" + IntToString(VESTIGE_DANTALION_TRAVEL_SPELL));
    	DeleteLocalInt(oBinder, "PRC_WoLUses" + IntToString(VESTIGE_THE_TRIAD_SMITE));
    	DeleteLocalInt(oBinder, "PRC_WoLUses" + IntToString(19139));
    	DeleteLocalInt(oBinder, "ZceryllTS");
    	if (GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oBinder)) ReapplyTenebrous(oBinder);
    }     
    else if(nEvent == EVENT_ONACQUIREITEM)    
    {
    	oItem = GetModuleItemAcquired();
        if(DEBUG) DoDebug("bnd_events - OnAcquire\n"
                        + "oBinder = " + DebugObject2Str(oBinder) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );    	
                          
		if (GetHasSpellEffect(VESTIGE_ANDROMALIUS, oBinder) && !GetLocalInt(oBinder, "PactQuality"+IntToString(VESTIGE_ANDROMALIUS)))
		{
			if (GetStolenFlag(oItem))
			{
				FloatingTextStringOnCreature("Andromalius prevents you from taking a stolen item!", oBinder, FALSE);
            	AssignCommand(oBinder, ActionPutDownItem(oItem));
            	DelayCommand(2.0, CheckIsDropped(oBinder, oItem));				
			}
		}

		if (GetHasSpellEffect(VESTIGE_KARSUS, oBinder) && GetLevelByClass(CLASS_TYPE_BINDER, oBinder) && !GetIsVestigeExploited(oBinder, VESTIGE_KARSUS_WILL))
		{
        	int nType = GetBaseItemType(oItem);
        	if(nType == BASE_ITEM_MAGICWAND || nType == BASE_ITEM_ENCHANTED_WAND || nType == BASE_ITEM_MAGICSTAFF || nType == BASE_ITEM_CRAFTED_STAFF || nType == BASE_ITEM_BLANK_WAND || nType == BASE_ITEM_MAGICROD || nType == BASE_ITEM_CRAFTED_ROD)
        	{		
				IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByClass(CLASS_TYPE_BINDER), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);   
			}
		}	
    }      
}

	