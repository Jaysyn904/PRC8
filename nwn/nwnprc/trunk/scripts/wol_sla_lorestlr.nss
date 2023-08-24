/**
 * @file
 * Spellscript for Lorestealer SLAs
 *
 */

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    int nCasterLevel, nDC, nSpell, nUses;
    int nSLA = GetSpellId();
    int nHD = GetHitDice(oPC);
    int nInstant = FALSE;
    effect eNone;
    
    object oWOL = GetItemPossessedBy(oPC, "WOL_Lorestealer");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) return;  

    switch(nSLA){
        case WOL_LORESTEALER_DETECT:
        {
            nCasterLevel = 5;
            nSpell = SPELL_DETECT_MAGIC; 
            nUses = 999;
            break;
        } 
        case WOL_LORESTEALER_READ:
        {
            nCasterLevel = 5;
            nSpell = SPELL_READ_MAGIC; 
            nUses = 999;
            break;
        }         
        case WOL_LORESTEALER_AXE:
        {
            nUses = 1;
            if (GetLocalInt(oPC, "Lorestealer2nd")) nUses++;
            // Check uses per day. 
            if (nUses > GetLegacyUses(oPC, nSLA) && TakeSwiftAction(oPC))
            {        
				object oItem = PRCGetSpellTargetObject();
				//FloatingTextStringOnCreature("Axe Casting on "+GetName(oItem), oPC, FALSE);
    			itemproperty ip = GetFirstItemProperty(oItem);
    			int nType, nTest, nFinal;
    			//FloatingTextStringOnCreature("Axe Casting base item type on "+IntToString(GetBaseItemType(oItem)), oPC, FALSE);
    			int nStack = GetItemStackSize(oItem);
    			if (nStack == 1)
    			{
    				if (GetBaseItemType(oItem) == BASE_ITEM_SCROLL || GetBaseItemType(oItem) == BASE_ITEM_ENCHANTED_SCROLL || GetBaseItemType(oItem) == BASE_ITEM_BLANK_SCROLL || GetBaseItemType(oItem) == 75) // Scroll
    				{
    					//FloatingTextStringOnCreature("Axe Casting item is scroll", oPC, FALSE);
     					while (GetIsItemPropertyValid(ip))
    					{
    					    nType = GetItemPropertyType(ip);
    					    if (nType == ITEM_PROPERTY_CAST_SPELL)
    					    {
                        		int nRow = GetItemPropertySubType(ip);
                        		int nLevel = StringToInt(Get2DACache("iprp_spells", "InnateLvl", nRow));
    					        //FloatingTextStringOnCreature("Axe Casting spell level is "+IntToString(nLevel), oPC, FALSE);
    					        if (3 >= nLevel)
    					        	nTest = TRUE;
    					        else if (6 >= nLevel && GetLocalInt(oPC, "Lorestealer6"))
    					        	nTest = TRUE;
    					        else 	
    					        	FloatingTextStringOnCreature("Scroll's spell level is too high to be used with Axe Casting!", oPC, FALSE);                
    					    }
    					    ip = GetNextItemProperty(oItem);
    					}   					
		
    					//FloatingTextStringOnCreature("Axe Casting nTest is "+IntToString(nTest), oPC, FALSE);
    					ip = GetFirstItemProperty(oItem);
    					while (GetIsItemPropertyValid(ip) && nTest)
    					{
    					    nType = GetItemPropertyType(ip);
    					    if (
    					       nType == ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP ||
    					       nType == ITEM_PROPERTY_USE_LIMITATION_CLASS ||
    					       nType == ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE ||
    					       nType == ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT  )
    					    {
    					        RemoveItemProperty(oItem, ip);
    					        nFinal = TRUE;
    					        //FloatingTextStringOnCreature("Axe Casting removed property from "+GetName(oItem), oPC, FALSE);
    					    }
    					    ip = GetNextItemProperty(oItem);
    					}
    					if (nFinal) // Only set uses if we've actually removed something
    					{
    						SetLegacyUses(oPC, nSLA);
    						FloatingTextStringOnCreature("Axe Casting succuessful on "+GetName(oItem), oPC, FALSE);
    					}	
    				}
    			}
    			else
    				FloatingTextStringOnCreature("Axe Casting can only be used on a single scroll, not a stack", oPC, FALSE);                
            }    
            break;
        }         
    }
    
    // Check uses per day
    if (GetLegacyUses(oPC, nSLA) >= nUses)
    {
        FloatingTextStringOnCreature("You have used " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSLA))) + " the maximum amount of times today.", oPC, FALSE);
        return;
    }   
    if (nSpell > 0) 
    {
        DoRacialSLA(nSpell, nCasterLevel, nDC, nInstant);
        SetLegacyUses(oPC, nSLA);
        FloatingTextStringOnCreature("You have "+IntToString(nUses - GetLegacyUses(oPC, nSLA))+ " uses of " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSLA))) + " remaining today.", oPC, FALSE);
    }     
}
        