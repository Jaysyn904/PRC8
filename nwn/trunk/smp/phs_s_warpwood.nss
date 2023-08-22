/*:://////////////////////////////////////////////
//:: Spell Name Warp Wood
//:: Spell FileName PHS_S_WarpWood
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Drd 2
    Components: V, S
    Casting Time: 1 standard action
    Range: Close (8M)
    Target: 1 Small wooden object/level, all within a 6.67M radius (20-ft.); see text
    Duration: Instantaneous
    Saving Throw: Will negates (object)
    Spell Resistance: Yes (object)

    You cause wood to bend and warp, permanently destroying its straightness,
    form, and strength. A warped door springs open. Warped wooden ranged weapons
    are useless. A warped wooden (or partly wooden) melee weapon causes a -4
    penalty on attack rolls.

    You may warp one Small or smaller object (Tiny Weapon) or its equivalent per
    caster level. A Medium object (Small Weapon) counts as two Small objects,
    a Large object (Medium Weapon) as four, a Huge object (Large Weapon) as eight.

    When cast at an enemy, it will attempt to warp the wood of those weapons
    held by enemies out of shape as above (Using the holders will save to
    negate). If cast at a allied creature it will unwarp wood (effectively
    warping it back to normal), straightening wood that has been warped by this
    spell. If cast at a door, it can warp it so it springs open, if the lock
    isn't too strong or warded against spells.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Can warp enemy weapons, unwarp allied weapons, or warp a single door.

    Pretty simple.

    Oh, and this is how we do the warping/unwarping (using item properties):
    - On Hit spell, which is essentially blank, called something like "Warped Weapon"
    - Appropriate penalties of -4 for a weapon, and "No combat damage" for
      ranged weapons.

    These are sufficient to be considered "Badly warped" and "unusable" and
    is more easily tracked and overlapped then other properties.

    Oh, only wooden weapons are affected *duh*

    Will not affect things with an exsisting On Hit property, unless it is
    tempoary!
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

#include "PHS_INC_ITEMPROP"

// TEmp place

const int IP_CONST_ONHIT_CASTSPELL_WARPED_WEAPON = 1;

// Gets if oItem is wooden and a weapon
int GetIsWooden(object oItem);
// Unwarps weapons of oTarget.
// * Uses the limits imposed, and returns the NEW value of the total
int UnwarpWeaponsOnTarget(int nTotalSizes, object oTarget, int nCasterLevel);
// Get oWeapon's size.
// - 1 = Small,
// - A Medium object counts as two Small objects (2)
// - A Large object as four (4)
// - A Huge object as eight
// - A Gargantuan object as sixteen
// - A Colossal object as thirty-two.
int GetWeaponSize(object oWeapon);
// Gets if oWeapon is warped.
int GetIsWarped(object oWeapon);
// Remove warping properties of oWeapon
void UnwarpWeapon(object oWeapon);
// check if oWeapon can be warped
// * No permament On Hit propries already
int GetCanBeWarped(object oWeapon);
// Warps oWeapon. removes temp On Hit properies, then applies the new ones
void WarpWeapon(object oWeapon, itemproperty IP_Warp, itemproperty IP_NonRanged, itemproperty IP_Ranged);

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_WARP_WOOD)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    location lTarget = GetLocation(oTarget);
    int nCasterLevel = PHS_GetCasterLevel();// Limit of small (etc) items
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    object oWeapon;
    int nSize;

    // Count of affected items
    int nTotalSizes = 0;

    // Declare Effects
    effect eVisBad = EffectVisualEffect(PHS_VFX_IMP_WARP_WOOD_WARP);
    effect eVisGood = EffectVisualEffect(PHS_VFX_IMP_WARP_WOOD_UNWARP);

    // Apply AOE location explosion
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
    PHS_ApplyLocationVFX(lTarget, eImpact);

    // Item properties
    itemproperty IP_Warp = ItemPropertyOnHitCastSpell(0, 1);
    itemproperty IP_NonRanged = ItemPropertyAttackPenalty(4);
    itemproperty IP_Ranged = ItemPropertyNoDamage();

    // Check information about the target
    if(!GetIsObjectValid(oTarget)) return;

    // * Targeted a door
    if(GetObjectType(oTarget) == OBJECT_TYPE_DOOR)
    {
        // We warp the door, kinda like a Knock spell. Can't check if it is
        // wooden, which is a damn shame, and of course could add it.

        // VFX
        PHS_ApplyVFX(oTarget, eVisBad);

        // Signal spell cast at event.
        PHS_SignalSpellCastAt(oTarget, PHS_SPELL_WARP_WOOD);

        // If the target is locked, unlock it and open it
        // - No plot doors/placeables
        // - If it needs a key, and the key needed is "", IE cannot ever be opened, then
        //   ignore
        // - Ignore DC's of 100 or over
        int bLocked = GetLocked(oTarget);
        if(bLocked && !GetPlotFlag(oTarget) && GetLockLockDC(oTarget) < 100 &&
         (!GetLockKeyRequired(oTarget) || (GetLockKeyRequired(oTarget) && GetLockKeyTag(oTarget) != "")))
        {
            // Delay unlocking.
            SetLocked(oTarget, FALSE);
            bLocked = FALSE;
        }
        // Try and open it now
        if(bLocked == FALSE)
        {
            DelayCommand(0.2, AssignCommand(oTarget, ActionOpenDoor(oTarget)));
        }
    }
    else
    {
        // Must be a creature
        if(GetIsFriend(oTarget) || GetFactionEqual(oTarget))
        {
            // * Unwarp the wood of friendly creatures

            // Get all targets in a sphere, 20ft radius, all creatures
            oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_FEET_20, lTarget, TRUE, OBJECT_TYPE_CREATURE);
            // Loop targets
            while(GetIsObjectValid(oTarget) && nTotalSizes <= nCasterLevel)
            {
                // PvP Check
                if((GetIsFriend(oTarget) || GetFactionEqual(oTarget)) &&
                // Make sure they are not immune to spells
                   !PHS_TotalSpellImmunity(oTarget))
                {
                    // Fire cast spell at event for the specified target
                    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_WARP_WOOD, FALSE);

                    // Unwarp the weapons of the person they have equipped.
                    nTotalSizes = UnwarpWeaponsOnTarget(nTotalSizes, oTarget, nCasterLevel);
                }
                // Get Next Target
                oTarget = GetNextObjectInShape(SHAPE_SPHERE, 6.67, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
            }
        }
        else
        {
            // * Warp enemies wood. The target may be neutral, so we have oTarget
            //   become a specific target as well as all natural enemies.
            object oSpecific = oTarget;

            // Get all targets in a sphere, 20ft radius, all creatures
            oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_FEET_20, lTarget, TRUE, OBJECT_TYPE_CREATURE);
            // Loop targets
            while(GetIsObjectValid(oTarget) && nTotalSizes <= nCasterLevel)
            {
                // PvP Check
                if((GetIsEnemy(oTarget) || oTarget == oSpecific) &&
                // Make sure they are not immune to spells
                   !PHS_TotalSpellImmunity(oTarget))
                {
                    // Fire cast spell at event for the specified target
                    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_WARP_WOOD);

                    // Spell resistance
                    if(!PHS_SpellResistanceCheck(oCaster, oTarget))
                    {
                        // Warp thier weapons

                        // Righthand first
                        oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
                        nSize = GetWeaponSize(oTarget);

                        // Make a save for righthand if valid
                        if(GetIsWooden(oWeapon) && GetCanBeWarped(oWeapon) &&
                           nSize + nTotalSizes <= nCasterLevel)
                        {
                            // Add to nTotalSizes
                            nTotalSizes += nSize;

                            // Will save
                            if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC))
                            {
                                // Warp the wood for this item
                                WarpWeapon(oWeapon, IP_Warp, IP_NonRanged, IP_Ranged);
                            }
                        }

                        // Lefthand next
                        oWeapon = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
                        nSize = GetWeaponSize(oTarget);

                        // Make a save for righthand if valid
                        if(GetIsWooden(oWeapon) && GetCanBeWarped(oWeapon) &&
                           nSize + nTotalSizes <= nCasterLevel)
                        {
                            // Add to nTotalSizes
                            nTotalSizes += nSize;

                            // Will save
                            if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC))
                            {
                                // Warp the wood for this item
                                WarpWeapon(oWeapon, IP_Warp, IP_NonRanged, IP_Ranged);
                            }
                        }
                    }
                }
                // Get Next Target
                oTarget = GetNextObjectInShape(SHAPE_SPHERE, 6.67, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
            }
        }
    }
}
// Gets if oItem is wooden and a weapon
int GetIsWooden(object oItem)
{
    if(!GetIsObjectValid(oItem)) return FALSE;

    switch(GetBaseItemType(oItem))
    {
        case BASE_ITEM_ARROW:
        case BASE_ITEM_BATTLEAXE:// Wooden shaft/handle.
        case BASE_ITEM_BOLT:
        case BASE_ITEM_DOUBLEAXE:// Wooden shaft/handle.
        case BASE_ITEM_DWARVENWARAXE:// Wooden shaft/handle.
        case BASE_ITEM_GREATAXE:// Wooden shaft/handle.
        case BASE_ITEM_HALBERD:// Wooden shaft/handle.
        case BASE_ITEM_HANDAXE:// Wooden shaft/handle.
        case BASE_ITEM_HEAVYCROSSBOW:
        case BASE_ITEM_HEAVYFLAIL:// Wooden shaft/handle.
        case BASE_ITEM_KAMA:// Wooden shaft/handle.
        case BASE_ITEM_LIGHTCROSSBOW:
        case BASE_ITEM_LIGHTHAMMER:// Wooden shaft/handle.
        case BASE_ITEM_LONGBOW:
        case BASE_ITEM_MAGICSTAFF:// Wooden shaft/handle.
        case BASE_ITEM_MORNINGSTAR:// Wooden shaft/handle.
        case BASE_ITEM_QUARTERSTAFF:
        case BASE_ITEM_SCYTHE:// Wooden shaft/handle.
        case BASE_ITEM_SHORTBOW:
        case BASE_ITEM_SHORTSPEAR:
        case BASE_ITEM_TWOBLADEDSWORD:// Wooden shaft/handle.
        {
            return TRUE;
        }
        break;
    }
    return FALSE;
}

// Unwarps weapons of oTarget.
// * Uses the limits imposed, and returns the NEW value of the total
int UnwarpWeaponsOnTarget(int nTotalSizes, object oTarget, int nCasterLevel)
{
    int nAdd; // Weapon sizes of new weapons done
    int nSize;// size of weapon

    // Check righthand first
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
    // Is it wooden?
    if(GetIsWooden(oWeapon))
    {
        // Check the size
        nSize = GetWeaponSize(oWeapon);

        // Make sure it doesn't top the limit!
        if(nSize + nAdd + nTotalSizes <= nCasterLevel)
        {
            // Unwarp it!
            if(GetIsWarped(oWeapon))
            {
                // Add to nAdd
                nAdd += nSize;

                // Remove the specific properties
                UnwarpWeapon(oWeapon);
            }
        }
    }
    // Then check lefthand
    oWeapon = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
    // Is it wooden?
    if(GetIsWooden(oWeapon))
    {
        // Check the size
        nSize = GetWeaponSize(oWeapon);

        // Make sure it doesn't top the limit!
        if(nSize + nAdd + nTotalSizes <= nCasterLevel)
        {
            // Unwarp it!
            if(GetIsWarped(oWeapon))
            {
                // Add to nAdd
                nAdd += nSize;

                // Remove the specific properties
                UnwarpWeapon(oWeapon);
            }
        }
    }
    return nTotalSizes + nAdd;
}

// Get oWeapon's size.
// - 1 = Small, (Tiny weapons)
// - A Medium object counts as two Small objects (2) (Small weapons)
// - A Large object as four (4) (Medium weapons)
// - A Huge object as eight (8) (Large weapons)
// - A Gargantuan object as sixteen (16) (N/A)
// - A Colossal object as thirty-two. (32) (N/A)
int GetWeaponSize(object oWeapon)
{
    int nSize;

    switch(GetBaseItemType(oWeapon))
    {
        // Small (Tiny) weapons: 1
        case BASE_ITEM_DAGGER:
        case BASE_ITEM_KAMA:
        case BASE_ITEM_SHURIKEN:
        {
            nSize = 1;
        }
        // Medium (Small) weapons: 2
        case BASE_ITEM_THROWINGAXE:
        case BASE_ITEM_LIGHTCROSSBOW:
        case BASE_ITEM_DART:
        case BASE_ITEM_LIGHTHAMMER:
        case BASE_ITEM_HANDAXE:
        case BASE_ITEM_LIGHTMACE:
        case BASE_ITEM_SICKLE:
        case BASE_ITEM_SHORTSPEAR:
        case BASE_ITEM_SLING:
        case BASE_ITEM_SHORTSWORD:
        {
            nSize = 2;
        }
        // Large (Medium) weapons: 4
        case BASE_ITEM_BATTLEAXE:
        case BASE_ITEM_DWARVENWARAXE:
        case BASE_ITEM_CLUB:
        case BASE_ITEM_HEAVYCROSSBOW:
        case BASE_ITEM_LIGHTFLAIL:
        case BASE_ITEM_KATANA:
        case BASE_ITEM_LONGSWORD:
        case BASE_ITEM_MORNINGSTAR:
        case BASE_ITEM_QUARTERSTAFF:
        case BASE_ITEM_RAPIER:
        case BASE_ITEM_SCIMITAR:
        case BASE_ITEM_SHORTBOW:
        case BASE_ITEM_WARHAMMER:
        {
            nSize = 4;
        }
        // Huge (Large) weapons: 8
        case BASE_ITEM_BASTARDSWORD:
        case BASE_ITEM_DIREMACE:
        case BASE_ITEM_TWOBLADEDSWORD:
        case BASE_ITEM_DOUBLEAXE:
        case BASE_ITEM_HEAVYFLAIL:
        case BASE_ITEM_GREATAXE:
        case BASE_ITEM_GREATSWORD:
        case BASE_ITEM_HALBERD:
        case BASE_ITEM_LONGBOW:
        case BASE_ITEM_SCYTHE:
        {
            nSize = 8;
        }
    }
    return nSize;
}

// Gets if oWeapon is warped.
int GetIsWarped(object oWeapon)
{
    // Run through properties
    itemproperty ip = GetFirstItemProperty(oWeapon);
    while(GetIsItemPropertyValid(ip))
    {
        // Check if the type is ITEM_PROPERTY_ON_HIT_PROPERTIES
        if(GetItemPropertyType(ip) == ITEM_PROPERTY_ON_HIT_PROPERTIES)
        {
            // Make sure it is the warping wood one.
            if(GetItemPropertySubType(ip) == IP_CONST_ONHIT_CASTSPELL_WARPED_WEAPON)
            {
                return TRUE;
            }
        }
        ip = GetNextItemProperty(oWeapon);
    }
    // Not warped otherwise
    return FALSE;
}
// Remove warping properties of oWeapon
void UnwarpWeapon(object oWeapon)
{
    // Run through properties
    int bFixedWarped = FALSE;
    int bFixedDam = FALSE;
    int bRanged = GetWeaponRanged(oWeapon);
    int nType;
    itemproperty ip = GetFirstItemProperty(oWeapon);
    while(GetIsItemPropertyValid(ip) && bFixedWarped == FALSE && bFixedDam == FALSE)
    {
        nType = GetItemPropertyType(ip);
        // Check if the type is ITEM_PROPERTY_ON_HIT_PROPERTIES
        if(nType == ITEM_PROPERTY_ON_HIT_PROPERTIES)
        {
            if(bFixedWarped == FALSE)
            {
                // Make sure it is the warping wood one.
                if(GetItemPropertySubType(ip) == IP_CONST_ONHIT_CASTSPELL_WARPED_WEAPON)
                {
                    // Remove it
                    RemoveItemProperty(oWeapon, ip);
                    bFixedWarped = TRUE;
                }
            }
        }
        else if(bFixedDam == FALSE)
        {
            if(nType == ITEM_PROPERTY_NO_DAMAGE)
            {
                // Remove one No Damage one.
                if(bRanged == TRUE)
                {
                    // Remove it
                    RemoveItemProperty(oWeapon, ip);
                    bFixedDam = TRUE;
                }
            }
            else if(nType == ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER)
            {
                // Remove one No Damage one.
                if(bRanged == FALSE)
                {
                    // Remove it
                    RemoveItemProperty(oWeapon, ip);
                    bFixedDam = TRUE;
                }
            }
        }
        ip = GetNextItemProperty(oWeapon);
    }
}

// check if oWeapon can be warped
// * No permament On Hit propries already
int GetCanBeWarped(object oWeapon)
{
    // Run through properties
    itemproperty ip = GetFirstItemProperty(oWeapon);
    while(GetIsItemPropertyValid(ip))
    {
        // Check if the type is ITEM_PROPERTY_ON_HIT_PROPERTIES
        if(GetItemPropertyType(ip) == ITEM_PROPERTY_ON_HIT_PROPERTIES)
        {
            // Must be permament
            if(GetItemPropertyDurationType(ip) == DURATION_TYPE_PERMANENT)
            {
                return TRUE;
            }
        }
        ip = GetNextItemProperty(oWeapon);
    }
    return FALSE;
}

// Warps oWeapon. removes temp On Hit properies, then applies the new ones
void WarpWeapon(object oWeapon, itemproperty IP_Warp, itemproperty IP_NonRanged, itemproperty IP_Ranged)
{
    // Remove temp On Hit properites
    itemproperty ip = GetFirstItemProperty(oWeapon);
    while(GetIsItemPropertyValid(ip))
    {
        // Check if the type is ITEM_PROPERTY_ON_HIT_PROPERTIES
        if(GetItemPropertyType(ip) == ITEM_PROPERTY_ON_HIT_PROPERTIES)
        {
            // Must be not
            if(GetItemPropertyDurationType(ip) != DURATION_TYPE_PERMANENT)
            {
                // Remove temp ones.
                RemoveItemProperty(oWeapon, ip);
            }
        }
        ip = GetNextItemProperty(oWeapon);
    }

    // Now apply new ones
    AddItemProperty(DURATION_TYPE_PERMANENT, IP_Warp, oWeapon);
    // Ranged?
    if(GetWeaponRanged(oWeapon))
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, IP_Ranged, oWeapon);
    }
    else
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, IP_NonRanged, oWeapon);
    }
}

