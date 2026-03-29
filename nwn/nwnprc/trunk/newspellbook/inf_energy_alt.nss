// inf_energy_alt.nss        
#include "prc_sp_func"        
#include "prc_inc_spells"        
#include "psi_inc_enrgypow"        
#include "prc_craft_inc"  // Add this for item property serialization      
      
const int SPELL_ENERGY_ALTERATION_COLD = 9000;        
const int SPELL_ENERGY_ALTERATION_ELEC = 9001;         
const int SPELL_ENERGY_ALTERATION_FIRE = 9002;        
const int SPELL_ENERGY_ALTERATION_SONIC = 9003;      
      
// Forward declarations      
void StoreOriginalProperties(object oItem);      
void RestoreOriginalProperties(object oItem);      
int ConvertDamageTypeToIPConst(int nDamageType);      
      
// Convert DAMAGE_TYPE_* to IP_CONST_DAMAGETYPE_*      
int ConvertDamageTypeToIPConst(int nDamageType)      
{      
    switch(nDamageType)      
    {      
        case DAMAGE_TYPE_ACID:     return IP_CONST_DAMAGETYPE_ACID;      
        case DAMAGE_TYPE_COLD:     return IP_CONST_DAMAGETYPE_COLD;      
        case DAMAGE_TYPE_ELECTRICAL: return IP_CONST_DAMAGETYPE_ELECTRICAL;      
        case DAMAGE_TYPE_FIRE:     return IP_CONST_DAMAGETYPE_FIRE;      
        case DAMAGE_TYPE_SONIC:    return IP_CONST_DAMAGETYPE_SONIC;      
        default:                   return IP_CONST_DAMAGETYPE_ACID;      
    }      
    return IP_CONST_DAMAGETYPE_ACID; // Add explicit return for compiler    
}      
      
void ApplyEnergyAlteration(object oItem, int nSpellID, int nCasterLvl)        
{        
    struct energy_adjustments enAdj = EvaluateEnergy(        
        nSpellID,         
        SPELL_ENERGY_ALTERATION_COLD,        
        SPELL_ENERGY_ALTERATION_ELEC,         
        SPELL_ENERGY_ALTERATION_FIRE,        
        SPELL_ENERGY_ALTERATION_SONIC        
    );        
            
    // Modify existing energy properties        
    itemproperty ip = GetFirstItemProperty(oItem);        
    while(GetIsItemPropertyValid(ip))        
    {        
        int nType = GetItemPropertyType(ip);        
                
        // Replace damage bonus properties        
        if(nType == ITEM_PROPERTY_DAMAGE_BONUS)        
        {        
            int nDamageType = GetItemPropertySubType(ip);        
            if(nDamageType == DAMAGE_TYPE_ACID || nDamageType == DAMAGE_TYPE_COLD ||         
               nDamageType == DAMAGE_TYPE_ELECTRICAL || nDamageType == DAMAGE_TYPE_FIRE ||        
               nDamageType == DAMAGE_TYPE_SONIC)        
            {        
                RemoveItemProperty(oItem, ip);        
                itemproperty ipNew = ItemPropertyDamageBonus(enAdj.nDamageType, GetItemPropertyCostTableValue(ip));        
                AddItemProperty(DURATION_TYPE_TEMPORARY, ipNew, oItem, RoundsToSeconds(nCasterLvl * 10));        
                SetLocalInt(oItem, "EnergyAlter_Temp_" + IntToString(ITEM_PROPERTY_DAMAGE_BONUS), TRUE);        
            }        
        }        
                
        // Replace resistance properties        
        if(nType == ITEM_PROPERTY_DAMAGE_RESISTANCE)        
        {        
            int nResistType = GetItemPropertySubType(ip);        
            if(nResistType == IP_CONST_DAMAGETYPE_ACID || nResistType == IP_CONST_DAMAGETYPE_COLD ||        
               nResistType == IP_CONST_DAMAGETYPE_ELECTRICAL || nResistType == IP_CONST_DAMAGETYPE_FIRE ||        
               nResistType == IP_CONST_DAMAGETYPE_SONIC)        
            {        
                RemoveItemProperty(oItem, ip);        
                int nNewType = ConvertDamageTypeToIPConst(enAdj.nDamageType);        
                itemproperty ipNew = ItemPropertyDamageResistance(nNewType, GetItemPropertyCostTableValue(ip));        
                AddItemProperty(DURATION_TYPE_TEMPORARY, ipNew, oItem, RoundsToSeconds(nCasterLvl * 10));        
                SetLocalInt(oItem, "EnergyAlter_Temp_" + IntToString(ITEM_PROPERTY_DAMAGE_RESISTANCE), TRUE);        
            }        
        }        
                
        ip = GetNextItemProperty(oItem);        
    }        
            
    // Schedule restoration        
    DelayCommand(RoundsToSeconds(nCasterLvl * 10), RestoreOriginalProperties(oItem));        
}      
        
// Store original properties with PRC persistent backup        
void StoreOriginalProperties(object oItem)        
{        
    string sItemID = GetObjectUUID(oItem);        
    itemproperty ip = GetFirstItemProperty(oItem);        
            
    while(GetIsItemPropertyValid(ip))        
    {        
        string sPropData = GetItemPropertyString(ip);  // Use PRC's function      
        SetLocalString(oItem, "EnergyAlter_Original_" + IntToString(GetItemPropertyType(ip)), sPropData);        
                
        // PRC persistence for crash recovery      
        SetPersistantLocalString(oItem, "EnergyAlter_" + sItemID + "_" + IntToString(GetItemPropertyType(ip)), sPropData);        
        ip = GetNextItemProperty(oItem);        
    }        
            
    SetLocalInt(oItem, "EnergyAlter_Active", TRUE);        
    SetLocalString(oItem, "EnergyAlter_ItemID", sItemID);        
}        
        
// Restore properties with cleanup        
void RestoreOriginalProperties(object oItem)        
{        
    string sItemID = GetLocalString(oItem, "EnergyAlter_ItemID");        
            
    // Remove temporary properties        
    itemproperty ip = GetFirstItemProperty(oItem);        
    while(GetIsItemPropertyValid(ip))        
    {        
        if(GetLocalInt(oItem, "EnergyAlter_Temp_" + IntToString(GetItemPropertyType(ip))))        
            RemoveItemProperty(oItem, ip);        
        ip = GetNextItemProperty(oItem);        
    }        
            
    // Restore original properties        
    int nType;        
    for(nType = 0; nType < 100; nType++)        
    {        
        string sPropData = GetPersistantLocalString(oItem, "EnergyAlter_" + sItemID + "_" + IntToString(nType));        
        if(sPropData != "")        
        {        
            struct ipstruct ipData = GetIpStructFromString(sPropData);      
            itemproperty ipOriginal = ConstructIP(ipData.type, ipData.subtype, ipData.costtablevalue, ipData.param1value);      
            AddItemProperty(DURATION_TYPE_PERMANENT, ipOriginal, oItem);        
        }        
    }        
            
    // Cleanup - clear PRC persistent variables      
    DeletePersistantLocalString(oItem, "EnergyAlter_" + sItemID);        
    DeleteLocalInt(oItem, "EnergyAlter_Active");        
}        
        
void main()        
{        
    if(!X2PreSpellCastCode()) return;        
            
    object oCaster = OBJECT_SELF;        
    object oTarget = PRCGetSpellTargetObject();        
    int nSpellID = PRCGetSpellId();        
    int nCasterLvl = PRCGetCasterLevel(oCaster);        
            
    // Material component validation      (remove for testing)  
    // if(!GetIsObjectValid(GetItemPossessedBy(oCaster, "energy_alter_ointment")))        
    // {        
        // FloatingTextStringOnCreature("You need an alchemical ointment (50 gp) to cast this spell.", oCaster, FALSE);        
        // return;        
    // }        
    // DestroyObject(GetItemPossessedBy(oCaster, "energy_alter_ointment"));        
            
    // Store original properties and apply alteration        
    StoreOriginalProperties(oTarget);        
    ApplyEnergyAlteration(oTarget, nSpellID, nCasterLvl);        
}