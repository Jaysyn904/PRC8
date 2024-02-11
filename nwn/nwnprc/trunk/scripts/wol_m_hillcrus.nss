//::///////////////////////////////////////////////
//:: Name          Hillcrusher maintain script
//:: FileName      wol_m_hillcrus
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Attack Penalty: -1 at 6th, -2 at 13th, -3 at 18th
Fortitude Save Penalty: -1 at 7th, -2 at 9th, -3 at 15th, -4 at 20th
Hit Point Penalty: -2 at 7th, -4 at 8th, -6 at 10th, -8 at 14th, -10 at 16th

LEGACY ITEM BONUSES
6th  - +1 Giant Bane heavy flail
13th - +2 Impact Giant Bane heavy flail
20th - +4 Impact Giant Bane heavy flail

LEGACY ITEM ABILITIES
Earthen Might (Sp): At 8th level, you can use enlarge person once per day, on yourself only, as a swift action. Caster level 7th.
Soften Earth (Sp): At 10th level, you can use soften earth and stone twice per day. Caster level 7th.
Fangs of Stone (Sp): Starting at 16th level, you can use sudden stalagmite twice per day. Caster level 13th.
Raise the Earth (Sp): At 17th level, you can use bones of the earth twice per day. Caster level 15th.
Shake the Earth (Sp): At 19th level, you can create an earthquake, as the spell, once per day. Caster level 17th.
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
    object oWOL = GetItemPossessedBy(oPC, "WOL_Hillcrusher");
    
    // You get nothing if you aren't wielding the legacy weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) 
    {
        SetCompositeAttackBonus(oPC, "Hillcrusher_Atk", 0, ATTACK_BONUS_MISC);
        SetCompositeBonus(oSkin, "Hillcrusher_SavesF", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
    	return;
    }
    
    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {     
		// 5th to 10th level abilities
        if (GetHasFeat(FEAT_LEAST_LEGACY, oPC))
        {
            if(nHD >= 6)
            {				
			    SetCompositeAttackBonus(oPC, "Hillcrusher_Atk", -1, ATTACK_BONUS_MISC);
				IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_GIANT, 3));
				IPSafeAddItemProperty(oWOL, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_GIANT, IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_2d6));         
			}     
            if(nHD >= 7)
            {
				SetCompositeBonus(oSkin, "Hillcrusher_SavesF", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE); 
				nHPPen += 2;             
            } 
            if(nHD >= 8)
            {
				//need earthen might
				IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_HC_EARTHEN_MIGHT), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);            
				nHPPen += 2;        
				
            } 
			if(nHD >= 9)
            {
				SetCompositeBonus(oSkin, "Hillcrusher_SavesF", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE); 
            }
            if(nHD >= 10)
            {
				//need soften earth
				IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_HC_SOFTEN_EARTH), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);            
                nHPPen += 2;           
            }    
        }
            
		// 11th to 16th level abilities
		if (GetHasFeat(FEAT_LESSER_LEGACY, oPC))
		{    
			if(nHD >= 12)
			{
				
			}    
			if(nHD >= 13)
			{
				IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(2));
				IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_GIANT, 4));
				IPSafeAddItemProperty(oWOL, ItemPropertyKeen());
				SetCompositeAttackBonus(oPC, "Hillcrusher_Atk", -2, ATTACK_BONUS_MISC);
			}
			if(nHD >= 14)
			{
				nHPPen += 2;
			}            
			if(nHD >= 15)
			{
				SetCompositeBonus(oSkin, "Hillcrusher_SavesF", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE); 
			}    
			if(nHD >= 16)
			{
				//NEED FANGS OF STONE
				IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_HC_FANGS_OF_STONE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);            
				nHPPen += 2;            
			}     
			
		}
		  // 17th+ level abilities
        if (GetHasFeat(FEAT_GREATER_LEGACY, oPC))
        {    
            if(nHD >= 17)
            {    
				//NEED RAISE THE EARTH
				IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_HC_RAISE_THE_EARTH), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);            
            }  
            if(nHD >= 18)
            {
				SetCompositeAttackBonus(oPC, "Hillcrusher_Atk", -3, ATTACK_BONUS_MISC);
            } 
            if(nHD >= 19)
            {
				//NEED SHAKE THE EARTH
				IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_HC_SHAKE_THE_EARTH), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);            
            } 
            if(nHD >= 20)
            {
				IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(4));
				IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_GIANT, 6));
				SetCompositeBonus(oSkin, "Hillcrusher_SavesF", 4, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE); 
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