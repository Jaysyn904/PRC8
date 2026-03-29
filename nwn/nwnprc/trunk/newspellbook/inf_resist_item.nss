// inf_resist_item.nss  

/* 
Resistance Item
Abjuration
Level: Artificer 1
Components: S, M
Casting Time: 1 round
Range: Touch
Target: Item touched
Duration: 10 min./level
Saving Throw: None
Spell Resistance: No

A nonmagical item imbued with this infusion grants a + 1 resistance 
bonus on saving throws to a character who wears or wields it. This 
bonus increases by 1 for every four caster levels (to +2 at 4th level,
 +3 at 8th level, +4 at 12th level, and so forth).
Material Component: Oil mixed with various spices and minerals. 
*/
     
#include "prc_craft_inc"    
#include "inc_dynconv"  
  
// Spell constants for subradials  
const int RESISTANCE_ITEM_FORTITUDE = 6001;  
const int RESISTANCE_ITEM_REFLEX = 6002;  
const int RESISTANCE_ITEM_WILL = 6003;  
  
// Check if item is magical  
int GetIsItemMagical(object oItem)  
{  
    if(!GetIsObjectValid(oItem)) return FALSE;  
      
    // Skip plot items  
    if(GetPlotFlag(oItem)) return TRUE;  
      
    int bIsMagical = FALSE;  
    itemproperty ipCheck = GetFirstItemProperty(oItem);  
    while (GetIsItemPropertyValid(ipCheck))  
    {  
        string sTag = GetItemPropertyTag(ipCheck);  
        int nType = GetItemPropertyType(ipCheck);  
            
        // Check for protected properties  
        if(sTag == "Tag_PRC_OnHitKeeper" ||     
           sTag == "Quality_Masterwork" ||    
           sTag == "Material_Mithral" ||    
           sTag == "Material_Adamantine" ||    
           sTag == "Material_Darkwood" ||    
           sTag == "Material_ColdIron" ||    
           sTag == "Material_MundaneCrystal" ||    
           sTag == "Material_DeepCrystal" ||    
           nType == ITEM_PROPERTY_MATERIAL)  // All material properties    
        {  
            // Protected property - skip, don't set bIsMagical    
        }  
        else  
        {  
            // Check for helmet carveout: +1 Concentration only    
            if(GetBaseItemType(oItem) == BASE_ITEM_HELMET &&       
               GetItemPropertyType(ipCheck) == ITEM_PROPERTY_SKILL_BONUS &&      
               GetItemPropertySubType(ipCheck) == SKILL_CONCENTRATION &&      
               GetItemPropertyCostTableValue(ipCheck) == 1)    
            {  
                // This is a +1 Concentration helmet with no other properties, allow it    
                bIsMagical = FALSE;    
                break;    
            }  
            else  
            {  
                bIsMagical = TRUE;    
                break;    
            }  
        }  
        ipCheck = GetNextItemProperty(oItem);  
    }  
      
    return bIsMagical;  
}  
  
// Find first non-magical item on creature  
object GetFirstNonMagicalItem(object oCreature)  
{  
    // Check equipped items first  
    int nSlot;  
    for(nSlot = 0; nSlot < NUM_INVENTORY_SLOTS; nSlot++)  
    {  
        object oItem = GetItemInSlot(nSlot, oCreature);  
        if(GetIsObjectValid(oItem) && !GetIsItemMagical(oItem))  
            return oItem;  
    }  
      
    // Check inventory  
    object oItem = GetFirstItemInInventory(oCreature);  
    while(GetIsObjectValid(oItem))  
    {  
        if(!GetIsItemMagical(oItem))  
            return oItem;  
        oItem = GetNextItemInInventory(oCreature);  
    }  
      
    return OBJECT_INVALID;  
}  
  
void main()  
{  
    PRCSetSchool(SPELL_SCHOOL_ABJURATION);  
    if (!X2PreSpellCastCode()) return;  
      
    object oCaster = OBJECT_SELF;  
    //object oTarget = PRCGetSpellTargetObject();  
    object oTarget = OBJECT_SELF;  //:: for testing
	
	int nCasterLevel = PRCGetCasterLevel(oCaster);  
	//int nSpellID = PRCGetSpellId(); 
	int nSpellID = RESISTANCE_ITEM_FORTITUDE;  	
      
    // Calculate resistance bonus: +1 +1 per 4 caster levels  
    int nBonus = 1 + (nCasterLevel / 4);  
      
    // Calculate duration: 10 minutes per level  
    float fDuration = TurnsToSeconds(nCasterLevel * 10);  
    int nMetaMagic = PRCGetMetaMagicFeat();  
    if(nMetaMagic & METAMAGIC_EXTEND)  
        fDuration *= 2;  
      
    // Add fallback for very small durations  
    if (fDuration <= 1.0) fDuration = 30.0f; // 30 seconds is fine for testing
      
    // Determine save type based on infusion spellID  
    int nSaveType;  
    string sSaveName;  
      
    switch(nSpellID)  
    {  
        case RESISTANCE_ITEM_FORTITUDE:  
            nSaveType = SAVING_THROW_FORT;  
            sSaveName = "Fortitude";  
            break;  
        case RESISTANCE_ITEM_REFLEX:  
            nSaveType = SAVING_THROW_REFLEX;  
            sSaveName = "Reflex";  
            break;  
        case RESISTANCE_ITEM_WILL:  
            nSaveType = SAVING_THROW_WILL;  
            sSaveName = "Will";  
            break;  
        default:  
            FloatingTextStringOnCreature("Invalid resistance spell type.", oCaster, FALSE);  
            return;  
    }  
      
    object oItem;  
      
    // Handle targeting  
    if(GetObjectType(oTarget) == OBJECT_TYPE_ITEM)  
    {  
        oItem = oTarget;  
    }  
    else if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)  
    {  
        oItem = GetFirstNonMagicalItem(oTarget);  
        if(!GetIsObjectValid(oItem))  
        {  
            FloatingTextStringOnCreature(GetName(oTarget) + " has no non-magical items to infuse.", oCaster, FALSE);  
            return;  
        }  
    }  
    else  
    {  
        FloatingTextStringOnCreature("Invalid target. Must target an item or creature.", oCaster, FALSE);  
        return;  
    }  
      
    // Validate item  
    if(!GetIsObjectValid(oItem))  
    {  
        FloatingTextStringOnCreature("Invalid item target.", oCaster, FALSE);  
        return;  
    }  
      
    if(GetPlotFlag(oItem))  
    {  
        FloatingTextStringOnCreature("Cannot infuse plot items.", oCaster, FALSE);  
        return;  
    }  
      
    if(GetIsItemMagical(oItem))  
    {  
        FloatingTextStringOnCreature(GetName(oItem) + " is already magical. Can only infuse non-magical items.", oCaster, FALSE);  
        return;  
    }  
      
    // Check for existing resistance infusion to prevent stacking  
    itemproperty ipExisting = GetFirstItemProperty(oItem);  
    while(GetIsItemPropertyValid(ipExisting))  
    {  
        if(GetItemPropertyTag(ipExisting) == "ResistanceInfusion")  
        {  
            FloatingTextStringOnCreature(GetName(oItem) + " already has a resistance infusion.", oCaster, FALSE);  
            return;  
        }  
        ipExisting = GetNextItemProperty(oItem);  
    }  
      
    // Create and apply the resistance bonus property  
    itemproperty ip = ItemPropertyBonusSavingThrow(nSaveType, nBonus);  
    ip = TagItemProperty(ip, "ResistanceInfusion");  
    IPSafeAddItemProperty(oItem, ip, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);  
      
    FloatingTextStringOnCreature(sSaveName + " resistance +" + IntToString(nBonus) + " applied to " + GetName(oItem) + ".", oCaster, FALSE);  
}