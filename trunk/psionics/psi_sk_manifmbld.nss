//::///////////////////////////////////////////////
//:: Soulknife: Manifest Mindblade
//:: psi_sk_manifmbld
//::///////////////////////////////////////////////
/** @file Soulknife: Manifest Mindblade
    Handles creation of mindblades.


    @author Ornedan
    @date   Created  - 07.04.2005
    @date   Modified - 01.09.2005
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_combat"
#include "psi_inc_soulkn"

int LOCAL_DEBUG = DEBUG;

//////////////////////////////////////////////////
/* Function prototypes                          */
//////////////////////////////////////////////////

// Handles adding in the enhancement bonuses and specials
// ======================================================
// oMbld    mindblade item
void BuildMindblade(object oPC, object oMbld, int nMbldType);


void main()
{
    if(LOCAL_DEBUG) DoDebug("Starting psi_sk_manifmbld");
    object oPC = OBJECT_SELF;
    object oMbld;
    int nMbldType = GetPersistantLocalInt(oPC, MBLADE_SHAPE);
    int nHand = GetPersistantLocalInt(oPC, MBLADE_HAND);

    // If this is the very first time a PC is manifesting a mindblade, initialise the hand to be main hand
    if(!nHand)
    {
        nHand = INVENTORY_SLOT_RIGHTHAND;
        SetPersistantLocalInt(oPC, MBLADE_HAND, INVENTORY_SLOT_RIGHTHAND);
    }

    // Generate the item based on type selection
    switch(nMbldType)
    {
        case MBLADE_SHAPE_DUAL_SHORTSWORDS:
            //SendMessageToPC(oPC, "psi_sk_manifmbld: First of dual shortswords - ");
            // The first of dual mindblades always goes to mainhand
            nHand = INVENTORY_SLOT_RIGHTHAND;
        case MBLADE_SHAPE_SHORTSWORD:
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created shortsword");
            oMbld = CreateItemOnObject("prc_sk_mblade_ss", oPC);
            break;
        case MBLADE_SHAPE_LONGSWORD:
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created longsword");
            oMbld = CreateItemOnObject("prc_sk_mblade_ls", oPC);
            break;
        case MBLADE_SHAPE_BASTARDSWORD:
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created bastardsword");
            oMbld = CreateItemOnObject("prc_sk_mblade_bs", oPC);
            break;
        case MBLADE_SHAPE_RANGED:
            //SendMessageToPC(oPC, "psi_sk_manifmbld: Created throwing mindblade");
            // Create one more mindblade than needed in order to bypass the BW bug of the last thrown weapon in a stack no longer being a valid object in the OnHitCast script
            oMbld = CreateItemOnObject("prc_sk_mblade_th", oPC, (GetHasFeat(FEAT_MULTIPLE_THROW, oPC) ? GetMainHandAttacks(oPC) : 1) + 1);
            break;

        default:
            WriteTimestampedLogEntry("Invalid value in MBLADE_SHAPE for " + GetName(oPC) + ": " + IntToString(nMbldType));
            return;
    }

    // Construct the bonuses
    /*DelayCommand(0.25f, */BuildMindblade(oPC, oMbld, nMbldType)/*)*/;

    // check for existing one before equipping and destroy
    if(GetStringLeft(GetTag(GetItemInSlot(nHand, oPC)), 14) == "prc_sk_mblade_")
            MyDestroyObject(GetItemInSlot(nHand, oPC));
    // Force equip
    AssignCommand(oPC, ActionEquipItem(oMbld, nHand));

    // Hook the mindblade into OnHit event
    AddEventScript(oMbld, EVENT_ITEM_ONHIT, "psi_sk_onhit", TRUE, FALSE);

    // Make even more sure the mindblade cannot be dropped
    SetDroppableFlag(oMbld, FALSE);
    SetItemCursedFlag(oMbld, TRUE);

    // Generate the second mindblade if set to dual shortswords
    if(nMbldType == MBLADE_SHAPE_DUAL_SHORTSWORDS)
    {
        oMbld = CreateItemOnObject("prc_sk_mblade_ss", oPC);

        //SendMessageToPC(oPC, "psi_sk_manifmbld: Created second mindblade - is valid: " + (GetIsObjectValid(oMbld) ? "TRUE":"FALSE"));

        DelayCommand(0.5f, BuildMindblade(oPC, oMbld, nMbldType)); // Delay a bit to prevent a lag spike
        //BuildMindblade(oPC, oMbld, nMbldType);
        AssignCommand(oPC, ActionDoCommand(ActionEquipItem(oMbld, INVENTORY_SLOT_LEFTHAND)));
        //AssignCommand(oPC, ActionEquipItem(oMbld, INVENTORY_SLOT_LEFTHAND));
        AddEventScript(oMbld, EVENT_ITEM_ONHIT, "psi_sk_onhit", TRUE, FALSE);

        SetDroppableFlag(oMbld, FALSE);
        SetItemCursedFlag(oMbld, TRUE);
    }
    // Not dual-wielding, so delete the second mindblade if they have such
    else
    {
        // Get the other hand
        int nOtherHand;
        if(nHand == INVENTORY_SLOT_RIGHTHAND)
            nOtherHand = INVENTORY_SLOT_LEFTHAND;
        else
            nOtherHand = INVENTORY_SLOT_RIGHTHAND;
        // Check it's contents and take action if necessary
        if(GetStringLeft(GetTag(GetItemInSlot(nOtherHand, oPC)), 14) == "prc_sk_mblade_")
            MyDestroyObject(GetItemInSlot(nOtherHand, oPC));
    }

/* Now in their own script - psi_sk_clseval
    // Hook psi_sk_event to the mindblade-related events it handles
    AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "psi_sk_event", TRUE, FALSE);
    AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "psi_sk_event", TRUE, FALSE);
    AddEventScript(oPC, EVENT_ONUNAQUIREITEM,      "psi_sk_event", TRUE, FALSE);
    AddEventScript(oPC, EVENT_ONPLAYERDEATH,       "psi_sk_event", TRUE, FALSE);
    AddEventScript(oPC, EVENT_ONPLAYERLEVELDOWN,   "psi_sk_event", TRUE, FALSE);
*/
    if(LOCAL_DEBUG) DelayCommand(0.01f, DoDebug("Finished psi_sk_manifmbld")); // Wrap in delaycommand so that the game clock gets to update for the purposes of WriteTimestampedLogEntry
}


void BuildMindblade(object oPC, object oMbld, int nMbldType)
{
    /* Add normal stuff and VFX */
    /// Add enhancement bonus
    int nSKLevel = GetLevelByClass(CLASS_TYPE_SOULKNIFE, oPC);
    int nEnh;
    // The first actual enhancement bonus is gained at L4, but the mindblade needs to
    // have enhancement right from the beginning to pierce DR as per being magical
    if(nSKLevel < 4)
    {
        nEnh = 1;
        // The mindblade being magical should grant no benefits to attack or damage
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAttackPenalty(1), oMbld);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamagePenalty(1), oMbld);
    }
    else
    {
        nEnh = nSKLevel <= 20 ?
                nSKLevel / 4:            // Boni are granget +1 / 4 levels pre-epic
                (nSKLevel - 20) / 5 + 5; // Boni are granted +1 / 5 levels epic
        // Dual mindblades have one lower bonus
        nEnh -= nMbldType == MBLADE_SHAPE_DUAL_SHORTSWORDS ? 1 : 0;
    }
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonus(nEnh), oMbld);
    // In case of bastard sword, store the enhancement bonus for later for use in the 2-h handling code
    if(nMbldType == MBLADE_SHAPE_BASTARDSWORD)
        SetLocalInt(oMbld, "PRC_SK_BSwd_EnhBonus", nEnh);

    // Handle Greater Weapon Focus (mindblade) here. It grants +1 to attack with any shape of mindblade.
    // Because of stacking issues, the actual value granted is enhancement bonus + 1.
    if(GetHasFeat(FEAT_GREATER_WEAPON_FOCUS_MINDBLADE, oPC))
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAttackBonus(nEnh + 1), oMbld);

    /// Add in VFX
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyVisualEffect(GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD ? ITEM_VISUAL_HOLY :
                                                                       GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL ? ITEM_VISUAL_EVIL :
                                                                        ITEM_VISUAL_SONIC
                                                                      ), oMbld);

    /* Add in common feats */
    //string sTag = GetTag(oMbld);
    // For the purposes of the rest of this function, dual shortswords is the same as single shortsword
    if(nMbldType == MBLADE_SHAPE_DUAL_SHORTSWORDS) nMbldType = MBLADE_SHAPE_SHORTSWORD;

    // Weapon Focus
    /* Every soulknife has this, so it's automatically on the weapons now. Uncomment if for some reason another class with the mindblade class feature is added
    if(GetHasFeat(FEAT_WEAPON_FOCUS_MINDBLADE, oPC))
        AddItemProperty(DURATION_TYPE_PERMANENT, PRCItemPropertyBonusFeat(nMbldType == MBLADE_SHAPE_SHORTSWORD   ? IP_CONST_FEAT_WEAPON_FOCUS_SHORT_SWORD :
                                                                       nMbldType == MBLADE_SHAPE_LONGSWORD    ? IP_CONST_FEAT_WEAPON_FOCUS_LONG_SWORD :
                                                                       nMbldType == MBLADE_SHAPE_BASTARDSWORD ? IP_CONST_FEAT_WEAPON_FOCUS_BASTARD_SWORD :
                                                                                                                IP_CONST_FEAT_WEAPON_FOCUS_THROWING_AXE
                                                                      ), oMbld);*/
    // Improved Critical
    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_MINDBLADE, oPC))
        AddItemProperty(DURATION_TYPE_PERMANENT, PRCItemPropertyBonusFeat(nMbldType == MBLADE_SHAPE_SHORTSWORD   ? IP_CONST_FEAT_IMPROVED_CRITICAL_SHORT_SWORD :
                                                                       nMbldType == MBLADE_SHAPE_LONGSWORD    ? IP_CONST_FEAT_IMPROVED_CRITICAL_LONG_SWORD :
                                                                       nMbldType == MBLADE_SHAPE_BASTARDSWORD ? IP_CONST_FEAT_IMPROVED_CRITICAL_BASTARD_SWORD :
                                                                                                                IP_CONST_FEAT_IMPROVED_CRITICAL_THROWING_AXE
                                                                      ), oMbld);
    // Overwhelming Critical
    if(GetHasFeat(FEAT_OVERWHELMING_CRITICAL_MINDBLADE, oPC))
        AddItemProperty(DURATION_TYPE_PERMANENT, PRCItemPropertyBonusFeat(nMbldType == MBLADE_SHAPE_SHORTSWORD   ? IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_SHORTSWORD :
                                                                       nMbldType == MBLADE_SHAPE_LONGSWORD    ? IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_LONGSWORD :
                                                                       nMbldType == MBLADE_SHAPE_BASTARDSWORD ? IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_BASTARDSWORD :
                                                                                                                IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_THROWINGAXE
                                                                      ), oMbld);
    // Devastating Critical
    if(GetHasFeat(FEAT_DEVASTATING_CRITICAL_MINDBLADE, oPC))
        AddItemProperty(DURATION_TYPE_PERMANENT, PRCItemPropertyBonusFeat(nMbldType == MBLADE_SHAPE_SHORTSWORD   ? IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_SHORTSWORD :
                                                                       nMbldType == MBLADE_SHAPE_LONGSWORD    ? IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_LONGSWORD :
                                                                       nMbldType == MBLADE_SHAPE_BASTARDSWORD ? IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_BASTARDSWORD :
                                                                                                                IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_THROWINGAXE
                                                                      ), oMbld);
    // Weapon Specialization
    if(GetHasFeat(FEAT_WEAPON_SPECIALIZATION_MINDBLADE, oPC))
        AddItemProperty(DURATION_TYPE_PERMANENT, PRCItemPropertyBonusFeat(nMbldType == MBLADE_SHAPE_SHORTSWORD   ? IP_CONST_FEAT_WEAPON_SPECIALIZATION_SHORT_SWORD :
                                                                       nMbldType == MBLADE_SHAPE_LONGSWORD    ? IP_CONST_FEAT_WEAPON_SPECIALIZATION_LONG_SWORD :
                                                                       nMbldType == MBLADE_SHAPE_BASTARDSWORD ? IP_CONST_FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD :
                                                                                                                IP_CONST_FEAT_WEAPON_SPECIALIZATION_THROWING_AXE
                                                                      ), oMbld);
    // Epic Weapon Focus
    if(GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_MINDBLADE, oPC))
        AddItemProperty(DURATION_TYPE_PERMANENT, PRCItemPropertyBonusFeat(nMbldType == MBLADE_SHAPE_SHORTSWORD   ? IP_CONST_FEAT_EPIC_WEAPON_FOCUS_SHORT_SWORD :
                                                                       nMbldType == MBLADE_SHAPE_LONGSWORD    ? IP_CONST_FEAT_EPIC_WEAPON_FOCUS_LONG_SWORD :
                                                                       nMbldType == MBLADE_SHAPE_BASTARDSWORD ? IP_CONST_FEAT_EPIC_WEAPON_FOCUS_BASTARD_SWORD :
                                                                                                                IP_CONST_FEAT_EPIC_WEAPON_FOCUS_THROWING_AXE
                                                                      ), oMbld);
    // Epic Weapon Specialization
    if(GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_MINDBLADE, oPC))
        AddItemProperty(DURATION_TYPE_PERMANENT, PRCItemPropertyBonusFeat(nMbldType == MBLADE_SHAPE_SHORTSWORD   ? IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_SHORT_SWORD :
                                                                       nMbldType == MBLADE_SHAPE_LONGSWORD    ? IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_LONG_SWORD :
                                                                       nMbldType == MBLADE_SHAPE_BASTARDSWORD ? IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_BASTARD_SWORD :
                                                                                                                IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_THROWING_AXE
                                                                      ), oMbld);
    // Weapon of Choice
    if(GetHasFeat(FEAT_WEAPON_OF_CHOICE_MINDBLADE, oPC) && nMbldType != MBLADE_SHAPE_RANGED)
        AddItemProperty(DURATION_TYPE_PERMANENT, PRCItemPropertyBonusFeat(nMbldType == MBLADE_SHAPE_SHORTSWORD   ? IP_CONST_FEAT_WEAPON_OF_CHOICE_SHORTSWORD :
                                                                       nMbldType == MBLADE_SHAPE_LONGSWORD    ? IP_CONST_FEAT_WEAPON_OF_CHOICE_LONGSWORD :
                                                                       nMbldType == MBLADE_SHAPE_BASTARDSWORD ? IP_CONST_FEAT_WEAPON_OF_CHOICE_BASTARDSWORD :
                                                                                                                -1 // This shouldn't ever be reached
                                                                      ), oMbld);
    // Bladewind: Due to some moron @ BioWare, calls to DoWhirlwindAttack() do not do anything if one
    // does not have the feat. Therefore, we need to grant it as a bonus feat on the blade.
    if(GetHasFeat(FEAT_BLADEWIND, oPC))
        AddItemProperty(DURATION_TYPE_PERMANENT, PRCItemPropertyBonusFeat(IP_CONST_FEAT_WHIRLWIND), oMbld);


    /* Apply the enhancements */
    int nFlags = GetPersistantLocalInt(oPC, MBLADE_FLAGS);
    int bLight = FALSE;

    if(nFlags & MBLADE_FLAG_LUCKY)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyCastSpell(IP_CONST_CASTSPELL_MINDBLADE_LUCKY, IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY), oMbld);
    }
    if(nFlags & MBLADE_FLAG_DEFENDING)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(2), oMbld);
    }
    if(nFlags & MBLADE_FLAG_KEEN)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyKeen(), oMbld);
    }
    /*if(nFlags & MBLADE_FLAG_VICIOUS)
    { OnHit
    }*/
    if(nFlags & MBLADE_FLAG_PSYCHOKINETIC && !(nFlags & MBLADE_FLAG_PSYCHOKINETICBURST)) // Only Psychokinetic
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_1d4), oMbld);
        bLight = TRUE;
    }
    if(nFlags & MBLADE_FLAG_MIGHTYCLEAVING)
    {
        if(GetHasFeat(FEAT_CLEAVE, oPC))
            AddItemProperty(DURATION_TYPE_PERMANENT, PRCItemPropertyBonusFeat(IP_CONST_FEAT_GREAT_CLEAVE), oMbld);
        else
            AddItemProperty(DURATION_TYPE_PERMANENT, PRCItemPropertyBonusFeat(IP_CONST_FEAT_CLEAVE), oMbld);
    }
    if(nFlags & MBLADE_FLAG_COLLISION)
    {
        if(LOCAL_DEBUG) DoDebug("Added Collision damage", oPC);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_5), oMbld);
    }
    /*if(nFlags & MBLADE_FLAG_MINDCRUSHER )
    { OnHit
    }*/
    if(nFlags & MBLADE_FLAG_PSYCHOKINETICBURST && !(nFlags & MBLADE_FLAG_PSYCHOKINETIC)) // Only Psychokinetic Burst
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_1d4), oMbld);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_1d6), oMbld);
        bLight = TRUE;
    }
    /*if(nFlags & MBLADE_FLAG_SUPPRESSION)
    { OnHit
    }*/
    /*if(nFlags & MBLADE_FLAG_WOUNDING)
    { OnHit
    }*/
    /*if(nFlags & MBLADE_FLAG_DISRUPTING)
    { OnHit
    }
    if(nFlags & MBLADE_FLAG_SOULBREAKER)
    {
    }*/
    if((nFlags & MBLADE_FLAG_PSYCHOKINETICBURST) && (nFlags & MBLADE_FLAG_PSYCHOKINETIC)) // Both Psychokinetic and Psychokinetic Burst
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_2d4), oMbld);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_1d6), oMbld);
        bLight = TRUE;
    }

    if(bLight)
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_NORMAL, IP_CONST_LIGHTCOLOR_WHITE), oMbld);
}