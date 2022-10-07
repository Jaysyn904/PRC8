//::///////////////////////////////////////////////
//:: Name           Lorestealer maintain script
//:: FileName       wol_m_lorestlr
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Attack Penalty: -1 at 9th, -2 at 13th
Save Penalty: -1 at 8th, -2 at 16th
Hit Point Penalty: -4 at 6th, -6 at 9th, -8 at 12th, -10 at 15th

LEGACY ITEM BONUSES
10th - +1 Flaming Axe
11th - +1 Flaming Frost Throwing Axe

LEGACY ITEM ABILITIES
Decipher Scrolls (Su): At 5th level and higher, you can decipher any magic scroll as if you benefited from a read magic spell. Caster level 5th.
Locate Scrolls (Su): Beginning at 5th level, you can detect magic at will. Caster level 5th.
Scroll Use (Su): At 6th level, you gain a +5 competence bonus on Use Magic Device checks.
Axe Casting (Su): Starting at 7th level, once per day as an immediate action, you can drive the blade of Lorestealer into a single scroll containing a 3rd-level or lower spell. Once you have done this, you can then cast the scroll at any time. Scrolls still must be deciphered before this feature functions on them. At 13th level and higher, this ability works on scrolls containing spells of 6th level or lower. Starting at 16th level, you can use this ability two times per day.
*/

#include "prc_inc_template"

void RespawnWOL2(object oPC)
{
	object oRespawn = CreateItemOnObject(Get2DACache("wol_items", "ResRef", 51), oPC);
	SetIdentified(oRespawn, TRUE);
	SetDroppableFlag(oRespawn, FALSE);
	SetItemCursedFlag(oRespawn, TRUE); 
	AssignCommand(oRespawn, SetIsDestroyable(FALSE, FALSE, FALSE));
	DelayCommand(0.25, AssignCommand(oPC, ActionEquipItem(oRespawn, INVENTORY_SLOT_RIGHTHAND))); 	
}

void RespawnWOL(object oPC)
{
	if (!GetIsObjectValid(GetItemPossessedBy(oPC, "WOL_Lorestealer")))
	{
		if (GetLocalInt(oPC, "LorestealerReturn"))
		{
			RespawnWOL2(oPC);
		}	
		else
			DelayCommand(5.5, RespawnWOL2(oPC));
	}	
}

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("wol_m_lorestlr running, event: " + IntToString(nEvent));

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
    object oWOL = GetItemPossessedBy(oPC, "WOL_Lorestealer");
    
    // You get nothing if you aren't wielding the legacy item
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) 
    {
        SetCompositeAttackBonus(oPC, "Lorestealer_Atk", 0, ATTACK_BONUS_MISC);
	    SetCompositeBonus(oSkin, "Lorestealer_SavesF", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
	    SetCompositeBonus(oSkin, "Lorestealer_SavesW", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
	    SetCompositeBonus(oSkin, "Lorestealer_SavesR", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
        SetCompositeBonus(oSkin, "Lorestealer_UMD", 0, ITEM_PROPERTY_SKILL_BONUS,SKILL_USE_MAGIC_DEVICE);
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
	            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_LORESTEALER_READ), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_LORESTEALER_DETECT), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
                //if(DEBUG) DoDebug("wol_m_lorestlr: Adding eventhooks");
                //AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "wol_m_lorestlr", TRUE, FALSE);
                AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "wol_m_lorestlr", TRUE, FALSE); 	            
	        }         
	        if(nHD >= 6)
	        {
	            nHPPen += 4;
	            SetCompositeBonus(oSkin, "Lorestealer_UMD", 5, ITEM_PROPERTY_SKILL_BONUS,SKILL_USE_MAGIC_DEVICE);
	        }     
	        if(nHD >= 7)
	        {
	        	IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_LORESTEALER_AXE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	        } 
	        if(nHD >= 8)
	        {
	            SetCompositeBonus(oSkin, "Lorestealer_SavesF", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
	            SetCompositeBonus(oSkin, "Lorestealer_SavesW", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
	            SetCompositeBonus(oSkin, "Lorestealer_SavesR", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
	        } 
	        if(nHD >= 9)
	        {
	            SetCompositeAttackBonus(oPC, "Lorestealer_Atk", -1, ATTACK_BONUS_MISC);
	            nHPPen += 2;
	        }
	        if(nHD >= 10)
	        {
	        	IPSafeAddItemProperty(oWOL, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d6));
	        }            
	    }
	    // 11th to 16th level abilities
	    if (GetHasFeat(FEAT_LESSER_LEGACY, oPC))
	    {    
	        if(nHD >= 11)
	        {
	        	SetLocalInt(oPC, "LorestealerReturn", TRUE);
	        	IPSafeAddItemProperty(oWOL, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGEBONUS_1d6));
	        }
	        if(nHD >= 12)
	        {
	            nHPPen += 2;
	        }    
	        if(nHD >= 13)
	        {
	            SetCompositeAttackBonus(oPC, "Lorestealer_Atk", -2, ATTACK_BONUS_MISC);
	            SetLocalInt(oPC, "Lorestealer6", TRUE);
	        }
	        if(nHD >= 14)
	        {
	        }            
	        if(nHD >= 15)
	        {
	            nHPPen += 2;
	        }    
	        if(nHD >= 16)
	        {
	            SetCompositeBonus(oSkin, "Lorestealer_SavesF", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
	            SetCompositeBonus(oSkin, "Lorestealer_SavesW", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
	            SetCompositeBonus(oSkin, "Lorestealer_SavesR", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
	            SetLocalInt(oPC, "Lorestealer2nd", TRUE);
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
        if(DEBUG) DoDebug("wol_m_lorestlr - OnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );
    }
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oPC's weapon
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        oPC   = GetItemLastUnequippedBy();
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("wol_m_lorestlr - OnUnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        if(oItem == oWOL)
        {
 			DelayCommand(0.25, RespawnWOL(oPC));	
        }        
    }	    
}
