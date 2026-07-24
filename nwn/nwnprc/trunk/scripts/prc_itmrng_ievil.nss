//::///////////////////////////////////////////////
//:: Ring of Ineffable Evil
//:: prc_itmrng_ievil
//::///////////////////////////////////////////////
/*
    Equip (evil/neutral):  Permanent, undispellable
                           mind-spell immunity and SR 25
                           vs good + on-hit STR drain
                           vs good attackers via skin.
    Equip (good):          Permanent, undispellable
                           negative level.
    Unequip:               Both effects removed.
 
    Note: +4 deflection AC and +4 resistance saves
    are handled as itemprops in craft_ring.2da.
 
    Registered via PRC8 event hook system —
    works for PCs and NPCs alike.
*/
//::///////////////////////////////////////////////
#include "prc_inc_spells"  
#include "prc_inc_skin"  
#include "inc_eventhook"  
#include "prc_inc_function"
 
const string RING_UNHOLY_AURA_TAG     	= "PRC_RING_UNHOLY_AURA";
const string RING_UNHOLY_AURA_NL      	= "PRC_RING_UNHOLY_AURA_NL";
const string RING_UNHOLY_AURA_ONHIT		= "PRC_RING_UNHOLY_AURA_OH";
const string RING_INEFFABLE_EVIL_TAG 	= "PRC_ITMRNG_IEVIL";
const string RING_UNHOLY_AURA_ARMOR		= "PRC_RING_UNHOLY_AURA_ARMOR";
 
// -------------------------------------------------------------------
// On-hit STR Drain handler — routed via PRC event system
// -------------------------------------------------------------------
void OnHitUnholyAura(object oPC)    
{    
    object oItem = GetSpellCastItem();    
    object oAttacker = PRCGetSpellTargetObject();    
      
    if(GetBaseItemType(oPC) == BASE_ITEM_ARMOR ||   
       GetBaseItemType(oPC) == BASE_ITEM_CREATUREITEM)  
    {  
        oPC = GetItemPossessor(oPC);  
    }  
        
    if(DEBUG) DoDebug("prc_itmrng_ievil: OnHitUnholyAura called\n"    
                    + "oPC = " + DebugObject2Str(oPC) + "\n"    
                    + "oItem = " + DebugObject2Str(oItem) + "\n"    
                    + "oAttacker = " + DebugObject2Str(oAttacker) + "\n"    
                    + "ItemType = " + IntToString(GetBaseItemType(oItem)) + "\n"    
                      );    
        
    // Check for armor or creature skin    
    if(GetBaseItemType(oItem) != BASE_ITEM_ARMOR &&    
       GetBaseItemType(oItem) != BASE_ITEM_CREATUREITEM)    
    {    
        if(DEBUG) DoDebug("prc_itmrng_ievil: Not from armor or skin, returning");    
        return;    
    }    
        
    if (!GetIsObjectValid(oAttacker))    
    {    
        if(DEBUG) DoDebug("prc_itmrng_ievil: Invalid attacker, returning");    
        return;    
    }    
        
    if (GetAlignmentGoodEvil(oAttacker) != ALIGNMENT_GOOD)    
    {    
        if(DEBUG) DoDebug("prc_itmrng_ievil: Attacker not good, returning");    
        return;    
    }    
    
    int nDC = 10 + 8 + GetAbilityModifier(ABILITY_WISDOM, oPC);    
    if(DEBUG) DoDebug("prc_itmrng_ievil: DC = " + IntToString(nDC));    
    
    if (!PRCMySavingThrow(SAVING_THROW_FORT, oAttacker, nDC,    
            SAVING_THROW_TYPE_SPELL, oPC))    
	{  
		if(DEBUG) DoDebug("prc_itmrng_ievil: Save failed, applying STR drain");
		int nStrDrain = d6();  
		ApplyAbilityDamage(oAttacker, ABILITY_STRENGTH, nStrDrain, DURATION_TYPE_TEMPORARY, TRUE, -1.0f);  
		ApplyEffectToObject(DURATION_TYPE_INSTANT,  
			EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE), oAttacker);  
	} 	   
    else    
    {    
        if(DEBUG) DoDebug("prc_itmrng_ievil: Save succeeded");    
    }    
}
 
// -------------------------------------------------------------------
// Skin on-hit property management
// -------------------------------------------------------------------
void RemoveOnHitPropFromItem(object oItem)
{
    itemproperty ip = GetFirstItemProperty(oItem);
    while(GetIsItemPropertyValid(ip))
    {
        if(GetItemPropertyTag(ip) == RING_UNHOLY_AURA_ONHIT)
            RemoveItemProperty(oItem, ip);
        ip = GetNextItemProperty(oItem);
    }
}
 
void AddOnHitToSkin(object oPC)
{
    object oSkin  = GetPCSkin(oPC);
    object oArmor = GetLocalObject(oPC, RING_UNHOLY_AURA_ARMOR);
 
    itemproperty ip = ItemPropertyOnHitCastSpell(
        IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1);
    ip = TagItemProperty(ip, RING_UNHOLY_AURA_ONHIT);
 
    if(GetIsObjectValid(oArmor))
    {
        RemoveOnHitPropFromItem(oArmor);
        IPSafeAddItemProperty(oArmor, ip, 9999.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        AddEventScript(oArmor, EVENT_ITEM_ONHIT, "prc_itmrng_ievil", TRUE, FALSE);
    }
    else
    {
        RemoveOnHitPropFromItem(oSkin);
        IPSafeAddItemProperty(oSkin, ip, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        AddEventScript(oPC, EVENT_ONHIT, "prc_itmrng_ievil", TRUE, FALSE);
    }
 
    SetLocalString(oPC, RING_UNHOLY_AURA_ONHIT, "prc_itmrng_ievil");
 
    if(DEBUG) DoDebug("prc_itmrng_ievil: Added on-hit to armor/skin and hooked event");
}

void RemoveOnHitFromSkin(object oPC)
{
    object oArmor = GetLocalObject(oPC, RING_UNHOLY_AURA_ARMOR);
    if(GetIsObjectValid(oArmor))
    {
        RemoveEventScript(oArmor, EVENT_ITEM_ONHIT, "prc_itmrng_ievil", TRUE, FALSE);
        RemoveOnHitPropFromItem(oArmor);
    }
    else
    {
        RemoveEventScript(oPC, EVENT_ONHIT, "prc_itmrng_ievil", TRUE, FALSE);
        RemoveOnHitPropFromItem(GetPCSkin(oPC));
    }
 
    DeleteLocalObject(oPC, RING_UNHOLY_AURA_ARMOR);
    DeleteLocalString(oPC, RING_UNHOLY_AURA_ONHIT);
}

void OnArmorEquip()  
{  
    object oPC   = GetPCItemLastEquippedBy();  
    object oItem = GetPCItemLastEquipped();  
   
    if(GetLocalString(oPC, RING_UNHOLY_AURA_ONHIT) != "prc_itmrng_ievil") return;  
    if(GetBaseItemType(oItem) != BASE_ITEM_ARMOR) return;  
   
    object oOldArmor = GetLocalObject(oPC, RING_UNHOLY_AURA_ARMOR);  
    if(GetIsObjectValid(oOldArmor))  
    {  
        RemoveOnHitPropFromItem(oOldArmor);  
        RemoveEventScript(oOldArmor, EVENT_ITEM_ONHIT, "prc_itmrng_ievil", TRUE, FALSE);  
    }  
    else  
    {  
        RemoveOnHitPropFromItem(GetPCSkin(oPC));  
        RemoveEventScript(oPC, EVENT_ONHIT, "prc_itmrng_ievil", TRUE, FALSE);  
    }  
   
    itemproperty ip = ItemPropertyOnHitCastSpell(  
        IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1);  
    ip = TagItemProperty(ip, RING_UNHOLY_AURA_ONHIT);  
    IPSafeAddItemProperty(oItem, ip, 9999.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
    AddEventScript(oItem, EVENT_ITEM_ONHIT, "prc_itmrng_ievil", TRUE, FALSE);  
    SetLocalObject(oPC, RING_UNHOLY_AURA_ARMOR, oItem);  
   
    if(DEBUG) DoDebug("prc_itmrng_ievil: Moved on-hit to newly equipped armor");  
}
 
void OnArmorUnequip()  
{  
    object oPC   = GetPCItemLastUnequippedBy();  
    object oItem = GetPCItemLastUnequipped();  
   
    if(GetLocalString(oPC, RING_UNHOLY_AURA_ONHIT) != "prc_itmrng_ievil") return;  
    if(GetBaseItemType(oItem) != BASE_ITEM_ARMOR) return;  
   
    // Remove event script and property from the tracked item  
    RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "prc_itmrng_ievil", TRUE, FALSE);  
    RemoveOnHitPropFromItem(oItem);  
    DeleteLocalObject(oPC, RING_UNHOLY_AURA_ARMOR);  
    
    AddOnHitToSkin(oPC);  
   
    if(DEBUG) DoDebug("prc_itmrng_ievil: Removed on-hit from unequipped armor, moved to skin");  
}

// -------------------------------------------------------------------
// Aura and penalty application/removal
// -------------------------------------------------------------------
void ApplyUnholyAura(object oPC)
{
    // Strip any existing ring aura to prevent stacking on re-equip
    effect e = GetFirstEffect(oPC);
    while (GetIsEffectValid(e))
    {
        if (GetEffectTag(e) == RING_UNHOLY_AURA_TAG)
            RemoveEffect(oPC, e);
        e = GetNextEffect(oPC);
    }
 
    object oWornArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    if(GetIsObjectValid(oWornArmor) && GetBaseItemType(oWornArmor) == BASE_ITEM_ARMOR)
        SetLocalObject(oPC, RING_UNHOLY_AURA_ARMOR, oWornArmor);
    else
        DeleteLocalObject(oPC, RING_UNHOLY_AURA_ARMOR); // clean state ? falls to skin
 
    effect eImmune = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
    effect eSR     = EffectSpellResistanceIncrease(25);
    effect eDur    = EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MAJOR);
    effect eDur2   = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
 
    eImmune = VersusAlignmentEffect(eImmune, ALIGNMENT_ALL, ALIGNMENT_EVIL);
    eSR     = VersusAlignmentEffect(eSR,     ALIGNMENT_ALL, ALIGNMENT_EVIL);
 
    effect eLink = EffectLinkEffects(eImmune, eSR);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eDur2);
 
    eLink = TagEffect(eLink, RING_UNHOLY_AURA_TAG);
    eLink = SupernaturalEffect(eLink);
    eLink = UnyieldingEffect(eLink);
 
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MAJOR), oPC);
 
    AddOnHitToSkin(oPC);
 
    // Register rest handler
    AddEventScript(oPC, EVENT_ONPLAYERREST_FINISHED, "prc_itmrng_ievil", TRUE, FALSE);
}

void ApplyGoodPenalty(object oPC)
{
    effect e = GetFirstEffect(oPC);
    while (GetIsEffectValid(e))
    {
        if (GetEffectTag(e) == RING_UNHOLY_AURA_NL)
            RemoveEffect(oPC, e);
        e = GetNextEffect(oPC);
    }
 
    effect eNL = EffectNegativeLevel(1);
    eNL = TagEffect(eNL, RING_UNHOLY_AURA_NL);
    eNL = SupernaturalEffect(eNL);
    eNL = UnyieldingEffect(eNL);
 
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eNL, oPC);
}
 
void RemoveRingEffects(object oPC)
{
    effect e = GetFirstEffect(oPC);
    while (GetIsEffectValid(e))
    {
        string sTag = GetEffectTag(e);
        if (sTag == RING_UNHOLY_AURA_TAG || sTag == RING_UNHOLY_AURA_NL)
            RemoveEffect(oPC, e);
        e = GetNextEffect(oPC);
    }
    RemoveOnHitFromSkin(oPC);
}
 
// -------------------------------------------------------------------
// Event handlers
// -------------------------------------------------------------------

 // -------------------------------------------------------------------
// Rest handlers — FIX: DelayCommand needs an action, not a void call
// -------------------------------------------------------------------
void _ReAddOnHit(object oPC) { AddOnHitToSkin(oPC); }

void OnEquip()
{
    object oPC   = GetPCItemLastEquippedBy();
    object oItem = GetPCItemLastEquipped();
 
    if (GetTag(oItem) != RING_INEFFABLE_EVIL_TAG) return;
 
    if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD)
        ApplyGoodPenalty(oPC);
    else
        ApplyUnholyAura(oPC);
}
 
void OnUnequip()
{
    object oPC   = GetPCItemLastUnequippedBy();
    object oItem = GetPCItemLastUnequipped();
 
    if (GetTag(oItem) != RING_INEFFABLE_EVIL_TAG) return;
 
    RemoveRingEffects(oPC);
}

void OnPlayerRestStarted()
{
    object oPC = GetLastBeingRested();
 
    object oRingLeft  = GetItemInSlot(INVENTORY_SLOT_LEFTRING,  oPC);
    object oRingRight = GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oPC);
 
    if(GetTag(oRingLeft)  != RING_INEFFABLE_EVIL_TAG &&
       GetTag(oRingRight) != RING_INEFFABLE_EVIL_TAG) return;
 
    DelayCommand(0.1, AssignCommand(oPC, _ReAddOnHit(oPC)));
 
    if(DEBUG) DoDebug("prc_itmrng_ievil: Re-applied on-hit after rest started");
}
void OnPlayerRestFinished()
{
    object oPC = GetLastBeingRested();
 
    object oRingLeft  = GetItemInSlot(INVENTORY_SLOT_LEFTRING,  oPC);
    object oRingRight = GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oPC);
 
    if(GetTag(oRingLeft)  != RING_INEFFABLE_EVIL_TAG &&
       GetTag(oRingRight) != RING_INEFFABLE_EVIL_TAG) return;
 
    // ?? FIX: same here — deferred properly now
    DelayCommand(1.0, AssignCommand(oPC, _ReAddOnHit(oPC)));
 
    if(DEBUG) DoDebug("prc_itmrng_ievil: Re-applied on-hit after rest finished");
}
  

 

 
void main()        
{        
    int nEvent = GetRunningEvent();        
        
    switch (nEvent)        
    {        
        case EVENT_ONPLAYEREQUIPITEM:           
            if(GetTag(GetPCItemLastEquipped()) == RING_INEFFABLE_EVIL_TAG)        
                OnEquip();        
            else if(GetBaseItemType(GetPCItemLastEquipped()) == BASE_ITEM_ARMOR)        
                OnArmorEquip();        
            break;        
        case EVENT_ONPLAYERUNEQUIPITEM:         
            if(GetTag(GetPCItemLastUnequipped()) == RING_INEFFABLE_EVIL_TAG)        
                OnUnequip();        
            else if(GetBaseItemType(GetPCItemLastUnequipped()) == BASE_ITEM_ARMOR)        
                OnArmorUnequip();        
            break;        
        case EVENT_ONHIT:                      
            OnHitUnholyAura(OBJECT_SELF);         
            break;  
		case EVENT_ITEM_ONHIT:  
			OnHitUnholyAura(OBJECT_SELF);  
			break;			
		case EVENT_ONPLAYERREST_STARTED:  
			OnPlayerRestStarted();  
			break;			
        case EVENT_ONPLAYERREST_FINISHED:        
            OnPlayerRestFinished();        
            break;      
    }        
}