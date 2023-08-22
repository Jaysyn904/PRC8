//::///////////////////////////////////////////////
//:: Baelnorn projection script
//:: prc_bn_project
//::///////////////////////////////////////////////
/**
    This script creates a copy of the PC casting it,
    switches the PC and copy's inventories and their
    locations. The PC is set to immortal.

    The projection ends when one of the following
    happens:

    1) This script is fired while there is a valid
       copy in existence.
    2) The PC reaches 1 HP.
    3) The copy dies. In this case, the PC also dies.

    In cases other than 3), the PC's hitpoints are set
    to what the copy had when the projection ended.
    When ending projection, the PC is returned back
    to the copy's location and their inventories are
    swapped back.

    The inventory swappage happens in order to prevent
    the PC from having access to most of their items.


    POTENTIAL PROBLEMS

    - There may be a way to abuse Projection to duplicate items.
    -- Should be preventable via strict checks in OnUnacquireItem
    - It may be possible to restore charges to items using projection


    @author Written By: Ornedan, Tenjac, and Primogenitor
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////
const string COPY_LOCAL_NAME             = "Baelnorn_Projection_Copy";
const string ALREADY_IMMORTAL_LOCAL_NAME = "BaelnornProjection_ImmortalAlready";
const float PROJECTION_HB_DELAY = 1.0f;

//////////////////////////////////////////////////
/* Function prototypes                          */
//////////////////////////////////////////////////

void PseudoPosses(object oPC, object oCopy);
void EndPosses(object oPC, object oCopy);
void ProjectionMonitor(object oPC, object oCopy);
void NerfWeapons(object oPC);
void UnNerfWeapons(object oPC);
void CleanCopy(object oImage);


//////////////////////////////////////////////////
/* Function defintions                          */
//////////////////////////////////////////////////

void main()
{
    // Get the main variables used.
    object oPC       = OBJECT_SELF;
    object oCopy     = GetLocalObject(oPC, COPY_LOCAL_NAME);
    location lPC     = GetLocation(oPC);
    location lTarget = GetSpellTargetLocation();
    effect eLight    = EffectVisualEffect(VFX_IMP_HEALING_X , FALSE);
    effect eGlow     = EffectVisualEffect(VFX_DUR_ETHEREAL_VISAGE, FALSE);
    int nFeat        = FEAT_PROJECTION;
    int nSpell       = GetSpellId();
    float fDur       = HoursToSeconds(1);
    
    if(DEBUG) DoDebug("prc_bn_project running.\n"
                    + "oPC = '" + GetName(oPC) + "' - '" + GetTag(oPC) + "' - " + ObjectToString(oPC)
                    + "Copy exists: " + DebugBool2String(GetIsObjectValid(oCopy))
                      );

    // Check if there is a valid copy around.
    // If so, abort
    if(nSpell == SPELL_END_PROJECTION )
    {
	  EndPosses(oPC, oCopy);
	  return;
    }

    // Create the copy
    oCopy = CopyObject(oPC, lTarget, OBJECT_INVALID, GetName(oPC) + "_" + COPY_LOCAL_NAME);
    CleanCopy(oCopy);
    // Attempted Fix to the Copy get's murdered problem.
    AddHenchman(oPC, oCopy);
    SetIsTemporaryFriend(oPC, oCopy, FALSE);
    // Set the copy to be undestroyable, so that it won't vanish to the ether
    // along with the PC's items.
    AssignCommand(oCopy, SetIsDestroyable(FALSE, FALSE, FALSE));
    // Make the copy immobile and minimize the AI on it
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectCutsceneImmobilize()), oCopy);
    SetAILevel(oCopy, AI_LEVEL_VERY_LOW);

    // Store a referece to the copy on the PC
    SetLocalObject(oPC, COPY_LOCAL_NAME, oCopy);

    //Set Immortal flag on the PC or if they were already immortal,
    //leave a note about it on them.
    if(GetImmortal(oPC))
    {
        if(DEBUG) DoDebug("prc_bn_project: The PC was already immortal");
        SetLocalInt(oPC, ALREADY_IMMORTAL_LOCAL_NAME, TRUE);
    }
    else{
        if(DEBUG) DoDebug("prc_bn_project: Setting PC immortal");
        SetImmortal(oPC, TRUE);
        DeleteLocalInt(oPC, ALREADY_IMMORTAL_LOCAL_NAME); // Paranoia
    }

    // Do VFX on PC and copy
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLight, oCopy);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLight, oPC);

    // Do the switching around
    PseudoPosses(oPC, oCopy);
    //SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eGlow, oPC, fDur);
    
    //Set up duration marker for ending effect
    DelayCommand(fDur, SetLocalInt(oPC, "PROJECTION_EXPIRED", 1));
}

// Moves the PC's items to the copy and switches their locations around
void PseudoPosses(object oPC, object oCopy)
{
    if(DEBUG) DoDebug("prc_bn_project: PseudoPosses():\n"
                    + "oPC = '" + GetName(oPC) + "'\n"
                    + "oCopy = '" + GetName(oCopy) + "'"
                      );
    // Make sure both objects are valid
    if(!GetIsObjectValid(oCopy) || !GetIsObjectValid(oPC)){
        if(DEBUG) DoDebug("PseudoPosses called, but one of the parameters wasn't a valid object. Object status:" +
                          "\nPC - " + (GetIsObjectValid(oPC) ? "valid":"invalid") +
                          "\nCopy - " + (GetIsObjectValid(oCopy) ? "valid":"invalid")
                          );

        // Some cleanup before aborting
        if(!GetLocalInt(oPC, ALREADY_IMMORTAL_LOCAL_NAME))
        {
            SetImmortal(oPC, FALSE);
            DeleteLocalInt(oPC, ALREADY_IMMORTAL_LOCAL_NAME);
        }
        MyDestroyObject(oCopy);
        DeleteLocalInt(oPC, "BaelnornProjection_Active");
        UnNerfWeapons(oPC);

        return;
    }

    // Set a local on the PC telling that it's a projection. This is used
    // to keep the PC from picking up or losing objects.
    SetLocalInt(oPC, "BaelnornProjection_Active", TRUE);

    // Make the PC's weapons as non-damaging as possible
    NerfWeapons(oPC);

    // Start a pseudo-hb to monitor the status of both PC and copy
    DelayCommand(PROJECTION_HB_DELAY, ProjectionMonitor(oPC, oCopy));

    // Add eventhooks
    
    if(DEBUG) DoDebug("AddEventScripts");
    
    AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,    "prc_bn_prj_event", TRUE, FALSE); // OnEquip
    //AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM,  "prc_bn_prj_event", TRUE, FALSE); // OnUnEquip
    AddEventScript(oPC, EVENT_ONACQUIREITEM,        "prc_bn_prj_event", TRUE, FALSE); // OnAcquire
    //AddEventScript(oPC, EVENT_ONUNAQUIREITEM,       "prc_bn_prj_event", TRUE, FALSE); // OnUnAcquire
    AddEventScript(oPC, EVENT_ONPLAYERREST_STARTED, "prc_bn_prj_event", FALSE, FALSE); // OnRest
    AddEventScript(oPC, EVENT_ONCLIENTENTER,        "prc_bn_prj_event", TRUE, FALSE); //OnClientEnter

    // Swap the copy and PC
    location lPC   = GetLocation(oPC);
    location lCopy = GetLocation(oCopy);
    DelayCommand(1.5f,AssignCommand(oPC, JumpToLocation(lCopy)));
    DelayCommand(1.5f,AssignCommand(oCopy, JumpToLocation(lPC)));
}


// Switches the PC's inventory back from the copy and returns the PC to the copy's location.
void EndPosses(object oPC, object oCopy)
{
    if(DEBUG) DoDebug("prc_bn_project: EndPosses():\n"
                    + "oPC = '" + GetName(oPC) + "'\n"
                    + "oCopy = '" + GetName(oCopy) + "'"
                      );

    //effect eGlow     = EffectVisualEffect(VFX_DUR_ETHEREAL_VISAGE, FALSE);
    effect eLight = EffectVisualEffect(VFX_IMP_HEALING_X , FALSE);
    
    // Remove Immortality from the PC if necessary
    if(!GetLocalInt(oPC, ALREADY_IMMORTAL_LOCAL_NAME))
        SetImmortal(oPC, FALSE);

    // Remove the VFX and the attack penalty
    PRCRemoveSpellEffects(SPELL_BAELNORN_PROJECTION, oPC, oPC);
        
    // Remove the local signifying that the PC is a projection
    DeleteLocalInt(oPC, "BaelnornProjection_Active");

    // Remove the local signifying projection being terminated by an external cause
    DeleteLocalInt(oPC, "PRC_BaelnornProjection_Abort");

    // Remove the heartbeat HP tracking local
    DeleteLocalInt(oPC, "PRC_BealnornProjection_HB_HP");

    // Remove weapons nerfing
    UnNerfWeapons(oPC);

    // Remove eventhooks
    RemoveEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,    "prc_bn_prj_event", TRUE, FALSE); // OnEquip
    RemoveEventScript(oPC, EVENT_ONACQUIREITEM,        "prc_bn_prj_event", TRUE, FALSE); // OnAcquire
    RemoveEventScript(oPC, EVENT_ONPLAYERREST_STARTED, "prc_bn_prj_event", FALSE, FALSE); // OnRest
    RemoveEventScript(oPC, EVENT_ONCLIENTENTER,        "prc_bn_prj_event", TRUE, FALSE); //OnClientEnter

    // Move PC and inventory
    location lCopy = GetLocation(oCopy);
    DelayCommand(1.5f, AssignCommand(oPC, JumpToLocation(lCopy)));

    // Set the PC's hitpoints to be whatever the copy has
    int nOffset = GetCurrentHitPoints(oCopy) - GetCurrentHitPoints(oPC);
    if(nOffset > 0)
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nOffset), oPC);
    else if (nOffset < 0)
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(-nOffset, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_ENERGY), oPC);

    // Schedule deletion of the copy
    DelayCommand(0.3f, MyDestroyObject(oCopy));

    //Delete the object reference
    DeleteLocalObject(oPC, COPY_LOCAL_NAME);

    // VFX
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eLight, lCopy, 3.0);
    DestroyObject(oCopy);
    
    //Remove duration marker
    DeleteLocalInt(oPC, "PROJECTION_EXPIRED");
}

//Runs tests to see if the projection effect can still continue.
//If the PC has reached 1 HP, end projection normally.
//If the copy is dead, end projection and kill the PC.
void ProjectionMonitor(object oPC, object oCopy)
{
    if(DEBUG) DoDebug("prc_bn_project: ProjectionMonitor():\n"
                    + "oPC = '" + GetName(oPC) + "'\n"
                    + "oCopy = '" + GetName(oCopy) + "'"
                      );
    // Abort if the projection is no longer marked as being active
    if(!GetLocalInt(oPC, "BaelnornProjection_Active"))
        return;

    // Some paranoia in case something interfered and either PC or copy has been destroyed
    if(!(GetIsObjectValid(oPC) && GetIsObjectValid(oCopy))){
        WriteTimestampedLogEntry("Baelnorn Projection hearbeat aborting due to an invalid object. Object status:" +
                                 "\nPC - " + (GetIsObjectValid(oPC) ? "valid":"invalid") +
                                 "\nCopy - " + (GetIsObjectValid(oCopy) ? "valid":"invalid"));
        return;
    }

    // Start the actual work by checking the copy's status. The death thing should take priority
    if(GetIsDead(oCopy))
    {
        EndPosses(oPC, oCopy);
        effect eKill = EffectDamage(GetCurrentHitPoints(oPC), DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_ENERGY);
        DelayCommand(3.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oPC));
    }
    // Transfer 1/2 damage taken by the "projection" to the "original"
    else
    {
        int nOldHP = GetLocalInt(oPC, "PRC_BealnornProjection_HB_HP");
        int nCurHP = GetCurrentHitPoints(oPC);
        int nDelta = nCurHP - nOldHP;

        // If the "projection" has taken damage since last HP, propagate
        if(nDelta < 0)
        {
            if(DEBUG) DoDebug("prc_bn_project: ProjectionMonitor(): The Projection has lost " + IntToString(nDelta) + "HP, propagating to copy");
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDelta / 2, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_ENERGY), oCopy);
        }

        SetLocalInt(oPC, "PRC_BealnornProjection_HB_HP", nCurHP);

        // Check if the "projection" has been destroyed or if some other event has caused the projection to end
        if(GetCurrentHitPoints(oPC) == 1                   ||
           GetLocalInt(oPC, "PRC_BaelnornProjection_Abort")
           )
        {
            if(DEBUG) DoDebug("prc_bn_project: ProjectionMonitor(): The Projection has been terminated, ending projection");
            EndPosses(oPC, oCopy);
        }
        else
            DelayCommand(PROJECTION_HB_DELAY, ProjectionMonitor(oPC, oCopy));
        
        //If duration expired, end effect
        if(GetLocalInt(oPC, "PROJECTION_EXPIRED"))
        {
		EndPosses(oPC, oCopy);
	}
    }
}


//Gives the PC -50 to attack and places No Damage iprop to all equipped weapons.
void NerfWeapons(object oPC)
{
    if(DEBUG) DoDebug("prc_bn_project: NerfWeapons():\n"
                    + "oPC = '" + GetName(oPC) + "'"
                      );
    effect eAB = EffectAttackDecrease(50);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAB, oPC);

    // Create array for storing a list of the nerfed weapons in
    array_create(oPC, "PRC_BaelnornProj_Nerfed");

    object oWeapon;
    itemproperty ipNoDam = ItemPropertyNoDamage();
    oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    if(IPGetIsMeleeWeapon(oWeapon)){
        if(!GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_NO_DAMAGE)){
            //SetLocalInt(oWeapon, "BaelnornProjection_NoDamage", TRUE);
            AddItemProperty(DURATION_TYPE_PERMANENT, ipNoDam, oWeapon);
            array_set_object(oPC, "PRC_BaelnornProj_Nerfed", array_get_size(oPC, "PRC_BaelnornProj_Nerfed"), oWeapon);
        }
        // Check left hand only if right hand had a weapon
        oWeapon = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
        if(IPGetIsMeleeWeapon(oWeapon)){
            if(!GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_NO_DAMAGE)){
                //SetLocalInt(oWeapon, "BaelnornProjection_NoDamage", TRUE);
                AddItemProperty(DURATION_TYPE_PERMANENT, ipNoDam, oWeapon);
                array_set_object(oPC, "PRC_BaelnornProj_Nerfed", array_get_size(oPC, "PRC_BaelnornProj_Nerfed"), oWeapon);
        }}
    }else if(IPGetIsRangedWeapon(oWeapon)){
        if(!GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_NO_DAMAGE)){
            //SetLocalInt(oWeapon, "BaelnornProjection_NoDamage", TRUE);
            AddItemProperty(DURATION_TYPE_PERMANENT, ipNoDam, oWeapon);
            array_set_object(oPC, "PRC_BaelnornProj_Nerfed", array_get_size(oPC, "PRC_BaelnornProj_Nerfed"), oWeapon);
    }}

    oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC);
    if(GetIsObjectValid(oWeapon)){
        if(!GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_NO_DAMAGE)){
            //SetLocalInt(oWeapon, "BaelnornProjection_NoDamage", TRUE);
            AddItemProperty(DURATION_TYPE_PERMANENT, ipNoDam, oWeapon);
            array_set_object(oPC, "PRC_BaelnornProj_Nerfed", array_get_size(oPC, "PRC_BaelnornProj_Nerfed"), oWeapon);
    }}
    oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC);
    if(GetIsObjectValid(oWeapon)){
        if(!GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_NO_DAMAGE)){
            //SetLocalInt(oWeapon, "BaelnornProjection_NoDamage", TRUE);
            AddItemProperty(DURATION_TYPE_PERMANENT, ipNoDam, oWeapon);
            array_set_object(oPC, "PRC_BaelnornProj_Nerfed", array_get_size(oPC, "PRC_BaelnornProj_Nerfed"), oWeapon);
    }}
    oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC);
    if(GetIsObjectValid(oWeapon)){
        if(!GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_NO_DAMAGE)){
            //SetLocalInt(oWeapon, "BaelnornProjection_NoDamage", TRUE);
            AddItemProperty(DURATION_TYPE_PERMANENT, ipNoDam, oWeapon);
            array_set_object(oPC, "PRC_BaelnornProj_Nerfed", array_get_size(oPC, "PRC_BaelnornProj_Nerfed"), oWeapon);
    }}
}



//Undoes changes made in NerfWeapons().
void UnNerfWeapons(object oPC)
{
    if(DEBUG) DoDebug("prc_bn_project: UnNerfWeapons():\n"
                    + "oPC = '" + GetName(oPC) + "'"
                      );
    effect eCheck = GetFirstEffect(oPC);
    while(GetIsEffectValid(eCheck)){
        if(GetEffectSpellId(eCheck) == SPELL_BAELNORN_PROJECTION &&
           GetEffectType(eCheck) == EFFECT_TYPE_ATTACK_DECREASE
          )
        {
            RemoveEffect(oPC, eCheck);
        }
        eCheck = GetNextEffect(oPC);
    }

    // Remove the no-damage property from all weapons it was added to
    int i;
    object oWeapon;
    for(i = 0; i < array_get_size(oPC, "PRC_BaelnornProj_Nerfed"); i++)
    {
        oWeapon = array_get_object(oPC, "PRC_BaelnornProj_Nerfed", i);
        IPRemoveMatchingItemProperties(oWeapon, ITEM_PROPERTY_NO_DAMAGE, DURATION_TYPE_PERMANENT);
    }

    array_delete(oPC, "PRC_BaelnornProj_Nerfed");
/*
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    if(GetLocalInt(oWeapon, "BaelnornProjection_NoDamage")){
        IPRemoveMatchingItemProperties(oWeapon, ITEM_PROPERTY_NO_DAMAGE, DURATION_TYPE_PERMANENT);
    }
    oWeapon = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
    if(GetLocalInt(oWeapon, "BaelnornProjection_NoDamage")){
        IPRemoveMatchingItemProperties(oWeapon, ITEM_PROPERTY_NO_DAMAGE, DURATION_TYPE_PERMANENT);
    }

    oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC);
    if(GetLocalInt(oWeapon, "BaelnornProjection_NoDamage")){
        IPRemoveMatchingItemProperties(oWeapon, ITEM_PROPERTY_NO_DAMAGE, DURATION_TYPE_PERMANENT);
    }
    oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC);
    if(GetLocalInt(oWeapon, "BaelnornProjection_NoDamage")){
        IPRemoveMatchingItemProperties(oWeapon, ITEM_PROPERTY_NO_DAMAGE, DURATION_TYPE_PERMANENT);
    }
    oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC);
    if(GetLocalInt(oWeapon, "BaelnornProjection_NoDamage")){
        IPRemoveMatchingItemProperties(oWeapon, ITEM_PROPERTY_NO_DAMAGE, DURATION_TYPE_PERMANENT);
    }

    // Remove no damage from unequipped weapons, too
    oWeapon = GetFirstItemInInventory(oPC);
    while(GetIsObjectValid(oWeapon)){
        if(GetLocalInt(oWeapon, "BaelnornProjection_NoDamage")){
            IPRemoveMatchingItemProperties(oWeapon, ITEM_PROPERTY_NO_DAMAGE, DURATION_TYPE_PERMANENT);
        }
        oWeapon = GetNextItemInInventory(oPC);
    }*/
}

void CleanCopy(object oImage)
{
    SetLootable(oImage, FALSE);
    // remove inventory contents
    object oItem = GetFirstItemInInventory(oImage);
    while(GetIsObjectValid(oItem))
    {
        SetPlotFlag(oItem,FALSE);
        if(GetHasInventory(oItem))
        {
            object oItem2 = GetFirstItemInInventory(oItem);
            while(GetIsObjectValid(oItem2))
            {
                object oItem3 = GetFirstItemInInventory(oItem2);
                while(GetIsObjectValid(oItem3))
                {
                    SetPlotFlag(oItem3,FALSE);
                    DestroyObject(oItem3);
                    oItem3 = GetNextItemInInventory(oItem2);
                }
                SetPlotFlag(oItem2,FALSE);
                DestroyObject(oItem2);
                oItem2 = GetNextItemInInventory(oItem);
            }
        }
        DestroyObject(oItem);
        oItem = GetNextItemInInventory(oImage);
    }
    // remove non-visible equipped items
    int i;
    for(i=0;i<NUM_INVENTORY_SLOTS;i++)//equipment
    {
        oItem = GetItemInSlot(i, oImage);
        if(GetIsObjectValid(oItem))
        {
            if(i == INVENTORY_SLOT_HEAD || i == INVENTORY_SLOT_CHEST ||
                i == INVENTORY_SLOT_RIGHTHAND || i == INVENTORY_SLOT_LEFTHAND ||
                i == INVENTORY_SLOT_CLOAK) // visible equipped items
            {
                SetDroppableFlag(oItem, FALSE);
                SetItemCursedFlag(oItem, TRUE);
                // remove all item properties
                itemproperty ipLoop=GetFirstItemProperty(oItem);
                while (GetIsItemPropertyValid(ipLoop))
                {
                    RemoveItemProperty(oItem, ipLoop);
                    ipLoop=GetNextItemProperty(oItem);
                }
            }
            else // can't see it so destroy
            {                
                SetPlotFlag(oItem,FALSE);
                DestroyObject(oItem);
            }
        }
        
    }
    TakeGoldFromCreature(GetGold(oImage), oImage, TRUE);
}