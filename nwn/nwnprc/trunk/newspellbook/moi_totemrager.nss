//::///////////////////////////////////////////////
//:: Totem Rager
//:: prc_totrag.nss
//:://////////////////////////////////////////////
//:: Applies the passive bonuses from Totem Rager
//:://////////////////////////////////////////////
//:: Created By: Barmlot (with lots of help from Stratovarius)
//:: Created On: July 3, 2020
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
	object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nLevel = GetLevelByClass(CLASS_TYPE_TOTEM_RAGER, oPC);	

    if(GetLocalInt(oSkin, "TotemRagerDR") == nLevel) return;

    int nDR;
    if (nLevel >= 7) nDR = IP_CONST_DAMAGERESIST_2;
    else if (nLevel >= 3) nDR = IP_CONST_DAMAGERESIST_1;

    //AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_PIERCING, nDR), oSkin);
    //AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_SLASHING, nDR), oSkin);
    //AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_BLUDGEONING, nDR), oSkin);
    itemproperty ipIP =ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_SLASHING, nDR);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    ipIP =ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_PIERCING, nDR);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    ipIP =ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_BLUDGEONING, nDR);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);    
    SetLocalInt(oSkin, "TotemRagerDR", nLevel);	
}

