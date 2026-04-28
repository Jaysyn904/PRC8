//::///////////////////////////////////////////////  
//:: Name: prc_souleater  
//:: FileName: prc_souleater.nss  
//:://////////////////////////////////////////////  
/*  
    Soul Eater class heartbeat script  
    Ensures onHit energy drain is applied to unarmed attacks  
*/  
//:://////////////////////////////////////////////  
//:: Created By: Jaysyn
//:: Created On: 2026-04-27 12:35:59 
//:://////////////////////////////////////////////  
  
#include "prc_inc_combat"  
#include "prc_inc_onhit"  
  
void main()  
{  
    object oPC = OBJECT_SELF;  
      
    // Only proceed if character is a Soul Eater  
    if(GetLevelByClass(CLASS_TYPE_SOUL_EATER, oPC) == 0)  
        return;  
          
    // Only proceed if unarmed (no melee weapon equipped)  
    if(!GetIsUnarmed(oPC))  
        return;  
          
    // Get the unarmed weapon (creature weapon or gloves)  
    object oUnarmedWeapon = GetUnarmedWeapon(oPC);  
      
    // Apply onHit property if weapon is valid  
    if(GetIsObjectValid(oUnarmedWeapon))  
    {  
        // Remove any existing temporary properties first  
        RemoveSpecificProperty(oUnarmedWeapon, ITEM_PROPERTY_ONHITCASTSPELL,   
                              IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);  
          
        // Set up the signature for event routing  
        SetLocalInt(oUnarmedWeapon, PRC_CUSTOM_ONHIT_SIGNATURE + "prc_uni_shift", TRUE);  
          
        // Add temporary onHit property  
        IPSafeAddItemProperty(oUnarmedWeapon,   
                             ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1),   
                             9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);  
    }  
}