#include "prc_alterations"

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("prc_sacpur_strike running, event: " + IntToString(nEvent));

    // Get the PC.
    object oPC = OBJECT_SELF;
    object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    
    // We're being called from the OnHit eventhook, so deal the damage
    // Once a round only, must have a turn undead attempt left
    if(nEvent == EVENT_ITEM_ONHIT && !GetLocalInt(oPC, "SacredPurifierDelay") && GetHasFeat(FEAT_TURN_UNDEAD,oPC))
    {
        DecrementRemainingFeatUses(oPC,FEAT_TURN_UNDEAD); // Burn a use
        oItem          = GetSpellCastItem();
        object oTarget = PRCGetSpellTargetObject();
        if(DEBUG) DoDebug("prc_sacpur_strike: OnHit:\n" + "oPC = " + DebugObject2Str(oPC) + "\n" + "oItem = " + DebugObject2Str(oItem) + "\n" + "oTarget = " + DebugObject2Str(oTarget) + "\n");

        // Only applies to melee weapons and undead 
        if(IPGetIsMeleeWeapon(oItem) && (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD
        || (GetHasFeat(FEAT_TOMB_TAINTED_SOUL, oTarget) && GetAlignmentGoodEvil(oTarget) != ALIGNMENT_GOOD)))
        {
            // Calculate damage and apply
            effect eDam = EffectDamage(d6(2),DAMAGE_TYPE_POSITIVE,DAMAGE_POWER_ENERGY);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
            FloatingTextStringOnCreature("Sacred Strike Hit", oPC, FALSE);
            SetLocalInt(oPC, "SacredPurifierDelay", TRUE);
            DelayCommand(6.0f, DeleteLocalInt(oPC, "SacredPurifierDelay")); // Once a round
            
            // Clean Up - user needs to reactivate feat
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "prc_sacpur_strike", TRUE, FALSE);
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);   
            return;
        }// end if - Item is a melee weapon
    }// end if - Running OnHit event          

        // We aren't being called from any event, but from the class feat
        // Hook in the OnHit event for Sacred Strike
        if(DEBUG) DoDebug("prc_sacpur_strike: Adding eventhooks");

        if (IPGetIsMeleeWeapon(oItem)) // Melee weapons only
        {
            FloatingTextStringOnCreature("Sacred Strike Activated", oPC, FALSE);
            SetLocalInt(oPC, "SacredPurifierStrike", TRUE);
            IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            AddEventScript(oItem, EVENT_ITEM_ONHIT, "prc_sacpur_strike", TRUE, FALSE);
        }      
}
