//::///////////////////////////////////////////////
//:: Tome of Battle feats
//:: tob_feats
//::///////////////////////////////////////////////
/** @file
    Does all ToB feats that require event scripting.

    @author Stratovarius
    @date   Created - 2018.9.22
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "tob_inc_tobfunc"
#include "psi_inc_psifunc"
#include "prc_inc_combmove"
#include "x0_i0_modes"

//////////////////////////////////////////////////
/*             Feat Functions                   */
//////////////////////////////////////////////////

// Called on Heartbeat
void ShadowBlade(object oInitiator)
{
    // Needs an active Shadow Hands stance
    int nStance    = GetHasActiveStance(oInitiator);
    int nDisc      = GetDisciplineByManeuver(nStance);
    int nDex       = GetAbilityModifier(ABILITY_DEXTERITY, oInitiator);
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
    int nWeap      = GetIsDisciplineWeapon(oWeapon, DISCIPLINE_SHADOW_HAND);
    
    // Must be a shadow hand weapon while a stance is active
    if (nDisc == DISCIPLINE_SHADOW_HAND && nWeap)
    {   
        int nDamageType = GetWeaponDamageType(oWeapon);
		if(DEBUG) DoDebug("tob_feats >> ShadowBlade(): " + IntToString(nDex) +": extra points of "+IntToString(nDamageType)+" Damage.");
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectDamageIncrease(IPGetDamageBonusConstantFromNumber(nDex), nDamageType)), oInitiator, 6.0); 
        SetLocalInt(oInitiator, "ShadowBladeDam", nDex);
        DelayCommand(6.0, DeleteLocalInt(oInitiator, "ShadowBladeDam"));
    }
}    

// Called on Heartbeat
void RapidAssault(object oInitiator)
{
    int nCombat = GetIsInCombat(oInitiator);
    int nLast   = GetLocalInt(oInitiator, "RapidAssault");
    
    // Must must be in combat this round but not last round
    if (nCombat == TRUE && nLast == FALSE)
    {   
        object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
        int nDamageType = GetWeaponDamageType(oWeapon);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectDamageIncrease(DAMAGE_BONUS_1d6, nDamageType)), oInitiator, 6.0); 
    }
    SetLocalInt(oInitiator, "RapidAssault", nCombat);
}  

// Called on heartbeat
void DesertWindDodge(object oInitiator)
{
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectACIncrease(1, AC_DODGE_BONUS)), oInitiator, 6.0);
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
    int nWeap      = GetIsDisciplineWeapon(oWeapon, DISCIPLINE_DESERT_WIND);
    if (nWeap)
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_FIRE)), oInitiator, 6.0);    
}

// Called on heartbeat
void DesertFire(object oInitiator)
{
    SetLocalInt(oInitiator, "DesertFire", TRUE);
    DelayCommand(5.9, DeleteLocalInt(oInitiator, "DesertFire"));
}

// Called on heartbeat
void DesertWind(object oInitiator)
{
        // Check to see if the WP is valid
        string sWPTag = "PRC_DWDWP_" + GetName(oInitiator);
        object oTestWP = GetWaypointByTag(sWPTag);
        if (!GetIsObjectValid(oTestWP))
        {
            // Create waypoint for the movement
            CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", GetLocation(oInitiator), FALSE, sWPTag);
            if(DEBUG) DoDebug("tob_feats: Desert Wind Dodge WP for " + DebugObject2Str(oInitiator) + " didn't exist, creating. Tag: " + sWPTag);
        }
        else // We have a test waypoint, now to check the distance
        {
            // Distance moved in the last round
            float fDist = GetDistanceBetween(oInitiator, oTestWP);
            // Distance needed to move
            float fCheck = FeetToMeters(10.0);

            // Now clean up the WP and create a new one for next round's check
            DestroyObject(oTestWP);
            CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", GetLocation(oInitiator), FALSE, sWPTag);

            if(DEBUG) DoDebug("tob_feats: Moved enough: " + DebugBool2String(fDist >= fCheck));

            // Moved the distance
            if (fDist >= fCheck)
            {
                if(GetHasFeat(FEAT_DESERT_WIND_DODGE, oInitiator)) DesertWindDodge(oInitiator);
                if(GetHasFeat(FEAT_DESERT_FIRE, oInitiator)) DesertFire(oInitiator);
            }
        }    
}

// Called on False
void BladeMeditation(object oInitiator)
{
    int nDisc = BladeMeditationFeat(oInitiator);
    object oSkin = GetPCSkin(oInitiator);
    int nSkill = GetDisciplineSkill(nDisc);
    SetCompositeBonus(oSkin, "BladeMeditation", 2, ITEM_PROPERTY_SKILL_BONUS, nSkill);
}

// Called on Heartbeat
void IronheartAura(object oInitiator)
{
    int nDisc = GetDisciplineByManeuver(GetHasActiveStance(oInitiator));
    if (nDisc == DISCIPLINE_IRON_HEART)
    {    
        location lTarget = GetLocation(oInitiator);
        // Use the function to get the closest creature as a target
        object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        while(GetIsObjectValid(oAreaTarget))
        {
            if(oAreaTarget != oInitiator && // Not you
               GetIsInMeleeRange(oInitiator, oAreaTarget) && // They must be in melee range
               GetIsFriend(oAreaTarget, oInitiator)) // Only allies
            {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL)), oAreaTarget, 6.0);
            }
        //Select the next target within the spell shape.
        oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        }    
    }    
}

// Called on heartbeat
void ShadowTrickster(object oInitiator)
{
    // Needs an active Shadow Hands stance
    int nStance = GetHasActiveStance(oInitiator);
    int nDisc   = GetDisciplineByManeuver(nStance);
    if (nDisc == DISCIPLINE_SHADOW_HAND)
    {
        SetLocalInt(oInitiator, "ShadowTrickster", TRUE);
    }
    else
        DeleteLocalInt(oInitiator, "ShadowTrickster");
}

// Called on Heartbeat
void WhiteRavenDefense(object oInitiator)
{
    int nDisc = GetDisciplineByManeuver(GetHasActiveStance(oInitiator));
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
    int nWeap      = GetIsDisciplineWeapon(oWeapon, DISCIPLINE_WHITE_RAVEN); 
    int nAlly = FALSE;
    if (nDisc == DISCIPLINE_WHITE_RAVEN)
    {    
        location lTarget = GetLocation(oInitiator);

        // Use the function to get the closest creature as a target
        object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        while(GetIsObjectValid(oAreaTarget))
        {
            if(oAreaTarget != oInitiator && // Not you
               GetIsInMeleeRange(oInitiator, oAreaTarget) && // They must be in melee range
               GetIsFriend(oAreaTarget, oInitiator)) // Only allies
            {
                if (nWeap) ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectACIncrease(1)), oAreaTarget, 6.0);
                nAlly = TRUE;
            }
        //Select the next target within the spell shape.
        oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        }    
    }
    
    if (nAlly)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectACIncrease(1)), oInitiator, 6.0);
    }
}

void DevotedBulwark(object oInitiator, object oTarget)
{
    //only trigger if it was a melee weapon
    if(GetIsInMeleeRange(oInitiator, oTarget))
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectACIncrease(1), oInitiator, 6.0f);
    }
}

void SnapKick(object oInitiator, object oTarget)
{
    if (GetLocalInt(oInitiator, "SnapKickDelay") == TRUE) return; //Once a round only
    else
    {
        SetLocalInt(oInitiator, "SnapKickDelay", TRUE);
        DelayCommand(6.0, DeleteLocalInt(oInitiator, "SnapKickDelay"));
    }    

    object oWeap = GetItemInSlot(INVENTORY_SLOT_ARMS, oInitiator); // It's an unarmed attack, so we get the gloves
    int nAttack = GetAttackRoll(oTarget, oInitiator, oWeap);
    if (nAttack > 0) // We hit
    {
        FloatingTextStringOnCreature("Snap Kick Hit", oInitiator, FALSE);
        int nCrit = FALSE;
        if (nAttack == 2) nCrit = TRUE;
        effect eDam = GetAttackDamage(oTarget, oInitiator, oWeap, GetWeaponBonusDamage(oWeap, oTarget), GetMagicalBonusDamage(oInitiator, oTarget), 1, 0, nCrit); //off-hand attack to get 1/2 strength bonus
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget); 
    }
    else
       FloatingTextStringOnCreature("Snap Kick Miss", oInitiator, FALSE); 
}

void ThreeMountains(object oInitiator, object oTarget)
{
    // Check for a first hit
    int nHit = GetLocalInt(oTarget, "ThreeMountains");
    
    if (!nHit)
    {
        SetLocalInt(oTarget, "ThreeMountains", TRUE);
        DelayCommand(6.0, DeleteLocalInt(oTarget, "ThreeMountains"));
    }    
    else // Hit them twice in six seconds
    {
        int nDC = 10 + GetHitDice(oInitiator)/2 + GetAbilityModifier(ABILITY_STRENGTH, oInitiator);
        if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE, oInitiator))
        {
            effect eLink = EffectLinkEffects(EffectSpellFailure(), EffectAttackDecrease(20));
            SetBaseAttackBonus(1, oTarget);
            effect eLink2 = EffectLinkEffects(EffectVisualEffect(VFX_IMP_DISEASE_S), EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE_RED));
            DelayCommand(6.0, RestoreBaseAttackBonus(oTarget));            
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eLink), oTarget, RoundsToSeconds(1));        
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink2, oTarget);
        }    
        DeleteLocalInt(oTarget, "ThreeMountains");
    }        
}

void VaeSchool(object oInitiator, object oTarget)
{
    if (GetLocalInt(oInitiator, "VaeSchool") == TRUE) return; //Once a round only
    else
    {
        SetLocalInt(oInitiator, "VaeSchool", TRUE);
        DelayCommand(6.0, DeleteLocalInt(oInitiator, "VaeSchool"));
    } 
    
    DoTrip(oInitiator, oTarget, 0, FALSE, FALSE, TRUE);
}

void InlindlSchool(object oInitiator)
{
    if (GetIsLightWeapon(oInitiator) && GetLocalInt(oInitiator, "InlindlSchool"))
    {
        int nShield = GetItemACValue(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oInitiator));
        effect eLink = EffectLinkEffects(EffectACDecrease(nShield), EffectAttackIncrease(nShield/2));
        eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_ARMOR_OF_DARKNESS));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eLink), oInitiator, 6.0); 
    }
}

void XaniqosSchool(object oInitiator, object oTarget, object oItem, int nEvent)
{
    int nType = GetBaseItemType(oItem);
/*     if(nEvent == EVENT_ITEM_ONHIT)  //:: handled in prc_onhitcast becuase it wasn't stacking w/ Skirmish
    {
        if(GetLocalInt(oInitiator, "XaniqosSchool") && IPGetIsProjectile(oItem))  // oItem is the ammo, since it's only applies to crossbows
        {    
            effect eDam = EffectDamage(d6(), DAMAGE_TYPE_PIERCING);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget); 
        }    
    }  */   
    if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    {    
        if (nType == BASE_ITEM_LIGHTCROSSBOW || nType == BASE_ITEM_HEAVYCROSSBOW)
        {
            object oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS, oInitiator);
            IPSafeAddItemProperty(oAmmo, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            AddEventScript(oAmmo, EVENT_ITEM_ONHIT, "tob_feats", TRUE, FALSE);
        }
    }    
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        if (nType == BASE_ITEM_LIGHTCROSSBOW || nType == BASE_ITEM_HEAVYCROSSBOW)
        {    
            object oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS, oInitiator);
            RemoveSpecificProperty(oAmmo, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);
            RemoveEventScript(oAmmo, EVENT_ITEM_ONHIT, "tob_feats", TRUE, FALSE);
        }    
    }    
    else if(nEvent == EVENT_ONHEARTBEAT)
    {            
        // Check to see if the WP is valid
        string sWPTag = "XaniqosWP_" + GetName(oInitiator);
        object oTestWP = GetWaypointByTag(sWPTag);
        if (!GetIsObjectValid(oTestWP))
        {
            // Create waypoint for the movement
            CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", GetLocation(oInitiator), FALSE, sWPTag);
            if(DEBUG) DoDebug("tob_feats: Xaniqos WP for " + DebugObject2Str(oInitiator) + " didn't exist, creating. Tag: " + sWPTag);
        }
        else // We have a test waypoint, now to check the distance
        {
            // Distance moved in the last round
            float fDist = GetDistanceBetween(oInitiator, oTestWP);
            // Distance needed to move
            float fCheck = FeetToMeters(10.0);

            // Now clean up the WP and create a new one for next round's check
            DestroyObject(oTestWP);
            CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", GetLocation(oInitiator), FALSE, sWPTag);

            if(DEBUG) DoDebug("tob_feats: Moved enough: " + DebugBool2String(fDist >= fCheck));

            // Moved the distance
            if (fDist >= fCheck)
            {
                // We have moved far enough
                SetLocalInt(oInitiator, "XaniqosSchool", TRUE);
                // Only lasts for a round
                DelayCommand(6.0, DeleteLocalInt(oInitiator, "XaniqosSchool"));
            }
        }
    }    
}

void ShieldWall(object oInitiator)
{
    int nBase = GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oInitiator));
    if (nBase == BASE_ITEM_SMALLSHIELD || nBase == BASE_ITEM_LARGESHIELD || nBase == BASE_ITEM_TOWERSHIELD)
    {
        location lTarget = GetLocation(oInitiator);
        // Use the function to get the closest creature as a target
        object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        while(GetIsObjectValid(oAreaTarget))
        {
            if(oAreaTarget != oInitiator && // Not you
               GetIsInMeleeRange(oInitiator, oAreaTarget) && // They must be in melee range
               GetIsFriend(oAreaTarget, oInitiator)) // Only allies
            {
                int nBase2 = GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oAreaTarget));
                if (nBase2 == BASE_ITEM_SMALLSHIELD || nBase2 == BASE_ITEM_LARGESHIELD || nBase2 == BASE_ITEM_TOWERSHIELD) //Ally must have a shield
                {
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectACIncrease(2, AC_SHIELD_ENCHANTMENT_BONUS)), oAreaTarget, 6.0);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectACIncrease(2, AC_SHIELD_ENCHANTMENT_BONUS)), oInitiator, 6.0);
                }    
            }
        //Select the next target within the spell shape.
        oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        }
    }
}

void CrossbowSniper(object oInitiator, object oItem, int nEvent)
{
    int nType = GetBaseItemType(oItem);
    int nDex  = GetAbilityModifier(ABILITY_DEXTERITY, oInitiator);
    if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    {    
        if ((nType == BASE_ITEM_LIGHTCROSSBOW && GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_CROSSBOW, oInitiator)) || 
            (nType == BASE_ITEM_HEAVYCROSSBOW && GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_CROSSBOW, oInitiator)))
        {
            object oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS, oInitiator);
            IPSafeAddItemProperty(oAmmo, ItemPropertyDamageBonus(DAMAGE_TYPE_PIERCING, IPDamageConstant(nDex/2)), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
    }    
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        if ((nType == BASE_ITEM_LIGHTCROSSBOW && GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_CROSSBOW, oInitiator)) || 
            (nType == BASE_ITEM_HEAVYCROSSBOW && GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_CROSSBOW, oInitiator)))
        {    
            object oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS, oInitiator);
            RemoveSpecificProperty(oAmmo, ITEM_PROPERTY_DAMAGE_BONUS, DAMAGE_TYPE_PIERCING, IPDamageConstant(nDex/2), 1, "", -1, DURATION_TYPE_TEMPORARY);
        }    
    }
}   

void ExpeditiousDodge(object oInitiator)
{
    // Check to see if the WP is valid
    string sWPTag = "ExpeditiousWP_" + GetName(oInitiator);
    object oTestWP = GetWaypointByTag(sWPTag);
    if (!GetIsObjectValid(oTestWP))
    {
        // Create waypoint for the movement
        CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", GetLocation(oInitiator), FALSE, sWPTag);
        if(DEBUG) DoDebug("tob_feats: Expeditious WP for " + DebugObject2Str(oInitiator) + " didn't exist, creating. Tag: " + sWPTag);
    }
    else // We have a test waypoint, now to check the distance
    {
        // Distance moved in the last round
        float fDist = GetDistanceBetween(oInitiator, oTestWP);
        // Distance needed to move
        float fCheck = FeetToMeters(40.0);

        // Now clean up the WP and create a new one for next round's check
        DestroyObject(oTestWP);
        CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", GetLocation(oInitiator), FALSE, sWPTag);

        if(DEBUG) DoDebug("tob_feats: Moved enough: " + DebugBool2String(fDist >= fCheck));

        // Moved the distance
        if (fDist >= fCheck)
        {
            // We have moved far enough
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectACIncrease(2, AC_DODGE_BONUS)), oInitiator, 6.0); 
        }
    }
}

void CrescentMoon(object oInitiator, object oTarget)
{
    int nRight = GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator));
    int nLeft  = GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oInitiator));
    if (nLeft == BASE_ITEM_DAGGER && (nRight == BASE_ITEM_SCIMITAR || nRight == BASE_ITEM_LONGSWORD || nRight == BASE_ITEM_BASTARDSWORD || nRight == BASE_ITEM_SHORTSWORD))
    {
        int nHits  = GetLocalInt(oTarget, "CrescentMoon");          // Check hits
        if (nHits == 2)
        {
            nHits = 0;
            // Free disarm attempt, once a round, per target
            if (!GetLocalInt(oTarget, "CrescentMoonDelay"))
            {
                DoDisarm(oInitiator, oTarget);
                SetLocalInt(oTarget, "CrescentMoonDelay", TRUE);
                DelayCommand(6.0, DeleteLocalInt(oTarget, "CrescentMoonDelay"));
            }    
        }
        else
            nHits++;
            
        SetLocalInt(oTarget, "CrescentMoon", nHits); // Store the hits
    }
} 

void QuickStaff(object oInitiator)
{
        // Only applies when using expertise
        if(GetModeActive(ACTION_MODE_EXPERTISE) || GetActionMode(oInitiator, ACTION_MODE_EXPERTISE) || GetLastAttackMode(oInitiator) == COMBAT_MODE_EXPERTISE ||
           GetModeActive(ACTION_MODE_IMPROVED_EXPERTISE) || GetActionMode(oInitiator, ACTION_MODE_IMPROVED_EXPERTISE) || GetLastAttackMode(oInitiator) == COMBAT_MODE_IMPROVED_EXPERTISE)
        {
           ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectACIncrease(2), oInitiator, 6.0);
        }
}

void BearFangGrapple(object oInitiator, object oTarget)
{
    DoGrapple(oInitiator, oTarget, 0, FALSE, TRUE);
}

void BearFang(object oInitiator, object oTarget)
{
    int nRight = GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator));
    int nLeft  = GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oInitiator));
    if (nLeft == BASE_ITEM_DAGGER && (nRight == BASE_ITEM_BATTLEAXE || nRight == BASE_ITEM_HANDAXE || nRight == BASE_ITEM_DWARVENWARAXE))
    {
        int nHits  = GetLocalInt(oTarget, "BearFang");          // Check hits
        if (nHits == 2)
        {
            SetLocalInt(oInitiator, "BearFangGrapple", TRUE);
            ForceUnequip(oInitiator, GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator), INVENTORY_SLOT_RIGHTHAND);               
            DelayCommand(0.6, BearFangGrapple(oInitiator, oTarget));
            DeleteLocalInt(oInitiator, "BearFang");
        }
        else
            nHits++;
            
        SetLocalInt(oTarget, "BearFang", nHits); // Store the hits
    }
} 

void BearFangHB(object oInitiator)
{
    // Resets every round
    DeleteLocalInt(oInitiator, "BearFang");
}

void ImprovedRapidShot(object oInitiator)
{
    // Only applies when using Rapid Shot
    if(GetModeActive(ACTION_MODE_RAPID_SHOT) || GetActionMode(oInitiator, ACTION_MODE_RAPID_SHOT) || GetLastAttackMode(oInitiator) == COMBAT_MODE_RAPID_SHOT)
    {
       ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAttackIncrease(2), oInitiator, 6.0);
    }
}

void DireFlailSmash(object oInitiator, object oTarget)
{
    // Check for a first hit
    int nHit = GetLocalInt(oTarget, "DireFlailSmash");
    
    if (!nHit)
    {
        SetLocalInt(oTarget, "DireFlailSmash", TRUE);
        DelayCommand(6.0, DeleteLocalInt(oTarget, "DireFlailSmash"));
    }    
    else // Hit them twice in six seconds
    {
        int nDC = 10 + GetHitDice(oInitiator)/2 + GetAbilityModifier(ABILITY_STRENGTH, oInitiator);
        if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE, oInitiator))
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectDazed()), oTarget, RoundsToSeconds(1));        
        }    
        DeleteLocalInt(oTarget, "DireFlailSmash");
    }        
}

void ShieldSpecialization(object oInitiator)
{
	object oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oInitiator);
    // Shield specialization
    if((GetBaseItemType(oItem) == BASE_ITEM_SMALLSHIELD && GetHasFeat(FEAT_SHIELD_SPECIALIZATION_LIGHT, oInitiator)) 
		|| (GetBaseItemType(oItem) == BASE_ITEM_LARGESHIELD && GetHasFeat(FEAT_SHIELD_SPECIALIZATION_HEAVY, oInitiator)))
    {
		itemproperty ip = GetFirstItemProperty(oItem);
		int iTemp;
		while(GetIsItemPropertyValid(ip))
		{
			int iIpType = GetItemPropertyType(ip);
			if (iIpType == ITEM_PROPERTY_AC_BONUS)
			{
	            iTemp = GetItemPropertyCostTableValue(ip);
	            break;
	        }    

			ip = GetNextItemProperty(oItem);
		}	
		if (DEBUG) DoDebug("Adding Shield Specialization bonus of "+IntToString(iTemp+1));
		IPSafeAddItemProperty(oItem, ItemPropertyACBonus(iTemp+1), 5.95, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
  	} 
}  	

void FocusedShield(object oInitiator)
{
	object oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oInitiator);
    int nBase = GetBaseItemType(oItem);
    if ((nBase == BASE_ITEM_SMALLSHIELD || nBase == BASE_ITEM_LARGESHIELD || nBase == BASE_ITEM_TOWERSHIELD) && GetIsPsionicallyFocused(oInitiator))
    {
		itemproperty ip = GetFirstItemProperty(oItem);
		int iTemp;
		while(GetIsItemPropertyValid(ip))
		{
			int iIpType = GetItemPropertyType(ip);
			if (iIpType == ITEM_PROPERTY_AC_BONUS)
			{
	            iTemp = GetItemPropertyCostTableValue(ip);
	            break;
	        }    

			ip = GetNextItemProperty(oItem);
		}	
		//FloatingTextStringOnCreature("Adding Focused Shield bonus of "+IntToString(iTemp+1), oInitiator, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyACBonus(iTemp+1), 5.95, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
  	} 
} 

void Shieldmate(object oInitiator)
{
	// Have to be awake and aware to count
   	if (PRCGetHasEffect(EFFECT_TYPE_CONFUSED, oInitiator) || PRCGetHasEffect(EFFECT_TYPE_DOMINATED, oInitiator) || PRCGetHasEffect(EFFECT_TYPE_DAZED, oInitiator)   ||
        PRCGetHasEffect(EFFECT_TYPE_PETRIFY, oInitiator) || PRCGetHasEffect(EFFECT_TYPE_PARALYZE, oInitiator)   || PRCGetHasEffect(EFFECT_TYPE_SLEEP, oInitiator)   ||
        PRCGetHasEffect(EFFECT_TYPE_STUNNED, oInitiator) || PRCGetHasEffect(EFFECT_TYPE_FRIGHTENED, oInitiator) || GetGrapple(oInitiator))
    {    
    	return;
    }	

    int nBase = GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oInitiator));
    if (nBase == BASE_ITEM_SMALLSHIELD || nBase == BASE_ITEM_LARGESHIELD || nBase == BASE_ITEM_TOWERSHIELD)
    {
        location lTarget = GetLocation(oInitiator);
        // Use the function to get the closest creature as a target
        object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        while(GetIsObjectValid(oAreaTarget))
        {
            if(oAreaTarget != oInitiator && // Not you
               GetIsInMeleeRange(oInitiator, oAreaTarget) && // They must be in melee range
               GetIsFriend(oAreaTarget, oInitiator)) // Only allies
            {
            	int nBonus = 1;
            	if (nBase == BASE_ITEM_TOWERSHIELD) nBonus += 1;
            	if (GetHasFeat(FEAT_IMPROVED_SHIELDMATE, oInitiator)) nBonus += 1;
	            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectACIncrease(nBonus, AC_SHIELD_ENCHANTMENT_BONUS)), oAreaTarget, 6.0);
            }
        //Select the next target within the spell shape.
        oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        }
    }
}

void RethDekalaAura(object oInitiator)
{
    location lTarget = GetLocation(oInitiator);
    // Use the function to get the closest creature as a target
    object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oAreaTarget))
    {
        if(oAreaTarget != oInitiator && // Not you. Hits everyone else though, even allies.
           GetIsInMeleeRange(oInitiator, oAreaTarget)) // They must be in melee range
        {
        	int nDamage = d6();
        	int nDC = 10 + GetHitDice(oInitiator)/2 + GetAbilityModifier(ABILITY_CONSTITUTION, oInitiator);
        	if(!PRCMySavingThrow(SAVING_THROW_FORT, oAreaTarget, nDC, SAVING_THROW_TYPE_NONE))
        	{
        		// Half fire, half acid
            	ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDamage(nDamage/2, DAMAGE_TYPE_FIRE)), oAreaTarget);
            	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FLAME_M), oAreaTarget);
            	// The +1 makes acid round up instead of round down, so you don't miss out on odd numbers
            	ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDamage((nDamage+1)/2, DAMAGE_TYPE_ACID)), oAreaTarget);
            	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_ACID_L), oAreaTarget);
            	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectSickened()), oAreaTarget, 6.0);
            }
        }
    //Select the next target within the spell shape.
    oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }	
} 

void HadrimoiPerfectSymmetry(object oInitiator)
{
    int nSize     = PRCGetCreatureSize(oInitiator);
    object oSkin  = GetPCSkin(oInitiator);
    object oItemR = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
    int nWeaponSizeR = GetWeaponSize(oItemR);
    object oItemL = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oInitiator);
    int nWeaponSizeL = GetWeaponSize(oItemL);    
    // is the size appropriate for a light weapon?
    if (nWeaponSizeR < nSize && nWeaponSizeL < nSize)
    {
    	SetLocalInt(oInitiator, "HadrimoiPerfectSymmetry", TRUE);
    	IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_AMBIDEXTROUS), 9999.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    	IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_TWO_WEAPON_FIGHTING), 9999.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    	//int nBAB = GetBaseAttackBonus(oInitiator);
    	SetCompositeAttackBonus(oInitiator, "HadrimoiPerfectSymmetry", 2, ATTACK_BONUS_MISC);
        /*object oWP = GetObjectToApplyNewEffect("WP_HadrimoiPerfectSymmetry", oInitiator, TRUE);
        AssignCommand(oWP, ActionDoCommand(ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectModifyAttacks(nAttackCount-1)), oInitiator)));*/    	
    }
    else
    {
    	DeleteLocalInt(oInitiator, "HadrimoiPerfectSymmetry");
    	RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT, IP_CONST_FEAT_AMBIDEXTROUS, -1, -1, "", -1, DURATION_TYPE_TEMPORARY);
    	RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT, IP_CONST_FEAT_TWO_WEAPON_FIGHTING, -1, -1, "", -1, DURATION_TYPE_TEMPORARY);
    	SetCompositeAttackBonus(oInitiator, "HadrimoiPerfectSymmetry", 0, ATTACK_BONUS_MISC);
    	/*object oWP = GetObjectToApplyNewEffect("WP_HadrimoiPerfectSymmetry", oInitiator, TRUE);*/
    }
}

//////////////////////////////////////////////////
/*       Void Main and Event Triggers           */
//////////////////////////////////////////////////

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("tob_feats running, event: " + IntToString(nEvent));

    // Get the PC. This is event-dependent
    object oInitiator;
    switch(nEvent)
    {
        case EVENT_ITEM_ONHIT:          oInitiator = OBJECT_SELF;               break;
        case EVENT_ONPLAYEREQUIPITEM:   oInitiator = GetItemLastEquippedBy();   break;
        case EVENT_ONPLAYERUNEQUIPITEM: oInitiator = GetItemLastUnequippedBy(); break;
        case EVENT_ONHEARTBEAT:         oInitiator = OBJECT_SELF;               break;

        default:
            oInitiator = OBJECT_SELF;
    }

    object oItem;
    object oSkin = GetPCSkin(oInitiator);
    int nSnap = GetLocalInt(oInitiator, "SnapKick");

    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
        if (BladeMeditationFeat(oInitiator) >= 1) BladeMeditation(oInitiator);

        // Hook in the events
        if(DEBUG) DoDebug("tob_feats: Adding eventhooks");
        AddEventScript(oInitiator, EVENT_ONPLAYEREQUIPITEM,   "tob_feats", TRUE, FALSE);
        AddEventScript(oInitiator, EVENT_ONPLAYERUNEQUIPITEM, "tob_feats", TRUE, FALSE);
        AddEventScript(oInitiator, EVENT_ONHEARTBEAT,         "tob_feats", TRUE, FALSE);
    }
    else if(nEvent == EVENT_ITEM_ONHIT)
    {
        oItem          = GetSpellCastItem();
        object oTarget = PRCGetSpellTargetObject();
        if(DEBUG) DoDebug("tob_feats: OnHit:\n"
                        + "oInitiator = " + DebugObject2Str(oInitiator) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                        + "oTarget = " + DebugObject2Str(oTarget) + "\n"
                          );
        if (GetHasFeat(FEAT_DEVOTED_BULWARK, oInitiator)) DevotedBulwark(oInitiator, oTarget);
        if (nSnap == TRUE) SnapKick(oInitiator, oTarget);
        if (GetHasFeat(FEAT_THREE_MOUNTAINS, oInitiator)) ThreeMountains(oInitiator, oTarget);
        if (GetHasFeat(FEAT_VAE_SCHOOL, oInitiator) && GetCanSneakAttack(oTarget, oInitiator)) VaeSchool(oInitiator, oTarget);
        if (GetHasFeat(FEAT_XANIQOS_SCHOOL, oInitiator)) XaniqosSchool(oInitiator, oTarget, oItem, nEvent);
        if (GetHasFeat(FEAT_CRESCENT_MOON, oInitiator)) CrescentMoon(oInitiator, oTarget);
        if (GetHasFeat(FEAT_BEAR_FANG, oInitiator)) BearFang(oInitiator, oTarget);
        if (GetHasFeat(FEAT_DIRE_FLAIL_SMASH, oInitiator)) DireFlailSmash(oInitiator, oTarget);
    }// end if - Running OnHit event
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    {
        oInitiator   = GetItemLastEquippedBy();
        oItem = GetItemLastEquipped();
        if(DEBUG) DoDebug("tob_feats - OnEquip\n"
                        + "oInitiator = " + DebugObject2Str(oInitiator) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );
        // Armor checks
        if(GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
        {
            if (GetHasFeat(FEAT_DEVOTED_BULWARK, oInitiator))
            {       
                // Add eventhook to the armor
                IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
                AddEventScript(oItem, EVENT_ITEM_ONHIT, "tob_feats", TRUE, FALSE);
            }
        }
        // Weapons for Three Mountains
        if (GetHasFeat(FEAT_THREE_MOUNTAINS, oInitiator))
        {
            if (oItem == GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator) && (GetBaseItemType(oItem) == BASE_ITEM_MORNINGSTAR || GetBaseItemType(oItem) == BASE_ITEM_HEAVYFLAIL || GetBaseItemType(oItem) == BASE_ITEM_DIREMACE) || GetBaseItemType(oItem) == BASE_ITEM_HEAVY_MACE)
            {
                // Add eventhook to the weapon
                IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
                AddEventScript(oItem, EVENT_ITEM_ONHIT, "tob_feats", TRUE, FALSE);                    
            }        
        }    
        // Weapons for Snap Kick
        if (oItem == GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator) && IPGetIsMeleeWeapon(oItem) && nSnap == TRUE)
        {
                // Add eventhook to the weapon
                IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
                AddEventScript(oItem, EVENT_ITEM_ONHIT, "tob_feats", TRUE, FALSE);                    
        }
        // Weapons for Vae School
        if (oItem == GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator) && GetBaseItemType(oItem) == BASE_ITEM_WHIP && GetHasFeat(FEAT_VAE_SCHOOL, oInitiator))
        {
                // Add eventhook to the weapon
                IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
                AddEventScript(oItem, EVENT_ITEM_ONHIT, "tob_feats", TRUE, FALSE);                    
        }  
        if (GetHasFeat(FEAT_XANIQOS_SCHOOL, oInitiator)) XaniqosSchool(oInitiator, OBJECT_INVALID, oItem, nEvent);
        if (GetHasFeat(FEAT_CROSSBOW_SNIPER, oInitiator)) CrossbowSniper(oInitiator, oItem, nEvent);
        // Weapons for Crescent Moon
        if (GetHasFeat(FEAT_CRESCENT_MOON, oInitiator))
        {
            if (GetBaseItemType(oItem) == BASE_ITEM_SCIMITAR || GetBaseItemType(oItem) == BASE_ITEM_LONGSWORD || GetBaseItemType(oItem) == BASE_ITEM_BASTARDSWORD || GetBaseItemType(oItem) == BASE_ITEM_DAGGER || GetBaseItemType(oItem) == BASE_ITEM_SHORTSWORD)
            {
                // Add eventhook to the weapon
                IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
                AddEventScript(oItem, EVENT_ITEM_ONHIT, "tob_feats", TRUE, FALSE);                    
            }        
        }  
        // Weapons for Bear Fang
        if (GetHasFeat(FEAT_BEAR_FANG, oInitiator))
        {
            if (GetBaseItemType(oItem) == BASE_ITEM_BATTLEAXE || GetBaseItemType(oItem) == BASE_ITEM_HANDAXE || GetBaseItemType(oItem) == BASE_ITEM_DWARVENWARAXE || GetBaseItemType(oItem) == BASE_ITEM_DAGGER)
            {
                // Add eventhook to the weapon
                IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
                AddEventScript(oItem, EVENT_ITEM_ONHIT, "tob_feats", TRUE, FALSE);                   
            }        
        }  
        // Weapons for Dire Flail Smash
        if (GetHasFeat(FEAT_DIRE_FLAIL_SMASH, oInitiator))
        {
            if (oItem == GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator) && GetBaseItemType(oItem) == BASE_ITEM_DIREMACE)
            {
                // Add eventhook to the weapon
                IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
                AddEventScript(oItem, EVENT_ITEM_ONHIT, "tob_feats", TRUE, FALSE);                    
            }        
        } 
		if (GetHasFeat(FEAT_SHIELDED_CASTING, oInitiator))  
		{  
			int nBase = GetBaseItemType(oItem);  
			if (nBase == BASE_ITEM_SMALLSHIELD || nBase == BASE_ITEM_LARGESHIELD || nBase == BASE_ITEM_TOWERSHIELD)          
			{  
				itemproperty ip = PRCItemPropertyBonusFeat(IP_CONST_IMP_CC);  
				ip = TagItemProperty(ip, "ShieldedCasting");  
				IPSafeAddItemProperty(oSkin, ip, 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);  
			}          
		}
/*         if (GetHasFeat(FEAT_SHIELDED_CASTING, oInitiator))
        {
    		int nBase = GetBaseItemType(oItem);
    		if (nBase == BASE_ITEM_SMALLSHIELD || nBase == BASE_ITEM_LARGESHIELD || nBase == BASE_ITEM_TOWERSHIELD)        
            {
				IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_IMP_CC), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            }        
        } */
        if (GetRacialType(oInitiator) == RACIAL_TYPE_RETH_DEKALA && GetIsWeapon(oItem))
        {
       		IPSafeAddItemProperty(oItem, ItemPropertyAttackBonus(4), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);        	
       		IPSafeAddItemProperty(oItem, ItemPropertyAttackPenalty(4), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);        	
       	}   
        if (GetRacialType(oInitiator) == RACIAL_TYPE_HADRIMOI) HadrimoiPerfectSymmetry(oInitiator);       	
    }
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oInitiator's weapon
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        oInitiator   = GetItemLastUnequippedBy();
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("tob_feats - OnUnEquip\n"
                        + "oInitiator = " + DebugObject2Str(oInitiator) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );
        // Only applies to armours
        if(GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
        {
            // Add eventhook to the item
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "tob_feats", TRUE, FALSE);

            // Remove the temporary OnHitCastSpell: Unique
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", 1, DURATION_TYPE_TEMPORARY);
        }
        // Weapons for Snap Kick
        if (IPGetIsMeleeWeapon(oItem) && nSnap)
        {
            // Remove eventhook to the item
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "tob_feats", TRUE, FALSE);

            // Remove the temporary OnHitCastSpell: Unique
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", 1, DURATION_TYPE_TEMPORARY);                   
        } 
        // Weapons for Three Mountains
        if (GetHasFeat(FEAT_THREE_MOUNTAINS, oInitiator))
        {        
            if (GetBaseItemType(oItem) == BASE_ITEM_MORNINGSTAR || GetBaseItemType(oItem) == BASE_ITEM_HEAVYFLAIL || GetBaseItemType(oItem) == BASE_ITEM_DIREMACE || GetBaseItemType(oItem) == BASE_ITEM_HEAVY_MACE)
            {
                // Remove eventhook to the item
                RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "tob_feats", TRUE, FALSE);
    
                // Remove the temporary OnHitCastSpell: Unique
                RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", 1, DURATION_TYPE_TEMPORARY);                   
            }
        }    
        // Weapons for Vae School
        if (GetBaseItemType(oItem) == BASE_ITEM_WHIP && GetHasFeat(FEAT_VAE_SCHOOL, oInitiator))
        {
            // Remove eventhook to the item
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "tob_feats", TRUE, FALSE);

            // Remove the temporary OnHitCastSpell: Unique
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", 1, DURATION_TYPE_TEMPORARY);                   
        } 
        if (GetHasFeat(FEAT_XANIQOS_SCHOOL, oInitiator)) XaniqosSchool(oInitiator, OBJECT_INVALID, oItem, nEvent);
        if (GetHasFeat(FEAT_CROSSBOW_SNIPER, oInitiator)) CrossbowSniper(oInitiator, oItem, nEvent);
        // Weapons for Crescent Moon
        if (GetHasFeat(FEAT_CRESCENT_MOON, oInitiator))
        {
            if (GetBaseItemType(oItem) == BASE_ITEM_SCIMITAR || GetBaseItemType(oItem) == BASE_ITEM_LONGSWORD || GetBaseItemType(oItem) == BASE_ITEM_BASTARDSWORD || GetBaseItemType(oItem) == BASE_ITEM_DAGGER || GetBaseItemType(oItem) == BASE_ITEM_SHORTSWORD)
            {
                // Remove eventhook to the item
                RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "tob_feats", TRUE, FALSE);
    
                // Remove the temporary OnHitCastSpell: Unique
                RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", 1, DURATION_TYPE_TEMPORARY);                   
            }        
        }  
        // Weapons for Bear Fang
        if (GetHasFeat(FEAT_BEAR_FANG, oInitiator))
        {
            if (GetBaseItemType(oItem) == BASE_ITEM_BATTLEAXE || GetBaseItemType(oItem) == BASE_ITEM_HANDAXE || GetBaseItemType(oItem) == BASE_ITEM_DWARVENWARAXE || GetBaseItemType(oItem) == BASE_ITEM_DAGGER)
            {
                // Remove eventhook to the item
                RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "tob_feats", TRUE, FALSE);
    
                // Remove the temporary OnHitCastSpell: Unique
                RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", 1, DURATION_TYPE_TEMPORARY);                   
            }        
        }    
        // Weapons for Dire Flail Smash
        if (GetHasFeat(FEAT_DIRE_FLAIL_SMASH, oInitiator))
        {
            if (GetBaseItemType(oItem) == BASE_ITEM_DIREMACE)
            {
                // Remove eventhook to the item
                RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "tob_feats", TRUE, FALSE);
    
                // Remove the temporary OnHitCastSpell: Unique
                RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", 1, DURATION_TYPE_TEMPORARY);                                    
            }        
        }
		if (GetHasFeat(FEAT_SHIELDED_CASTING, oInitiator))  
		{  
			// If you don't have a shield in your left hand, no benefit  
			int nBase = GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oInitiator));  
			if (nBase != BASE_ITEM_SMALLSHIELD && nBase != BASE_ITEM_LARGESHIELD && nBase != BASE_ITEM_TOWERSHIELD)          
			{  
				// Only remove the tagged property, not the actual feat  
				itemproperty ipCheck = GetFirstItemProperty(oSkin);  
				while (GetIsItemPropertyValid(ipCheck))  
				{  
					if (GetItemPropertyTag(ipCheck) == "ShieldedCasting")  
					{  
						RemoveItemProperty(oSkin, ipCheck);  
					}  
					ipCheck = GetNextItemProperty(oSkin);  
				}  
			}          
		}		
/*      if (GetHasFeat(FEAT_SHIELDED_CASTING, oInitiator))
        {
        	// If you don't have a shield in your left hand, no benefit
    		int nBase = GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oInitiator));
    		if (nBase != BASE_ITEM_SMALLSHIELD && nBase != BASE_ITEM_LARGESHIELD && nBase != BASE_ITEM_TOWERSHIELD)        
            {
				RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT, IP_CONST_IMP_CC);
            }        
        }     */     
        if (GetRacialType(oInitiator) == RACIAL_TYPE_RETH_DEKALA && GetIsWeapon(oItem))
        {
            // Remove the attack bonus
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS, -1, -1, 1, "", -1, DURATION_TYPE_TEMPORARY);
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER, -1, -1, 1, "", -1, DURATION_TYPE_TEMPORARY);        
        }    
        if (GetRacialType(oInitiator) == RACIAL_TYPE_HADRIMOI) HadrimoiPerfectSymmetry(oInitiator);       	
    }
    else if(nEvent == EVENT_ONHEARTBEAT)
    {
        if(GetHasFeat(FEAT_SHADOW_BLADE, oInitiator)) ShadowBlade(oInitiator);
        if(GetHasFeat(FEAT_RAPID_ASSAULT, oInitiator)) RapidAssault(oInitiator);
        if(GetHasFeat(FEAT_DESERT_WIND_DODGE, oInitiator) || GetHasFeat(FEAT_DESERT_FIRE, oInitiator)) DesertWind(oInitiator);
        if(GetHasFeat(FEAT_IRONHEART_AURA, oInitiator)) IronheartAura(oInitiator);
        if(GetHasFeat(FEAT_SHADOW_TRICKSTER, oInitiator)) ShadowTrickster(oInitiator);
        if(GetHasFeat(FEAT_WHITE_RAVEN_DEFENSE, oInitiator)) WhiteRavenDefense(oInitiator);
        if(GetHasFeat(FEAT_INLINDL_SCHOOL, oInitiator)) InlindlSchool(oInitiator);
        if(GetHasFeat(FEAT_XANIQOS_SCHOOL, oInitiator)) XaniqosSchool(oInitiator, OBJECT_INVALID, oItem, nEvent);
        if(GetHasFeat(FEAT_EXPEDITIOUS_DODGE, oInitiator)) ExpeditiousDodge(oInitiator);
        if(GetHasFeat(FEAT_SHIELD_WALL, oInitiator)) ShieldWall(oInitiator);
        if(GetHasFeat(FEAT_QUICK_STAFF, oInitiator)) QuickStaff(oInitiator);
        if(GetHasFeat(FEAT_IMPROVED_RAPID_SHOT, oInitiator)) ImprovedRapidShot(oInitiator);
        if(GetHasFeat(FEAT_BEAR_FANG, oInitiator)) BearFangHB(oInitiator);
		//:: Moved to onEquip and onUnequiped stop constant "Shield AC" spam.
        //if(GetHasFeat(FEAT_SHIELD_SPECIALIZATION_LIGHT, oInitiator) || GetHasFeat(FEAT_SHIELD_SPECIALIZATION_HEAVY, oInitiator)) ShieldSpecialization(oInitiator);
        if(GetHasFeat(FEAT_FOCUSED_SHIELD, oInitiator)) FocusedShield(oInitiator);
        if(GetHasFeat(FEAT_SHIELDMATE, oInitiator)) Shieldmate(oInitiator);
        if(GetRacialType(oInitiator) == RACIAL_TYPE_RETH_DEKALA) RethDekalaAura(oInitiator);
    }    

}