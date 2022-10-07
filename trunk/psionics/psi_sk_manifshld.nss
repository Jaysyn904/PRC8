//::///////////////////////////////////////////////
//:: Soulknife: Manifest Shield of Thought
//:: psi_sk_manifshld
//::///////////////////////////////////////////////
/** 
    Handles the manifesting of a Kalashtar Soulknife's
    Shield of Thought.

*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "psi_inc_soulkn"

int LOCAL_DEBUG = DEBUG;

//////////////////////////////////////////////////
/* Function prototypes                          */
//////////////////////////////////////////////////

// Handles adding in the enhancement bonuses and specials
// ======================================================
// oShield    mindblade item
void BuildMindShield(object oPC, object oShield);


void main()
{
    if(LOCAL_DEBUG) DoDebug("Starting psi_sk_manifshld");
    object oPC = OBJECT_SELF;
    object oShield;
    int nMbldType = GetPersistantLocalInt(oPC, MBLADE_SHAPE);
    int nHand = INVENTORY_SLOT_LEFTHAND;

    // Check the item based on type selection
    switch(nMbldType)
    {
        case MBLADE_SHAPE_DUAL_SHORTSWORDS:
            //if dual-wielding, no shield
            return;
            break;
        case MBLADE_SHAPE_BASTARDSWORD:
            //bastard sword is 2-hander if you lack proficiency
            if(!GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC) && !GetHasFeat(FEAT_WEAPON_PROFICIENCY_BASTARD_SWORD)) return;
            break;

    }
    
    oShield = CreateItemOnObject("psi_sk_tshield_0", oPC);

    // Construct the bonuses
    /*DelayCommand(0.25f, */BuildMindShield(oPC, oShield)/*)*/;

    // Force equip
    AssignCommand(oPC, ActionEquipItem(oShield, nHand));

    // Make even more sure the mindshield cannot be dropped
    SetDroppableFlag(oShield, FALSE);
    SetItemCursedFlag(oShield, TRUE);

    if(LOCAL_DEBUG) DelayCommand(0.01f, DoDebug("Finished psi_sk_manifshld")); // Wrap in delaycommand so that the game clock gets to update for the purposes of WriteTimestampedLogEntry
}


void BuildMindShield(object oPC, object oShield)
{
    /* Add normal stuff and VFX */
    
    /* Apply the enhancements */
    int nFlags = GetPersistantLocalInt(oPC, MBLADE_FLAGS);
    int bLight = FALSE;

    if(nFlags & MBLADE_FLAG_SHIELD_1)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(1), oShield);
    }
    if(nFlags & MBLADE_FLAG_SHIELD_2)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(2), oShield);
    }
    if(nFlags & MBLADE_FLAG_SHIELD_3)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(3), oShield);
    }
    if(nFlags & MBLADE_FLAG_SHIELD_4)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(4), oShield);
    }
    if(nFlags & MBLADE_FLAG_SHIELD_5)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(5), oShield);
    }
    if(nFlags & MBLADE_FLAG_SHIELD_6)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(6), oShield);
    }
    if(nFlags & MBLADE_FLAG_SHIELD_7)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(7), oShield);
    }
    if(nFlags & MBLADE_FLAG_SHIELD_8)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(8), oShield);
    }
    if(nFlags & MBLADE_FLAG_SHIELD_9)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(9), oShield);
    }
    if(nFlags & MBLADE_FLAG_SHIELD_10)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(10), oShield);
    }
    
    
    /// Add in VFX
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyVisualEffect(GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD ? ITEM_VISUAL_HOLY :
                                                                       GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL ? ITEM_VISUAL_EVIL :
                                                                        ITEM_VISUAL_SONIC
                                                                      ), oShield);

}