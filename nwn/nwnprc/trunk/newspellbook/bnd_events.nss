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
	if (!GetHasSpellEffect(VESTIGE_ANDROMALIUS, oBinder) && GetLocalInt(oBinder, "AndroSneak"))
	{
		DeleteLocalInt(oBinder, "AndroSneak");
    	DelayCommand(0.1, ExecuteScript("prc_sneak_att", oBinder));    			
	}
	if (!GetHasSpellEffect(VESTIGE_MALPHAS, oBinder) && GetLocalInt(oBinder, "MalphasSneak"))
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
	// Checks for having naberius (and not having Disguise Self exploited), but missing the disguise self feat
	if (GetHasSpellEffect(VESTIGE_NABERIUS, oBinder) &&
	    GetLevelByClass(CLASS_TYPE_BINDER, oBinder) &&
	    !GetIsVestigeExploited(oBinder, VESTIGE_NABERIUS_DISGUISE_SELF) &&
	    !GetHasFeat(9033, oBinder))
	{
    	int i;
    	for(i = VESTIGE_AMON; i <= VESTIGE_ZURIEL; i++)
    	{
    		if(GetHasSpellEffect(i, oBinder)) 
    		{
    			RestoreVestigeSkinFeats(oBinder, i);
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

void AmunFirstbornScrub(object oBinder)
{
    effect eChk = GetFirstEffect(oBinder);
    while (GetIsEffectValid(eChk))
    {
        string sTag = GetEffectTag(eChk);
        if (sTag == "PRCFatigue" || sTag == "PRCExhausted" || sTag == "PRC_Fatigue" || sTag == "PRC_Exhausted" || sTag == "Fatigue" || sTag == "Exhausted")
        {
            RemoveEffect(oBinder, eChk);
        }
        eChk = GetNextEffect(oBinder);
    }
}

void AmunDelayDeathHeartbeat(object oBinder)
{
    if (!GetLocalInt(oBinder, "AmunDelayDeathActive"))
        return;

    int nMax = GetLocalInt(oBinder, "AmunDelayDeathMaxRounds");
    if (nMax <= 0)
        nMax = GetBinderLevel(oBinder, VESTIGE_AMUN_HER);
    int nUsed = GetLocalInt(oBinder, "AmunDelayDeathRoundsUsed");

    // If the Binder healed above 1 HP (or Gaia Troll regen unlocked), pause Delay Death consumption
    if (GetCurrentHitPoints(oBinder) > 1 || HasOtherPersistentImmortality(oBinder))
    {
        DeleteLocalInt(oBinder, "AmunDelayDeathActive");
        if (nUsed >= nMax && !HasAnyBinderImmortalProtection(oBinder))
            SetImmortal(oBinder, FALSE);
        return;
    }

    // If the round that just finished was the final daily round, expire Delay Death now
    if (nUsed >= nMax)
    {
        DeleteLocalInt(oBinder, "AmunDelayDeathActive");
        SetLocalInt(oBinder, "AmunDelayDeathRounds", 0);
        FloatingTextStringOnCreature("Delay Death: All daily rounds exhausted!", oBinder, FALSE);
        if (!HasAnyBinderImmortalProtection(oBinder))
            SetImmortal(oBinder, FALSE);
        return;
    }

    nUsed += 1;
    SetLocalInt(oBinder, "AmunDelayDeathRoundsUsed", nUsed);
    int nRem = PRCMax(0, nMax - nUsed);
    SetLocalInt(oBinder, "AmunDelayDeathRounds", nRem);
    FloatingTextStringOnCreature("Delay Death active (" + IntToString(nRem) + "/" + IntToString(nMax) + " rounds remaining today)", oBinder, FALSE);
}

void RestoreGaiaTrollRegenAfterFireAcid(object oCreature, int nLockGen)
{
    if (!GetIsObjectValid(oCreature) || GetLocalInt(oCreature, "GaiaRegenLockGen") != nLockGen)
        return;
    DeleteLocalInt(oCreature, "GaiaRegenFireAcidLock");
    if (GetIsDead(oCreature))
        return;

    int nPool = GetLocalInt(oCreature, "GaiaRegenPool");
    if (nPool > 0)
    {
        string sTag = GetIsObjectValid(GetLocalObject(oCreature, "GaiaRegenSourceBinder")) ? "GaiaSharedRegenEff" : "GaiaPlanetaryRegenEff";
        SetCreatureGaiaRegenEff(oCreature, nPool, sTag, HoursToSeconds(24));
    }
    if (GetLocalInt(oCreature, "GaiaRegenActive") && GetPRCSwitch(PRC_GAIA_PLANETARY_HEALING_NERF) < 2)
        SetImmortal(oCreature, TRUE);
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
        case EVENT_VIRTUAL_ONDAMAGED:   oBinder = OBJECT_SELF;               break;

        default:
            oBinder = OBJECT_SELF;
    }
    if (!GetIsObjectValid(oBinder))
        oBinder = OBJECT_SELF;

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
        if (GetLocalInt(oBinder, "GaiaRegenActive") ||
            GetHasSpellEffect(VESTIGE_GAIA, oBinder) ||
            GetHasSpellEffect(VESTIGE_AMUN_HER, oBinder) ||
            GetIsObjectValid(GetLocalObject(oBinder, "ZurielSacrificeBinder")))
        {
            AddEventScript(oBinder, EVENT_VIRTUAL_ONDAMAGED, "bnd_events", TRUE, FALSE);
            AddEventScript(oBinder, EVENT_NPC_ONDAMAGED, "bnd_events", TRUE, FALSE);
            if ((GetLocalInt(oBinder, "GaiaRegenActive") && !GetLocalInt(oBinder, "GaiaRegenFireAcidLock") && GetPRCSwitch(PRC_GAIA_PLANETARY_HEALING_NERF) < 2) ||
                HasActiveDelayDeathImmortal(oBinder))
            {
                SetImmortal(oBinder, TRUE);
            }
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
        	if (GetHasSpellEffect(VESTIGE_GAIA, oBinder) && !GetIsVestigeExploited(oBinder, VESTIGE_GAIA_EARTHS_FURY))
        	{
        		int nGaiaOnHitRace = MyPRCGetRacialType(oTarget);
        		if ((nGaiaOnHitRace == RACIAL_TYPE_ABERRATION || nGaiaOnHitRace == RACIAL_TYPE_CONSTRUCT ||
        		     nGaiaOnHitRace == RACIAL_TYPE_OOZE || nGaiaOnHitRace == RACIAL_TYPE_UNDEAD) &&
        		    GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT, oBinder))
        		{
        			// Gaia's Earth's FuryOnHit: bypasses native Bioware critical/sneak immunity on weapon hits
        			int nSneakDice = GetTotalSneakAttackDice(oBinder);
        			if (nSneakDice > 0 && GetCanSneakAttack(oTarget, oBinder))
        			{
        				ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(nSneakDice), DAMAGE_TYPE_BASE_WEAPON), oTarget);
        			}
        		}
        	}
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
       		    (GetHasSpellEffect(VESTIGE_GAIA, oBinder) && !GetIsVestigeExploited(oBinder, VESTIGE_GAIA_EARTHS_FURY)) ||
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
       		    (GetHasSpellEffect(VESTIGE_MARCHOSIAS, oBinder) && !GetIsVestigeExploited(oBinder, VESTIGE_MARCHOSIAS_RETRIBUTION)) ||
       		    (GetHasSpellEffect(VESTIGE_GAIA, oBinder) && !GetIsVestigeExploited(oBinder, VESTIGE_GAIA_EARTHS_FURY)) )   
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
		if (GetHasSpellEffect(VESTIGE_GAIA, oBinder) && !GetIsVestigeExploited(oBinder, VESTIGE_GAIA_PLANETARY_HEALING))
			ReconcileGaiaTrollImmunity(oBinder);
		if (GetHasSpellEffect(VESTIGE_AMUN_HER, oBinder) || GetLocalInt(oBinder, "AmunDelayDeathActive"))
		{
			if (GetHasSpellEffect(VESTIGE_AMUN_HER, oBinder) && !GetIsVestigeExploited(oBinder, VESTIGE_AMUN_HER_FIRSTBORN_GUARDIAN))
				AmunFirstbornScrub(oBinder);
			if (!GetIsVestigeExploited(oBinder, VESTIGE_AMUN_HER_DELAY_DEATH))
				AmunDelayDeathHeartbeat(oBinder);
		}
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
    	DeleteLocalInt(oBinder, "TkhalSphereRoundsUsed");
    	DeleteLocalInt(oBinder, "ZurielBronzeBodyRoundsUsed");
    	DeleteLocalInt(oBinder, "AmunDelayDeathRoundsUsed");
    	DeleteLocalInt(oBinder, "AmunDelayDeathActive");
    	if (GetHasSpellEffect(VESTIGE_AMUN_HER, oBinder) && !GetIsVestigeExploited(oBinder, VESTIGE_AMUN_HER_DELAY_DEATH))
    	{
    		int nAmunMax = GetBinderLevel(oBinder, VESTIGE_AMUN_HER);
    		SetLocalInt(oBinder, "AmunDelayDeathMaxRounds", nAmunMax);
    		SetLocalInt(oBinder, "AmunDelayDeathRounds", nAmunMax);
    		SetImmortal(oBinder, TRUE);
    	}
    	object oSph = GetLocalObject(oBinder, "TkhalSphereObj");
    	if (GetIsObjectValid(oSph)) DestroyObject(oSph);
    	DeleteLocalObject(oBinder, "TkhalSphereObj");
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
        	if(nType == BASE_ITEM_MAGICWAND || nType == BASE_ITEM_ENCHANTED_WAND 
			|| nType == BASE_ITEM_MAGICSTAFF || nType == BASE_ITEM_CRAFTED_STAFF 
			|| nType == BASE_ITEM_CRAFTED_SCEPTER			
			|| nType == BASE_ITEM_BLANK_WAND 
			|| nType == BASE_ITEM_MAGICROD || nType == BASE_ITEM_CRAFTED_ROD)
        	{		
				IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByClass(CLASS_TYPE_BINDER), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);   
			}
		}	
    }
    else if(nEvent == EVENT_VIRTUAL_ONDAMAGED || nEvent == EVENT_NPC_ONDAMAGED)
    {
        // 1. Zuriel's Ultimate Sacrifice: Redirect damage dealt to a visible ally by a single attack, spell, or ability onto the Binder instead (even if it kills the Binder)
        object oSacBinder = GetLocalObject(oBinder, "ZurielSacrificeBinder");
        if (GetIsObjectValid(oSacBinder) && oSacBinder != oBinder)
        {
            int bHasSacEff = FALSE;
            effect eSacChk = GetFirstEffect(oBinder);
            while (GetIsEffectValid(eSacChk))
            {
                if (GetEffectTag(eSacChk) == "ZurielUltimateSacrificeEff")
                {
                    bHasSacEff = TRUE;
                    break;
                }
                eSacChk = GetNextEffect(oBinder);
            }
            if (bHasSacEff && (GetHasSpellEffect(VESTIGE_ZURIEL, oSacBinder) || GetLocalObject(oSacBinder, "ZurielUltimateSacrificeTarget") == oBinder) && !GetIsDead(oSacBinder))
            {
                int nRedirectDmg = GetTotalDamageDealt();
                if (nRedirectDmg > 0)
                {
                    // Heal the warded ally for 100% of the damage from this single attack/spell/ability
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nRedirectDmg), oBinder);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_S), oBinder);

                    // Consume the single-attack ward and restore the ally's immortality state
                    effect eRemSac = GetFirstEffect(oBinder);
                    while (GetIsEffectValid(eRemSac))
                    {
                        if (GetEffectTag(eRemSac) == "ZurielUltimateSacrificeEff")
                            RemoveEffect(oBinder, eRemSac);
                        eRemSac = GetNextEffect(oBinder);
                    }
                    DeleteLocalObject(oBinder, "ZurielSacrificeBinder");
                    DeleteLocalObject(oSacBinder, "ZurielUltimateSacrificeTarget");
                    int bKeepAllyImm = GetLocalInt(oBinder, "ZurielSacPrevImmortal")
                        || (GetLocalInt(oBinder, "GaiaRegenActive") && !GetLocalInt(oBinder, "GaiaRegenFireAcidLock") && GetPRCSwitch(PRC_GAIA_PLANETARY_HEALING_NERF) < 2)
                        || HasActiveDelayDeathImmortal(oBinder);
                    DeleteLocalInt(oBinder, "ZurielSacPrevImmortal");
                    if (!bKeepAllyImm)
                        SetImmortal(oBinder, FALSE);

                    // Transfer the damage to the Binder preserving the per-damage-type breakdown (Ruling 4)
                    int nSumTyped = 0;
                    int nBitIdx;
                    for (nBitIdx = 0; nBitIdx < 13; nBitIdx++)
                    {
                        int nDType = 1 << nBitIdx;
                        int nPart = GetDamageDealtByType(nDType);
                        if (nPart > 0)
                        {
                            nSumTyped += nPart;
                            int nApplyType = (nDType == DAMAGE_TYPE_BASE_WEAPON) ? DAMAGE_TYPE_SLASHING : nDType;
                            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nPart, nApplyType, DAMAGE_POWER_ENERGY), oSacBinder);
                        }
                    }
                    if (nRedirectDmg > nSumTyped)
                    {
                        ApplyEffectToObject(
                            DURATION_TYPE_INSTANT,
                            EffectDamage(nRedirectDmg - nSumTyped, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_ENERGY),
                            oSacBinder
                        );
                    }
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_HOLY), oSacBinder);
                    FloatingTextStringOnCreature(
                        "Ultimate Sacrifice redirected " + IntToString(nRedirectDmg) + " damage from " + GetName(oBinder) + " to you!",
                        oSacBinder, FALSE
                    );
                    return;
                }
            }
            else
            {
                DeleteLocalObject(oBinder, "ZurielSacrificeBinder");
                int bKeepAllyImm = GetLocalInt(oBinder, "ZurielSacPrevImmortal")
                    || (GetLocalInt(oBinder, "GaiaRegenActive") && !GetLocalInt(oBinder, "GaiaRegenFireAcidLock") && GetPRCSwitch(PRC_GAIA_PLANETARY_HEALING_NERF) < 2)
                    || HasActiveDelayDeathImmortal(oBinder);
                DeleteLocalInt(oBinder, "ZurielSacPrevImmortal");
                if (!bKeepAllyImm)
                    SetImmortal(oBinder, FALSE);
            }
        }

        // 2. Gaia's Planetary Healing (controlled by PRC_GAIA_PLANETARY_HEALING_NERF: 0 = all shared >= 1 pt are Trolls, 1 = Option 1a single Troll, 2 = fast healing only):
        // Reconcile switch state first in case PRC_GAIA_PLANETARY_HEALING_NERF was modified mid-session.
        int bWasGaiaActive = GetLocalInt(oBinder, "GaiaRegenActive");
        object oGaiaOwner = GetLocalObject(oBinder, "GaiaRegenSourceBinder");
        if (!GetIsObjectValid(oGaiaOwner) && GetHasSpellEffect(VESTIGE_GAIA, oBinder))
            oGaiaOwner = oBinder;
        if (GetIsObjectValid(oGaiaOwner))
            ReconcileGaiaTrollImmunity(oGaiaOwner);

        if (bWasGaiaActive && !GetLocalInt(oBinder, "GaiaRegenActive") && !HasAnyBinderImmortalProtection(oBinder) && GetCurrentHitPoints(oBinder) <= 1)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDeath(FALSE, TRUE)), oBinder);
            return;
        }

        if (GetPRCSwitch(PRC_GAIA_PLANETARY_HEALING_NERF) < 2 && GetLocalInt(oBinder, "GaiaRegenActive"))
        {
            int nBypass = GetDamageDealtByType(DAMAGE_TYPE_FIRE) + GetDamageDealtByType(DAMAGE_TYPE_ACID);
            if (nBypass > 0)
            {
                string sRegTag = GetIsObjectValid(GetLocalObject(oBinder, "GaiaRegenSourceBinder")) ? "GaiaSharedRegenEff" : "GaiaPlanetaryRegenEff";
                effect eRem = GetFirstEffect(oBinder);
                while (GetIsEffectValid(eRem))
                {
                    if (GetEffectTag(eRem) == sRegTag)
                        RemoveEffect(oBinder, eRem);
                    eRem = GetNextEffect(oBinder);
                }
                int nLockGen = GetLocalInt(oBinder, "GaiaRegenLockGen") + 1;
                SetLocalInt(oBinder, "GaiaRegenLockGen", nLockGen);
                SetLocalInt(oBinder, "GaiaRegenFireAcidLock", TRUE);
                DelayCommand(6.0f, RestoreGaiaTrollRegenAfterFireAcid(oBinder, nLockGen));

                if (!HasAnyBinderImmortalProtection(oBinder))
                {
                    SetImmortal(oBinder, FALSE);
                    if (GetCurrentHitPoints(oBinder) <= 1)
                    {
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDeath(FALSE, TRUE)), oBinder);
                        return;
                    }
                }
            }
            else if (!GetLocalInt(oBinder, "GaiaRegenFireAcidLock"))
            {
                if (GetCurrentHitPoints(oBinder) <= 1 && !GetLocalInt(oBinder, "GaiaRegenKnockdownLock"))
                {
                    SetLocalInt(oBinder, "GaiaRegenKnockdownLock", TRUE);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectKnockdown()), oBinder, 6.0f);
                    DelayCommand(6.0f, DeleteLocalInt(oBinder, "GaiaRegenKnockdownLock"));
                }
            }
        }

        // 3. Amun-her Khepeshef's Reactive Delay Death:
        // Stays dormant until a hit drops the Binder to 1 HP (while no other persistent immortality is active),
        // then activates and ticks down the 1 round/level daily pool only while at 1 HP.
        if (CanTriggerAmunDelayDeath(oBinder) && GetCurrentHitPoints(oBinder) <= 1)
        {
            if (!GetLocalInt(oBinder, "AmunDelayDeathActive"))
            {
                int nMax = GetLocalInt(oBinder, "AmunDelayDeathMaxRounds");
                if (nMax <= 0)
                    nMax = GetBinderLevel(oBinder, VESTIGE_AMUN_HER);
                int nUsed = GetLocalInt(oBinder, "AmunDelayDeathRoundsUsed") + 1;
                SetLocalInt(oBinder, "AmunDelayDeathRoundsUsed", nUsed);
                int nRem = PRCMax(0, nMax - nUsed);
                SetLocalInt(oBinder, "AmunDelayDeathRounds", nRem);
                SetLocalInt(oBinder, "AmunDelayDeathActive", TRUE);
                SetImmortal(oBinder, TRUE);

                if (nUsed >= nMax)
                {
                    FloatingTextStringOnCreature("Delay Death triggered (final daily round active)!", oBinder, FALSE);
                }
                else
                {
                    FloatingTextStringOnCreature("Delay Death triggered! (" + IntToString(nRem) + "/" + IntToString(nMax) + " rounds remaining today)", oBinder, FALSE);
                }
            }
        }
    }
}
