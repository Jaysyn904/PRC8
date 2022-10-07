/*:://////////////////////////////////////////////
//:: Name Crafting Potions/Scrolls/Wands include
//:: FileName SMP_INC_CRAFT
//:://////////////////////////////////////////////
    This contains all the functions used to craft (or brew/scribe) potions, scrolls
    and wands.

    Acts exactly like Bioware's implimentation for the most part, apart from
    calculations (3.5E rules used).

    If cast upon a blank scroll, bone wand, or empty bottle, it will attempt
    the appropriate thing. This is inbuilt into the internal spell hook.

    Brew potion:
    * Potions are usable by anyone
    * 3rd level or lower only
    * Only cirtain spells can be put into potions (IE: No magic missile potions!)
        * Need to have a "Target: Personal" option when cast.
    * Most useful for curing spells, defensive spells without a material component
      and those which the caster wants others to use by themselves (anyone can
      use a potion)

    Scribe Scroll:
    * Scrolls are usable if you have them on your class list
    * Scrolls are easy to carry, and can have any level spell cast on them
        * Main limit is major gold costs for many scrolls, or if they can cast
          the spell to start with.
        * Can create lower-caster-level scrolls cheaper, for spells that don't
          need a good caster level (EG: detect magic)
    * Scrolls can only be used by those who have it on thier class list
    * Most Useful for backup/utility spells or ones rarely cast, but still useful.
      Not very viable to use as a replacement for casting those spells.

    Craft Wand:
    * Wands are usable if you have them on your class list
    * 4th level or lower only
    * All spells can be put into a wand
        * Main limit is what the person can cast
    * Note: It is powerful, and pretty cheap, for spells without material components.
        * IE: It is 15 gold per charge, compared to 25 for a scroll.
        * It isn't worth it if the wand never gets used
        * It is a lot of gold and experience at once.
    * Scrolls are more variable in level, this is a lot of scrolls in one.
    * Most Useful for offensive/defensive spells without material components,
      and which are used quite often (Mage Armor, Magic Missile, Acid Arrow...)
      or curing spells (Very useful for after battles)


    Pricing:
           Name   Label           Cost     PotionCost   WandCost
0          ****   Random          0        0            0
1          1755   Single_Use      0.1334   1            1
2          1743   5_Charges/Use   0.45     0            1
3          1744   4_Charges/Use   0.55     0            1
4          1745   3_Charges/Use   0.65     0            1
5          1746   2_Charges/Use   0.75     0            1
6          1747   1_Charge/Use    1        0            1
7          1748   0_Charges/Use   3        0            0
8          1749   1_Use/Day       0.6      0            0
9          1750   2_Uses/Day      0.9      0            0
10         1751   3_Uses/Day      1.15     0            0
11         1752   4_Uses/Day      1.3      0            0
12         1753   5_Uses/Day      1.45     0            0
13         1754   Unlimited_Use   3        0            0

    Light wounds entry: 750 "Cost", InnateLvl 1, CasterLvl 2.
    Level 5 version is 1800.

    All Single Use (note wands: different).

    potion - 20  (level 5 - 48)          -- 0.02667 (This is 1/5th of 0.1334)
    scroll - 36  (level 5 - 86)          --
    wand   - 101 (level 5 - 241)         -- This is 0.1334 of 750GP.
        1 charge - 751 (level 5 - 1801)  -- This is 1x750GP.

    (This counts for other things - anything with charges!)

    Costs normally (level 2 caster, cure light wounds - level 1 spell)

    Potion: The base price of a potion is its spell level x its caster level x 50 gp.

    Meaning: 1 x 2 x 50 = 100. (This is 5x the price, or 80 more)

    Scroll: The base price of a scroll is its spell level x its caster level x 25 gp.

    Meaning: 1 x 2 x 25 = 50 (this is 14 more)

    Wand: The base price of a wand is its caster level x the spell level x 750 gp.

    Meaning: 1 x 2 x 750 = 1500 (this is double! it is 750 off)

/// HIGHER LEVEL SPELL: Cure Serious Wounds
        Caster Level 5, Spell Level 3, 2500

    Potion (1 Use): 66        -- 0.02667 Or so of the price (2500).
    Scroll (1 Use): 120       -- 0.048 of the price (2500)
    Wand (1 Charge/Use): 2500 -- 1 x of the price (2500). Keeps to the price.

    Should be:

    Potion (1 Use): 5 x 3 x 50 = 750         -- (0.0666 of major cost)
    Scroll (1 Use): 5 x 3 x 25 = 375         -- (0.0333 of major cost)
    Wand (1 Charge/Use): 5 x 3 x 750 = 11250 -- (Taken as major cost, 1)


    BASEITEMS.2DA hold the missing information.

    Oh, and wands are not independantly created - it'd cirtainly be too many!
    Anyway, wands are more unique...and should look like what they were before
    the spell was enchanted (As stated - a wand which has lost its charges
    is mearly a stick!)
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

// All potions can be used by anyone - they have levels from the lowest level
// they can be cast at, to level 40, the highest level a PC can obtain, and
// range from level 1 to 3 spells.
//
// * Resref format: SMP_p_000011
//   * 0000 = Spell Id Index.
//   * 11 = Level (01 to 40)
string SMP_CRAFT_RESREF_POTION_PREFIX = "SMP_p_";

// Scrolls, can be only cast normally if you have no UMD, if you have it on your
// class list (you need no other requirements - not even enough base stat!)
// AND it if of the correct type - divine or arcane.
/*
    To have any chance of activating a scroll spell, the scroll user must meet
    the following requirements.
    * The spell must be of the correct type (arcane or divine). Arcane
      spellcasters (wizards, sorcerers, and bards) can only use scrolls
      containing arcane spells, and divine spellcasters (clerics, druids,
      paladins, and rangers) can only use scrolls containing divine spells.
      (The type of scroll a character creates is also determined by his or
      her class.)
    * The user must have the spell on his or her class list.
    * The user must have the requisite ability score.
*/
// Therefore, these are slightly more limited, and have properties to stop them
// being used by the wrong classes.
// Can be of any level, mind you, so there are a LOT of scrolls.
// * Resref format: SMP_p_0111122
//   * 0 = 0 for Arcane, 1 for Divine.
//   * 1111 = Spell Id Index.
//   * 22 = Level (01 to 40)
string SMP_CRAFT_RESREF_SCROLL_PREFIX = "SMP_s_";

// Wands are limited to if you have it on your base spell list too. They are similar
// to scrolls in this respect, and have charges. However, only level 4 or lower
// spells can be put on wands.
// Note that wands have the spell added to the actual "stick" or whatever is
// used for the wand. No new item created (there will be special ones for
// the new spells in the custom lists, of course).



// SMP_INC_CRAFT. Checks if oItem is an item, a valid choice, with the appropraite feat.
// Then, puts the right magical effect onto the item.
// Note that:
// * The caster cannot be in combat.
// * Returns TRUE if anything should stop the continuation of the spell being
//   cast (either failure because of wrong item, or it was scribed well)
int SMP_CraftASpellOntoSomething(object oCaster, int nSpellId, int nSpellLevel, int nCasterClass, int nCasterLevel, object oItem);

// SMP_INC_CRAFT. Checks if nSpellId can be used on crafted onto an item.
// Can mark out cirtain spells as invalid this way, to never be crafted at all.
// * Returns TRUE if the spell is invalid.
int SMP_CraftCheckSpell(int nSpellId);

// SMP_INC_CRAFT. Attempts to let oCaster scribes the scroll for nSpellId.
// It will usually use a default of the lowest level you are able to cast the spell
// at, eg:
// * Bear’s Endurance is a level 2 spell for quite a few classes.
// * Paladins/Bards couldn't scribe a scroll from it of course
// * It would be a level 3 scroll for Clerics/Druids/Wizards...
// * ...a level 4 scroll for Sorcerors...
// * ...a level 10 scroll for rangers (!)
// But will take a maximum of nSpellLevel otherwise (1-40), or a user defined
// setting.
// * NOTE: Currently uses the LOWEST level! Might keep to this, or add in multiples
//   of 5 or something.
void SMP_CraftScribeScroll(object oCaster, int nSpellId, int nSpellLevel, int nCasterLevel, int nCasterClass, object oItem);


// SMP_INC_CRAFT. Attempts to let oCaster brews the potion for nSpellId.
// It will usually use a default of the lowest level you are able to cast the spell
// at, eg:
// * Bear’s Endurance is a level 2 spell for quite a few classes.
// * Paladins/Bards couldn't brew a potion from it of course
// * It would be a level 3 potion for Clerics/Druids/Wizards...
// * ...a level 4 potion for Sorcerors...
// * ...a level 10 potion for rangers (!)
// But will take a maximum of nSpellLevel otherwise (1-40), or a user defined
// setting.
// * NOTE: Currently uses the LOWEST level! Might keep to this, or add in multiples
//   of 5 or something.
void SMP_CraftBrewPotion(object oCaster, int nSpellId, int nSpellLevel, int nCasterLevel, int nCasterClass, object oItem);


// SMP_INC_CRAFT. Attempts to let oCaster adds the spell, nSpellId, to the wand, oItem.
// It will usually use a default of the lowest level you are able to cast the spell
// at, eg:
// * Bear’s Endurance is a level 2 spell for quite a few classes.
// * Paladins/Bards couldn't brew a potion from it of course
// * It would be a level 3 potion for Clerics/Druids/Wizards...
// * ...a level 4 potion for Sorcerors...
// * ...a level 10 potion for rangers (!)
// But will take a maximum of nSpellLevel otherwise (1-40), or a user defined
// setting.
// * NOTE: Currently uses the LOWEST level! Might keep to this, or add in multiples
//   of 5 or something.
void SMP_CraftCraftWand(object oCaster, int nSpellId, int nSpellLevel, int nCasterLevel, int nCasterClass, object oItem);

// SMP_INC_CRAFT. This will return TRUE if the caster has the requested XP, gold and
// components, focus' and extra XP needed to csat the spell nSpellId.
// * Note: nCharges applies to components and extra XP only (for wands), and
//   is usually 50 or 1.
// Returns of FALSE remove nothing. Debugs are generic.
int SMP_CraftRemoveGoldXPFocus(object oCaster, int nSpellId, int nCasterLevel, int nSpellLevel, int nMultiplier, int nCharges = 1);

// SMP_INC_CRAFT. Simply gets the lenght of the ID, and adds a number of zeroes, if any,
// to get it up to nCharacters length.
string SMP_CraftStringNumberId(int nNumber, int nCharacters);

// SMP_INC_CRAFT. Checks if oItem is an item, a valid choice, with the appropraite feat.
// Then, puts the right magical effect onto the item.
// Note that:
// * The caster cannot be in combat.
// * Returns TRUE if anything should stop the continuation of the spell being
//   cast (either failure because of wrong item, or it was scribed well)
int SMP_CraftASpellOntoSomething(object oCaster, int nSpellId, int nSpellLevel, int nCasterClass, int nCasterLevel, object oItem)
{
    // Must be an item
    if(GetObjectType(oItem) != OBJECT_TYPE_ITEM)
    {
        return FALSE;
    }
    // Cannot have used another item to cast this spell
    if(nCasterClass == CLASS_TYPE_INVALID ||
       GetIsObjectValid(GetSpellCastItem()) ||
       nCasterLevel == 0)
    {
        return FALSE;
    }
    // Limit nCasterLevel to 40 maximum
    if(nCasterLevel > 40)
    {
        nCasterLevel = 40;
    }

    // Fire the appropriate function to do the appropriate feat.
    switch(GetBaseItemType(oItem))
    {
        // Spell scroll?
        case BASE_ITEM_BLANK_SCROLL:
        {
            SMP_CraftScribeScroll(oCaster, nSpellId, nSpellLevel, nCasterLevel, nCasterClass, oItem);
            return TRUE;
        }
        break;
        // Wand?
        case BASE_ITEM_BLANK_WAND:
        {
            SMP_CraftCraftWand(oCaster, nSpellId, nSpellLevel, nCasterLevel, nCasterClass, oItem);
            return TRUE;
        }
        break;
        // Potion?
        case BASE_ITEM_BLANK_POTION:
        {
            SMP_CraftBrewPotion(oCaster, nSpellId, nSpellLevel, nCasterLevel, nCasterClass, oItem);
            return TRUE;
        }
        break;
    }
    // No item type valid (can be a normal spell, of course)
    return FALSE;
}

// SMP_INC_CRAFT. Checks if nSpellId can be used on crafted onto an item.
// Can mark out cirtain spells as invalid this way, to never be crafted at all.
// * Returns TRUE if the spell is invalid.
int SMP_CraftCheckSpell(int nSpellId)
{
    switch(nSpellId)
    {
        // Invalid spells listed here. May change with 2da lookup sometime.
        case SMP_SPELL_TIME_STOP:
        {
            return TRUE;
        }
    }
    return FALSE;
}

// SMP_INC_CRAFT. Attempts to let oCaster scribes the scroll for nSpellId.
// It will usually use a default of the lowest level you are able to cast the spell
// at, eg:
// * Bear’s Endurance is a level 2 spell for quite a few classes.
// * Paladins/Bards couldn't scribe a scroll from it of course
// * It would be a level 3 scroll for Clerics/Druids/Wizards...
// * ...a level 4 scroll for Sorcerors...
// * ...a level 10 scroll for rangers (!)
// But will take a maximum of nSpellLevel otherwise (1-40), or a user defined
// setting.
// * NOTE: Currently uses the LOWEST level! Might keep to this, or add in multiples
//   of 5 or something.
void SMP_CraftScribeScroll(object oCaster, int nSpellId, int nSpellLevel, int nCasterLevel, int nCasterClass, object oItem)
{
    // Feat check
    if(!GetHasFeat(FEAT_SCRIBE_SCROLL, oCaster))
    {
        // Stop
        FloatingTextStringOnCreature("*You cannot scribe a scroll without the scribe scroll feat*", oCaster, FALSE);
        return;
    }

    // Cannot be in combat
    if(GetIsInCombat(oCaster))
    {
        FloatingTextStringOnCreature("*You cannot scribe scrolls in combat*", oCaster, FALSE);
        return;
    }

    // Check if it is a "blank" scroll
    if(IPGetNumberOfItemProperties(oItem) != 0)
    {
        // No: Error message, and stop.
        FloatingTextStringOnCreature("*You cannot scribe a scroll onto a used scroll*", oCaster, FALSE);
        return;
    }

    // Spell name
    string sName = SMP_ArrayGetSpellName(nSpellId);

    // Check if this spell can be used for crafting
    if(SMP_CraftCheckSpell(nSpellId))
    {
        FloatingTextStringOnCreature("*You cannot scribe scrolls of " + sName + ". It is restricted.*", oCaster, FALSE);
        return;
    }

    // What level do we wish to use? nSpellLevel or the minimum level for
    // casting nSpellId using nCasterClass?
    // * DEFAULT TO LOWEST LEVEL
    int nScrollLevel = SMP_ArrayMinimumLevelCastAt(SMP_ArrayGetSpellLevel(nSpellId, nCasterClass), nCasterClass);

    // Check for experience, gold, etc.
/*
    You can create a scroll of any spell that you know. Scribing a scroll takes
    one day for each 1,000 gp in its base price. The base price of a scroll is
    its spell level x its caster level x 25 gp. To scribe a scroll, you must
    spend 1/25 of this base price in XP and use up raw materials costing
    one-half of this base price.

    Any scroll that stores a spell with a costly material component or an XP
    cost also carries a commensurate cost. In addition to the costs derived
    from the base price, you must expend the material component or pay the XP
    when scribing the scroll.
*/
    if(!SMP_CraftRemoveGoldXPFocus(oCaster, nSpellId, nScrollLevel, nSpellLevel, 25))
    {
        // Cannot do it. Debugged already.
        return;
    }

    // Get the right resref of the new scroll (correct name, description)
    // Adds SMP_CRAFT_RESREF_SCROLL_PREFIX with 0000 (SpellId) and
    // the level (00).
    string sResRef = SMP_CRAFT_RESREF_SCROLL_PREFIX + SMP_CraftStringNumberId(nSpellId, 4) + SMP_CraftStringNumberId(nScrollLevel, 2);
    object oItem = CreateItemOnObject(sResRef, oCaster, 1);
    if(GetIsObjectValid(oItem))
    {
        // Decrement the original stack by one (or destroy it)
        SMP_ComponentItemRemoveBy1(oItem);

        // Add a new potion to the casters inventory of the correct tag
        FloatingTextStringOnCreature("*You sucessfully scribed a scroll of " + sName + "*", oCaster, FALSE);
    }
}


// SMP_INC_CRAFT. Attempts to let oCaster brews the potion for nSpellId.
// It will usually use a default of the lowest level you are able to cast the spell
// at, eg:
// * Bear’s Endurance is a level 2 spell for quite a few classes.
// * Paladins/Bards couldn't brew a potion from it of course
// * It would be a level 3 potion for Clerics/Druids/Wizards...
// * ...a level 4 potion for Sorcerors...
// * ...a level 10 potion for rangers (!)
// But will take a maximum of nSpellLevel otherwise (1-40), or a user defined
// setting.
// * NOTE: Currently uses the LOWEST level! Might keep to this, or add in multiples
//   of 5 or something.
void SMP_CraftBrewPotion(object oCaster, int nSpellId, int nSpellLevel, int nCasterLevel, int nCasterClass, object oItem)
{
    // Feat check
    if(!GetHasFeat(FEAT_BREW_POTION, oCaster))
    {
        // Stop
        FloatingTextStringOnCreature("*You cannot brew a potion without the Brew Potion feat*", oCaster, FALSE);
        return;
    }

    // Level check
    if(nSpellLevel > 3)
    {
        // Stop
        FloatingTextStringOnCreature("*You cannot brew a potion with a spell level higher then 3*", oCaster, FALSE);
        return;
    }

    // Cannot be in combat
    if(GetIsInCombat(oCaster))
    {
        FloatingTextStringOnCreature("*You cannot brew potions in combat*", oCaster, FALSE);
        return;
    }

    // Can this spell be put onto a potion?
    // * Can we target ourselves with it?
    if(!SMP_GetIsTargetTypeSelf(SMP_ArrayGetSpellTargetType(nSpellId)))
    {
        FloatingTextStringOnCreature("*You can only brew potions for spells that can be cast on yourself*", oCaster, FALSE);
        return;
    }

    // Check if it is a "blank" potion
    if(IPGetNumberOfItemProperties(oItem) != 0)
    {
        // No: Error message, and stop.
        FloatingTextStringOnCreature("*You cannot brew a potion in a full bottle*", oCaster, FALSE);
        return;
    }

    // Spell name
    string sName = SMP_ArrayGetSpellName(nSpellId);

    // Check if this spell can be used for crafting
    if(SMP_CraftCheckSpell(nSpellId))
    {
        FloatingTextStringOnCreature("*You cannot brew potions a potion of " + sName + ". It is restricted.*", oCaster, FALSE);
        return;
    }

    // What level do we wish to use? nSpellLevel or the minimum level for
    // casting nSpellId using nCasterClass?
    // * DEFAULT TO LOWEST LEVEL
    int nPotionLevel = SMP_ArrayMinimumLevelCastAt(SMP_ArrayGetSpellLevel(nSpellId, nCasterClass), nCasterClass);

    // Check for experience, gold, etc.
/*
    You can create a potion of any 3rd-level or lower spell that you know and
    that targets one or more creatures. Brewing a potion takes one day. When
    you create a potion, you set the caster level, which must be sufficient to
    cast the spell in question and no higher than your own level. The base price
    of a potion is its spell level x its caster level x 50 gp. To brew a potion,
    you must spend 1/25 of this base price in XP and use up raw materials
    costing one half this base price.

    When you create a potion, you make any choices that you would normally make
    when casting the spell. Whoever drinks the potion is the target of the
    spell.

    Any potion that stores a spell with a costly material component or an XP
    cost also carries a commensurate cost. In addition to the costs derived
    from the base price, you must expend the material component or pay the XP
    when creating the potion.
*/
    if(!SMP_CraftRemoveGoldXPFocus(oCaster, nSpellId, nPotionLevel, nSpellLevel, 50))
    {
        // Cannot do it. Debugged already.
        return;
    }

    // Get the right resref of the new potion (correct colour, description)
    // Adds SMP_CRAFT_RESREF_POTION_PREFIX with 0000 (SpellId) and
    // the level (00).
    string sResRef = SMP_CRAFT_RESREF_POTION_PREFIX + SMP_CraftStringNumberId(nSpellId, 4) + SMP_CraftStringNumberId(nPotionLevel, 2);

    object oItem = CreateItemOnObject(sResRef, oCaster, 1);
    if(GetIsObjectValid(oItem))
    {
        // Decrement the original stack by one (or destroy it)
        SMP_ComponentItemRemoveBy1(oItem);

        // Add a new potion to the casters inventory of the correct tag
        FloatingTextStringOnCreature("*You sucessfully brew a potion of " + sName + "*", oCaster, FALSE);
    }
}

// SMP_INC_CRAFT. Attempts to let oCaster adds the spell, nSpellId, to the wand, oItem.
// It will usually use a default of the lowest level you are able to cast the spell
// at, eg:
// * Bear’s Endurance is a level 2 spell for quite a few classes.
// * Paladins/Bards couldn't brew a potion from it of course
// * It would be a level 3 potion for Clerics/Druids/Wizards...
// * ...a level 4 potion for Sorcerors...
// * ...a level 10 potion for rangers (!)
// But will take a maximum of nSpellLevel otherwise (1-40), or a user defined
// setting.
// * NOTE: Currently uses the LOWEST level! Might keep to this, or add in multiples
//   of 5 or something.
void SMP_CraftCraftWand(object oCaster, int nSpellId, int nSpellLevel, int nCasterLevel, int nCasterClass, object oItem)
{
    // Feat check
    if(!GetHasFeat(FEAT_CRAFT_WAND, oCaster))
    {
        // Stop
        FloatingTextStringOnCreature("*You cannot craft a wand without the Craft Wand feat*", oCaster, FALSE);
        return;
    }

    // Level check
    if(nSpellLevel > 4)
    {
        // Stop
        FloatingTextStringOnCreature("*You cannot craft a wand with a spell that is higher then level 4*", oCaster, FALSE);
        return;
    }

    // Cannot be in combat
    if(GetIsInCombat(oCaster))
    {
        FloatingTextStringOnCreature("*You cannot craft wands in combat*", oCaster, FALSE);
        return;
    }

    // Check if it is a "blank" wand
    if(IPGetNumberOfItemProperties(oItem) != 0)
    {
        // No: Error message, and stop.
        FloatingTextStringOnCreature("*You cannot craft more spells onto an already functioning wand*", oCaster, FALSE);
        return;
    }

    // Spell name
    string sName = SMP_ArrayGetSpellName(nSpellId);

    // Check if this spell can be used for crafting
    if(SMP_CraftCheckSpell(nSpellId))
    {
        FloatingTextStringOnCreature("*You cannot craft a wand of " + sName + ". It is restricted.*", oCaster, FALSE);
        return;
    }

    // What level do we wish to use? nSpellLevel or the minimum level for
    // casting nSpellId using nCasterClass?
    // * DEFAULT TO LOWEST LEVEL
    int nWandLevel = SMP_ArrayMinimumLevelCastAt(SMP_ArrayGetSpellLevel(nSpellId, nCasterClass), nCasterClass);

    // Check for experience, gold, etc.
/*
    You can create a wand of any 4th-level or lower spell that you know.
    Crafting a wand takes one day for each 1,000 gp in its base price. The
    base price of a wand is its caster level x the spell level x 750 gp. To
    craft a wand, you must spend 1/25 of this base price in XP and use up raw
    materials costing one-half of this base price. A newly created wand has 50
    charges.

    Any wand that stores a spell with a costly material component or an XP cost
    also carries a commensurate cost. In addition to the cost derived from the
    base price, you must expend fifty copies of the material component or pay
    fifty times the XP cost.
*/
    if(!SMP_CraftRemoveGoldXPFocus(oCaster, nSpellId, nWandLevel, nSpellLevel, 750, 50))
    {
        // Cannot do it. Debugged already.
        return;
    }

    // We add the property to this wand. Oh well, cannot change item name,
    // but no matter - they are meant to be unique (Rather then changing colour
    // like a potion!)
    int nItemPropSpellId = IP_CONST_CASTSPELL_VIRTUE_1;

    // Create the property (1 charge/use)
    itemproperty IP_Spell = ItemPropertyCastSpell(nItemPropSpellId, IP_CONST_CASTSPELL_NUMUSES_1_CHARGE_PER_USE);

    // Add the property to the item
    FloatingTextStringOnCreature("*You sucessfully create a Wand of " + sName + "*", oCaster, FALSE);

    // Add restrictions (EG: Only wizards and sorcerors get time stop)
    SMP_IP_AddRestrictionsForSpell(oItem, nSpellId);
    // Add it
    AddItemProperty(DURATION_TYPE_PERMANENT, IP_Spell, oItem);
}

// SMP_INC_CRAFT. This will return TRUE if the caster has the requested XP, gold and
// components, focus' and extra XP needed to csat the spell nSpellId.
// * Note: nCharges applies to components and extra XP only (for wands), and
//   is usually 50 or 1.
// Returns of FALSE remove nothing. Debugs are generic.
int SMP_CraftRemoveGoldXPFocus(object oCaster, int nSpellId, int nCasterLevel, int nSpellLevel, int nMultiplier, int nCharges = 1)
{
    // Item focus check
    string sTag = SMP_ArrayGetString(SMP_2DA_NAME_SMP_COMPONENTS, "FocusTag", nSpellId);
    string sItemName = GetStringByStrRef(SMP_ArrayGetInteger(SMP_2DA_NAME_SMP_COMPONENTS, "ComponentName", nSpellId));
    // For Debug
    string sSpellName = SMP_ArrayGetSpellName(nSpellId);
    if(sTag != "")
    {
        if(SMP_ComponentFocusItem(sTag, sItemName, sSpellName))
        {
            // Cannot cast - no focus present.
            return FALSE;
        }
    }

    // We need the component too (maybe nCharges amount!)
    int nCnt;
    // Check component.
    string sComponentTag = SMP_ArrayGetString(SMP_2DA_NAME_SMP_COMPONENTS, "ComponentTag", nSpellId);
    sItemName = GetStringByStrRef(SMP_ArrayGetInteger(SMP_2DA_NAME_SMP_COMPONENTS, "ComponentName", nSpellId));
    // Check sTag
    if(sComponentTag != "")
    {
        // Check for it with the new variable in SMP_ComponentExactItem()
        if(!SMP_ComponentExactItem(sComponentTag, sItemName, sSpellName, nCharges))
        {
            return FALSE;
        }
    }
    // The "Base Cost" of each item varies:
    // Using nMultiplier (25, 50, 750) we do this formula:
    // * nSpellLevel * nCasterLevel * nMultipler.
    // EG: For a level 1 spell being cast on a scroll, at level 5:
    // 1 * 5 * 25 = 125.
    // This is the BASE PRICE

    int nBaseCost;
    // Levels of one are special. They are considered "0.5" a spell.
    if(nSpellLevel == 0)
    {
        nBaseCost = FloatToInt(0.5 * IntToFloat(nCasterLevel) * IntToFloat(nMultiplier));
    }
    else
    {
        // Normal costs.
        nBaseCost = nSpellLevel * nCasterLevel * nMultiplier;// EG: * 750
    }

    // Note: Crafting items is cheaper - it is half of the base cost (done with
    // nGold above). We simply half nGold
    int nGold = nBaseCost / 2;

    // Check for gold amount:
    if(GetGold(oCaster) >= nGold)
    {
        // Failed, stop, not enough gold.
        FloatingTextStringOnCreature("*You require " + IntToString(nGold) + " gold to craft this item. You do not have enough*", oCaster, FALSE);
        return FALSE;
    }

    // Experience cost is 1/25th of the base cost.
    int nXP = nBaseCost / 25;

    // Minimum of 1XP cost
    if(nXP < 1) nXP = 1;

    // Add on an amount of XP for the spell that is needed (base amount)
    nXP += SMP_ArrayGetInteger(SMP_2DA_NAME_SMP_COMPONENTS, "BaseXPCost", nSpellId);

    // Check and remove this XP
    if(!SMP_ComponentXPCheck(nXP, oCaster))
    {
        // Stop, not enough XP
        FloatingTextStringOnCreature("*You require " + IntToString(nXP) + " experience over your previous level to craft this item. You do not have enough.*", oCaster, FALSE);
        return FALSE;
    }

    // Remove the gold, XP and components once we know we have both.
    if(sComponentTag != "") SMP_ComponentItemRemoveMany(sComponentTag, nCharges);
    if(nGold > 0) TakeGoldFromCreature(nGold, oCaster, TRUE);
    if(nXP > 0) SMP_ComponentXPRemove(nXP, oCaster);

    // Stuffed removed
    return TRUE;
}

// SMP_INC_CRAFT. Simply gets the lenght of the ID, and adds a number of zeroes, if any,
// to get it up to nCharacters length.
string SMP_CraftStringNumberId(int nNumber, int nCharacters)
{
    // Convert the first one
    string sStart = IntToString(nNumber);
    string sZeroes;

    // Get length
    int nNeeded = nCharacters - GetStringLength(sStart);
    while(nNeeded >= 1)
    {
        // Add more zeroes to the LEFT. So 22 becomes 0022 perhaps.
        sZeroes += "0";
    }
    // Create final string of zeroes and the original.
    string sFinal = sZeroes + sStart;

    // Return it.
    return sFinal;
}
// End of file Debug lines. Uncomment below "/*" with "//" and compile.
/*
void main()
{
    return;
}
//*/
