//::///////////////////////////////////////////////
//:: Name           Whelm maintain script
//:: FileName       wol_m_whelm
//:://////////////////////////////////////////////
/*
LEGACY ITEM BONUSES
5th  - Sense giants
7th  - +1 giant bane warhammer
8th  - Locate object 
9th  - Sense goblinoids
10th - Intelligent legacy 
11th - +1 giant and goblinoid bane warhammer
13th - +2 giant and goblinoid bane warhammer
16th - +3 giant and goblinoid bane warhammer
*/

#include "prc_inc_template"

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("wol_m_whelm running, event: " + IntToString(nEvent));

    // Get the PC. This is event-dependent
    object oPC, oItem;
    switch(nEvent)
    {
        case EVENT_ITEM_ONHIT:          oPC = OBJECT_SELF;               break;
        case EVENT_ONPLAYEREQUIPITEM:   oPC = GetItemLastEquippedBy();   break;

        default:
            oPC = OBJECT_SELF;
    }
    object oSkin = GetPCSkin(oPC);
    int nHD = GetHitDice(oPC);
    int nHPPen = 0;
    object oWOL = GetItemPossessedBy(oPC, "WOL_Whelm");
    
    // You get nothing if you aren't wielding the legacy weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC))
    {
    	SetCompositeBonus(oSkin, "Whelm_SavesR", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX); 
    	SetCompositeAttackBonus(oPC, "Whelm_Atk", 0, ATTACK_BONUS_MISC);
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
				IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_WHELM_DETECT_GIANT), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);            
			}         
            if(nHD >= 6)
            {
                SetCompositeAttackBonus(oPC, "Whelm_Atk", -1, ATTACK_BONUS_MISC);
				IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_GIANT, 3));
				IPSafeAddItemProperty(oWOL, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_GIANT, IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_2d6));         
			}     
            if(nHD >= 7)
            {
                SetCompositeBonus(oSkin, "Whelm_SavesR", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX); 
                nHPPen += 2;             
            } 
            if(nHD >= 8)
            {
				IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_WHELM_LOCATE_OBJECT), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);            
				nHPPen += 2;        
				
            } 
            if(nHD >= 9)
            {
				IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_WHELM_DETECT_GOBLIN), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);            
				SetCompositeBonus(oSkin, "Whelm_SavesR", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX); 
            }
            if(nHD >= 10)
            {
                nHPPen += 2;           
            }    
        }
		// 11th to 16th level abilities
		if (GetHasFeat(FEAT_LESSER_LEGACY, oPC))
		{    
			if(nHD >= 11)
			{
            	IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_GOBLINOID, 3));
				IPSafeAddItemProperty(oWOL, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_GOBLINOID, IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_2d6));         
			}
			if(nHD >= 12)
			{
            	SetCompositeAttackBonus(oPC, "Whelm_Atk", -2, ATTACK_BONUS_MISC);
			}    
			if(nHD >= 13)
			{
				IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(2));
				IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_GOBLINOID, 4));
				IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_GIANT, 4));
			}
			if(nHD >= 14)
			{
            	nHPPen += 2;
			}            
			if(nHD >= 15)
			{
				SetCompositeBonus(oSkin, "Whelm_SavesR", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX); 
			}    
			if(nHD >= 16)
			{
				IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(3));
				IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_GOBLINOID, 5));
				IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_GIANT, 5));
				nHPPen += 2;            
			}     
		}
		
        SetLocalInt(oPC, "WoLHealthPenalty", nHPPen);    
        if (!GetLocalInt(oPC, "WoLHealthPenaltyHB") && nHPPen > 0) 
        {
            WoLHealthPenaltyHB(oPC);
            SetLocalInt(oPC, "WoLHealthPenaltyHB", TRUE);
        }
    }          
}