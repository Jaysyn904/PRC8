/* Skarn Spines, which are equivalent to a shortsword*/

#include "moi_inc_moifunc"

void CleanSpines(object oMeldshaper);

void CleanSpines(object oMeldshaper)
{
	object oItem = GetItemPossessedBy(oMeldshaper, "skarn_spine");
	if (GetIsObjectValid(oItem)) 
	{
		DestroyObject(oItem);
		DelayCommand(0.1, CleanSpines(oMeldshaper));
	}	
}

void main()
{
    object oMeldshaper = OBJECT_SELF;
    object oItem = GetItemPossessedBy(oMeldshaper, "skarn_spine");
    int nClass = GetLevelByClass(CLASS_TYPE_SPINEMELD_WARRIOR, oMeldshaper);
    if (GetIsObjectValid(oItem))
    {
    	CleanSpines(oMeldshaper);	
    }    
    else if (nClass)
    {
    	// Right Hand
        oItem = CreateItemOnObject("nw_wswss001", oMeldshaper, 1, "skarn_spine");
        SetPlotFlag(oItem, TRUE);
        SetDroppableFlag(oItem, FALSE);   
        AssignCommand(oMeldshaper, ActionEquipItem(oItem, INVENTORY_SLOT_RIGHTHAND));
        if (nClass >= 5) // Spine Rend
            IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);        
        
        if (nClass >= 9)
        {
        	IPSafeAddItemProperty(oItem, ItemPropertyAttackBonus(5), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        	IPSafeAddItemProperty(oItem, ItemPropertyAttackPenalty(5), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }         
        else if (GetIsChakraBound(oMeldshaper, CHAKRA_ARMS))
        {
        	IPSafeAddItemProperty(oItem, ItemPropertyAttackBonus(3), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        	IPSafeAddItemProperty(oItem, ItemPropertyAttackPenalty(3), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }         
        
        // Left Hand
		oItem = CreateItemOnObject("nw_wswss001", oMeldshaper, 1, "skarn_spine");
        SetPlotFlag(oItem, TRUE);
        SetDroppableFlag(oItem, FALSE); 		
        AssignCommand(oMeldshaper, ActionEquipItem(oItem, INVENTORY_SLOT_LEFTHAND));  
        if (nClass >= 5) // Spine Rend
            IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);           
        
        if (nClass >= 9)
        {
        	IPSafeAddItemProperty(oItem, ItemPropertyAttackBonus(5), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        	IPSafeAddItemProperty(oItem, ItemPropertyAttackPenalty(5), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }         
        else if (GetIsChakraBound(oMeldshaper, CHAKRA_ARMS))
        {
        	IPSafeAddItemProperty(oItem, ItemPropertyAttackBonus(3), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        	IPSafeAddItemProperty(oItem, ItemPropertyAttackPenalty(3), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }         
    }
    else
    {
        oItem = CreateItemOnObject("nw_wswss001", oMeldshaper, 1, "skarn_spine");
        // No dropping and no selling the item
        SetPlotFlag(oItem, TRUE);
        SetDroppableFlag(oItem, FALSE);   
        
        object oRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oMeldshaper);
        object oLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oMeldshaper);
        if (!GetIsObjectValid(oRight))
            AssignCommand(oMeldshaper, ActionEquipItem(oItem, INVENTORY_SLOT_RIGHTHAND));
        else if (!GetIsObjectValid(oLeft))
            AssignCommand(oMeldshaper, ActionEquipItem(oItem, INVENTORY_SLOT_LEFTHAND)); 
        else
        {
            DestroyObject(oItem);
            FloatingTextStringOnCreature("You have no free hands to use your Skarn Spine with", oMeldshaper, FALSE);
        }    
        
        if (GetIsObjectValid(oItem) && GetIsChakraBound(oMeldshaper, CHAKRA_ARMS))
        {
        	IPSafeAddItemProperty(oItem, ItemPropertyAttackBonus(3), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        	IPSafeAddItemProperty(oItem, ItemPropertyAttackPenalty(3), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        } 	
    }    
}