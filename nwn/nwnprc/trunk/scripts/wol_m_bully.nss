//::///////////////////////////////////////////////
//:: Name           Bullybasher's Gauntlets maintain script
//:: FileName       wol_m_bully
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Attack Penalty: -1 at 6th, -2 at 13th
Skill Check Penalty: -1 at 6th, -3 at 10th, -4 at 15th, -5 at 16th, -6 at 19th
Hit Point Penalty: -2 at 6th, -4 at 10th, -6 at 14th, -8 at 18th
  
LEGACY ITEM BONUSES
12th - +2 Gauntlets
16th - +3 Gauntlets
20th - +4 Gauntlets

LEGACY ITEM ABILITIES
Sturdy Grip (Su): At 5th level, while wearing Bullybasher’s Gauntlets, you gain a +4 bonus on grapple checks.
Knock Silly (Su): At 6th level and higher, when you deal damage to an opponent with Bullybasher’s Gauntlets, that opponent is affected as if by the touch of idiocy spell. You must decide whether or not to use this ability before making the attack roll, and if you miss, the attempt is wasted for the day. This ability is usable two times per day. Caster level 5th.
Solitary Warrior (Su): Starting at 7th level, when you are adjacent to at least two foes and no ally is within 30 feet, the effective enhancement bonus of Bullybasher’s Gauntlets increases by 1 and you deal an extra 1d6 points of damage with each successful attack made with the gauntlets.
Cheat Death (Su): At 8th level and higher, you automatically heal 1 hit point if your hit points drop to between –1 and –9. This ability functions once per day.
Power of One (Su): At 10th level, Bullybasher’s Gauntlets grant a +2 enhancement bonus to your Constitution score. At 14th level, the bonus rises to +4. It rises to +6 at 18th level.
Rough and Tumble (Su): At 11th level, you gain damage reduction 5/magic.
Giant Bearing (Su): Beginning at 13th level, you gain a +2 bonus to Strength, a –2 penalty to Dexterity (to a minimum of 1), a –1 penalty on attack rolls, and a +4 bonus on grapple checks. 
Stone Gathering (Su): At 15th level and higher, you can hurl rocks. The rocks deal 2d6 (plus Strength modifier) points of bludgeoning damage.
Frightful Presence (Su): Starting at 17th level, you unsettle surrounding foes when you are attacking or charging. Creatures within a radius of 30 feet are subject to the effect if they have fewer Hit Dice than you. A potentially affected creature that succeeds on a Will save (DC 10 + 1/2 your character level + your Charisma modifier) suffers no ill effect and is immune to your frightful presence for 24 hours. Those who fail the save become shaken for 4d6 rounds.
No Wound Too Big (Su): At 18th level and higher, while wearing Bullybasher’s Gauntlets, you heal 2 points of damage every hour.
Lightning Punch (Su): Beginning at 19th level, once per day on command, you can charge Bullybasher’s Gauntlets with chain lightning. The next creature struck by the gauntlets is the target of the spell, and secondary bolts can strike other foes within 30 feet. A charge is maintained until the gauntlets strike a creature. The save DC is 19, or 16 + your Charisma modifier, whichever is higher. Caster level 15th.
*/

#include "prc_inc_template"
#include "prc_inc_combat"

void NoWoundTooBig(object oPC);

void NoWoundTooBig(object oPC)
{
	SetLocalInt(oPC, "NoWoundTooBigHBRunning", TRUE);
	DelayCommand(HoursToSeconds(1)-0.1, DeleteLocalInt(oPC, "NoWoundTooBigHBRunning"));
	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(2), oPC);

    DelayCommand(HoursToSeconds(1), NoWoundTooBig(oPC));
}

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("wol_m_bully running, event: " + IntToString(nEvent));

    // Get the PC. This is event-dependent
    object oPC, oItem;
    switch(nEvent)
    {
        case EVENT_ITEM_ONHIT:          oPC = OBJECT_SELF;               break;
        case EVENT_ONPLAYEREQUIPITEM:   oPC = GetItemLastEquippedBy();   break;
        case EVENT_ONPLAYERUNEQUIPITEM: oPC = GetItemLastUnequippedBy(); break;
        case EVENT_ONHEARTBEAT:         oPC = OBJECT_SELF;               break;

        default:
            oPC = OBJECT_SELF;
    }   
    object oSkin = GetPCSkin(oPC);
    int nHD = GetHitDice(oPC);
    int nHPPen = 0;
    object oWOL = GetItemPossessedBy(oPC, "WOL_Bullybashers");
    
    // You get nothing if you don't have the item
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_ARMS, oPC))
    {
        SetCompositeAttackBonus(oPC, "Bullybashers_Atk", 0, ATTACK_BONUS_MISC);
        SetCompositeBonus(oSkin, "Bullybashers_Con", 0, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CON);
    	return;
    }
    
    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {    
	    // 5th to 10th level abilities
	    if (GetHasFeat(FEAT_LEAST_LEGACY, oPC))
	    {
	        if(nHD >= 5)
	        {
	        	SetLocalInt(oPC, "BullybashersGrapple", TRUE);
	        }         
	        if(nHD >= 6)
	        {
	            nHPPen += 2;
	            if (10 > nHD) ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 1)), "WOLEffect"), oPC);     
	            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_BULLY_SILLY), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	        }     
	        if(nHD >= 7)
	        {
	            SetCompositeAttackBonus(oPC, "Bullybashers_Atk", -1, ATTACK_BONUS_MISC);
	            AddEventScript(oPC, EVENT_ONHEARTBEAT, "wol_m_bully", TRUE, FALSE);
	        } 
	        if(nHD >= 8)
	        {
				SetLocalInt(oPC, "BullybashersDeath", TRUE);
	        } 
	        if(nHD >= 9)
	        {
	            
	        }
	        if(nHD >= 10)
	        {
	            nHPPen += 2;
	            if (15 > nHD) ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 3)), "WOLEffect"), oPC);     
	            SetCompositeBonus(oSkin, "Bullybashers_Con", 2, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CON);
	        }    
	    }
	    // 11th to 16th level abilities
	    if (GetHasFeat(FEAT_LESSER_LEGACY, oPC))
	    {    
	        if(nHD >= 11)
	        {
	            IPSafeAddItemProperty(oSkin, ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1, IP_CONST_DAMAGESOAK_5_HP), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	        }
	        if(nHD >= 12)
	        {
	            IPSafeAddItemProperty(oWOL, ItemPropertyACBonus(2));
	        }    
	        if(nHD >= 13)
	        {
	        	SetCompositeAttackBonus(oPC, "Bullybashers_Atk", -2, ATTACK_BONUS_MISC);
	        	ActionCastSpell(WOL_BULLY_GIANT, 5, 0, 0, METAMAGIC_NONE, CLASS_TYPE_INVALID, FALSE, TRUE, oPC, TRUE, FALSE);
	        	SetLocalInt(oPC, "BullybashersGiant", TRUE);
	        }
	        if(nHD >= 14)
	        {
	            nHPPen += 2;
	            SetCompositeBonus(oSkin, "Bullybashers_Con", 4, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CON);
	        }            
	        if(nHD >= 15)
	        {
	        	if (16 > nHD) ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 4)), "WOLEffect"), oPC);     
	        	IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_BULLY_STONE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	        }    
	        if(nHD >= 16)
	        {
	            if (19 > nHD) ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 5)), "WOLEffect"), oPC);      
	            IPSafeAddItemProperty(oWOL, ItemPropertyACBonus(3));
	        }     
	    }
	    // 17th+ level abilities
	    if (GetHasFeat(FEAT_GREATER_LEGACY, oPC))
	    {    
	        if(nHD >= 17)
	        {    
                if(DEBUG) DoDebug("wol_m_bully: Adding eventhooks");
                AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "wol_m_bully", TRUE, FALSE);
                AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "wol_m_bully", TRUE, FALSE); 
            	// Add eventhook to the item
            	AddEventScript(oWOL, EVENT_ITEM_ONHIT, "wol_m_bully", TRUE, FALSE);

            	// Add the OnHitCastSpell: Unique needed to trigger the event
	        	IPSafeAddItemProperty(oWOL, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);                
	        }  
	        if(nHD >= 18)
	        {
	        	nHPPen += 2;
	        	SetCompositeBonus(oSkin, "Bullybashers_Con", 6, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CON);

	        	if (!GetLocalInt(oPC, "NoWoundTooBigHBRunning")) DeleteLocalInt(oPC, "NoWoundTooBigHB");
	        	if (!GetLocalInt(oPC, "NoWoundTooBigHB")) 
	        	{
	        		NoWoundTooBig(oPC);
	        	    SetLocalInt(oPC, "NoWoundTooBigHB", TRUE);
	        	}	        	
	        } 
	        if(nHD >= 19)
	        {
	        	ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 6)), "WOLEffect"), oPC);     
	        	IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_BULLY_CHAIN), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	        } 
	        if(nHD >= 20)
	        {
	        	IPSafeAddItemProperty(oWOL, ItemPropertyACBonus(4));
	        } 
	    }    
	        
	    SetLocalInt(oPC, "WoLHealthPenalty", nHPPen);    
	    if (!GetLocalInt(oPC, "WoLHealthPenaltyHB") && nHPPen > 0) 
	    {
	        WoLHealthPenaltyHB(oPC);
	        SetLocalInt(oPC, "WoLHealthPenaltyHB", TRUE);
	    }
    }
    // We are called from the OnPlayerEquipItem eventhook. Add OnHitCast: Unique Power to oPC's weapon
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    {
        oPC   = GetItemLastEquippedBy();
        oItem = GetItemLastEquipped();
        if(DEBUG) DoDebug("wol_m_bully - OnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );
                          
        // Only applies to weapons
        // IPGetIsMeleeWeapon is bugged and returns true on items it should not
        if(oItem == oWOL)
        {
            // Add eventhook to the item
            AddEventScript(oItem, EVENT_ITEM_ONHIT, "wol_m_bully", TRUE, FALSE);

            // Add the OnHitCastSpell: Unique needed to trigger the event
	        IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }                          

        // Only applies to weapons
        // IPGetIsMeleeWeapon is bugged and returns true on items it should not
        /*if(oItem == GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) || 
           oItem == GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC) || 
           oItem == GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC) || 
           oItem == GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC) || 
           (oItem == GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC) && !GetIsShield(oItem)))
        {
            // Add eventhook to the item
            AddEventScript(oItem, EVENT_ITEM_ONHIT, "wol_m_bully", TRUE, FALSE);

            // Add the OnHitCastSpell: Unique needed to trigger the event
	        IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }*/
    }
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oPC's weapon
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        oPC   = GetItemLastUnequippedBy();
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("wol_m_bully - OnUnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        // Only applies to weapons
        /*if(IPGetIsMeleeWeapon(oItem) || GetBaseItemType(oItem) == BASE_ITEM_CBLUDGWEAPON ||
           GetBaseItemType(oItem) == BASE_ITEM_CPIERCWEAPON || GetBaseItemType(oItem) == BASE_ITEM_CSLASHWEAPON ||
           GetBaseItemType(oItem) == BASE_ITEM_CSLSHPRCWEAP)
        {
            // Add eventhook to the item
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "wol_m_bully", TRUE, FALSE);

            // Remove the temporary OnHitCastSpell: Unique
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);
        }*/
        if(oItem == oWOL)
        {
            // Add eventhook to the item
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "wol_m_bully", TRUE, FALSE);

            // Remove the temporary OnHitCastSpell: Unique
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);
        }        
    }  
    else if(nEvent == EVENT_ITEM_ONHIT)
    {
        oItem          = GetSpellCastItem();
        object oTarget = PRCGetSpellTargetObject();
        if(DEBUG) DoDebug("wol_m_bully: OnHit:\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                        + "oTarget = " + DebugObject2Str(oTarget) + "\n"
                          );

        if(oItem == oWOL)
        { 	
        	// Do Frightful Presence
			effect eShaken   = SupernaturalEffect(EffectShaken());
	
	        // Radius = 30ft
	        float fRadius    = FeetToMeters(30.0f);
	        float fDuration = RoundsToSeconds(d6(4));

			int nPCHitDice   = GetHitDice(oPC);	
	        int nDC = 10 + GetAbilityModifier(ABILITY_CHARISMA, oPC) + (nPCHitDice/2); 
	        int nTargetHitDice;
	        int bDoVFX = FALSE;
	
	        // The object ID for enforcing the 24h rule
	        string sPCOid = ObjectToString(oPC);
	
	        // Loop over creatures in range
	        location lTarget = GetLocation(oPC);
	        object oTarget   = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE);
	        while (GetIsObjectValid(oTarget))
	        {
	            // Target validity check
	            if(oTarget != oPC                                        && // Can't affect self
	               !GetLocalInt(oTarget, "WOL_Bully_SavedVs" + sPCOid)   && // Hasn't saved successfully against this samurai's Frightful Presence in the last 24h
	               spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oPC) && // Only hostiles
	               nPCHitDice > GetHitDice(oTarget)) // Must have greater hit dice to affect the creature
	            {
	                // Set the marker that tells we tried to affect someone
	                bDoVFX = TRUE;
	
	                // Let the target know something hostile happened
	                SignalEvent(oTarget, EventSpellCastAt(oPC, -1, TRUE));
	
	                // Will save
	                if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR, oPC) &&
	                   !GetIsImmune(oTarget, IMMUNITY_TYPE_FEAR, oPC))  // Explicit immunity check, because of the fucking stupid BW immunity handling
	                {
	                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShaken, oTarget, fDuration);
	                }
	                // Successfull save, set marker and queue marker deletion
	                else
	                {
	                    SetLocalInt(oTarget, "WOL_Bully_SavedVs" + sPCOid, TRUE);
	
	                    // Add variable deletion to the target's queue. That way, if the samurai logs out, it will still get cleared
	                    AssignCommand(oTarget, DelayCommand(HoursToSeconds(24), DeleteLocalInt(oTarget, "WOL_Bully_SavedVs" + sPCOid)));
	                }
	            }// end if - Target validity check
	
	            // Get next target in area
	            oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE);
	        }// end while - Loop over creatures in 30ft area

	        // If we tried to affect someone, do war cry VFX
	        if(bDoVFX)
	            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(GetGender(oPC) == GENDER_FEMALE ? VFX_FNF_HOWL_WAR_CRY_FEMALE : VFX_FNF_HOWL_WAR_CRY), oPC);
        }
    }// end if - Running OnHit event     
    else if(nEvent == EVENT_ONHEARTBEAT)
    {
        location lTarget = GetLocation(oPC);
        
        // Use the function to get the closest creature as a target
        object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
        int nCount = 0;
        while(GetIsObjectValid(oAreaTarget))
        {
        	//FloatingTextStringOnCreature("Solitary Warrior Test In Area "+GetName(oAreaTarget), oPC, FALSE);
        	if (spellsIsTarget(oAreaTarget, SPELL_TARGET_SELECTIVEHOSTILE, oPC))
        	{
                nCount += 1;
                //FloatingTextStringOnCreature("Solitary Warrior Test Target "+GetName(oAreaTarget)+" nCount "+IntToString(nCount), oPC, FALSE);
            }
        	//Select the next target within the spell shape.
        	oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
        } 
        
        //FloatingTextStringOnCreature("Solitary Warrior Test nCount "+IntToString(nCount), oPC, FALSE);
        if (nCount >= 2 && !GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC))) // Need to be unarmed for this to apply
        {
        	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectLinkEffects(EffectACIncrease(1, AC_DODGE_BONUS), EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_BLUDGEONING)), oPC, 6.0);
        	FloatingTextStringOnCreature("Solitary Warrior Active", oPC, FALSE);
        }	
    }// end if - Running HB event     
}