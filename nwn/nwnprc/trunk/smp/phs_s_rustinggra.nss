/*:://////////////////////////////////////////////
//:: Spell Name Rusting Grasp
//:: Spell FileName PHS_S_RustingGra
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Drd 4
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: Touch
    Target: One nonmagical ferrous object or one ferrous creature
    Duration: See text
    Saving Throw: None
    Spell Resistance: No

    Any iron or iron alloy item you touch becomes instantaneously rusted,
    pitted, and worthless. This spell can target armor or weapons, either on an
    enemy or directly. Magic items made of metal are immune to this spell.

    You may employ rusting grasp in combat with a successful melee touch attack.
    Rusting grasp used in this way instantaneously destroys 1d6 points of Armor
    Class gained from metal armor (to the maximum amount of protection the armor
    offered) through corrosion.

    Weapons in use by an opponent targeted by the spell are more difficult to
    grasp. You must succeed on a melee touch attack against the weapon, and if
    you do touch it, you are damaged by it as if normally hit by your opponent
    (even if the weapon is magical). A metal weapon that is hit is destroyed.

    Against a ferrous creature, rusting grasp instantaneously deals 3d6 points
    of damage +1 per caster level (maximum +15) per successful attack. The spell
    lasts for 1 round per level, and you can make one melee touch attack per
    round.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    1 round/level duration, can use the touch each round.

    2 versions (noting both targeted against metal monsters will do damage),
    one sub-dial spell will target armor, one weapons.

    Metal weapons are many, and hell, color while important, will NOT dictate
    it.

    If it is too powerful, might restrict it some more.

    Metal weapons:
    PHS_GetIsMetalWeapon();
    PHS_GetIsMetalArmor();
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

// Get how much damage they have done for a normal hit. Uses 2da lookups.
int GetAttackDamage(object oTarget, object oItem);

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_RUSTING_GRASP)) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nDamage;
    int nSpellId = GetSpellId();
    object oItem;

    // Duration is caster level in rounds
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, FALSE);

    // Calculate max damage bonus
    int nBonusDamage = PHS_LimitInteger(nCasterLevel, 15); // Max of +15 damage

    // Can use it multiple times using the touch attack thingy
    // Check caster item
    if(!PHS_CheckChargesForSpell(PHS_SPELL_RUSTING_GRASP, nCasterLevel, fDuration)) return;

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // Declare effects
    effect eVis = EffectVisualEffect(PHS_VFX_IMP_RUSTING_GRASP);

    // Touch attack always needed
    int nTouch = PHS_SpellTouchAttack(PHS_TOUCH_MELEE, oTarget, TRUE);

    // First, check if they are ferrous (metal) creatures, and do damage instead
    if(PHS_GetIsFerrous(oTarget))
    {
        // Signal Spell cast at
        PHS_SignalSpellCastAt(oTarget, PHS_SPELL_RUSTING_GRASP);

        // Needs to hit.
        if(nTouch)
        {
            // Only creatures, and PvP check.
            if(!GetIsReactionTypeFriendly(oTarget))
            {
                //Spell resistance and globe check - no turning for touch attacks, however.
                if(!PHS_SpellResistanceCheck(oCaster, oTarget))
                {
                    // Damage - can critical
                    nDamage = PHS_MaximizeOrEmpower(6, 3, nMetaMagic, nBonusDamage, nTouch);

                    // Do damage and VFX
                    PHS_ApplyDamageVFXToObject(oTarget, eVis, nDamage, DAMAGE_TYPE_ELECTRICAL);
                }
            }
        }
    }
    // Ok, check spell
    else if(nSpellId == PHS_SPELL_RUSTING_GRASP_ARMOR)
    {
        // Get the armor
        oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget);

        // Make sure they are not immune to spells
        if(PHS_TotalSpellImmunity(oItem)) return;

        // Check if valid
        if(!GetIsObjectValid(oItem))
        {
            FloatingTextStringOnCreature("*The target is wearing no armor*", oCaster, FALSE);
            return;
        }

        // Check if enchanted
        if(PHS_IP_GetIsEnchanted(oItem))
        {
            FloatingTextStringOnCreature("*You cannot rust magical armor*", oCaster, FALSE);
            return;
        }

        // If valid, we check if we can rust it
        if(!PHS_GetIsMetalArmor(oItem))
        {
            FloatingTextStringOnCreature("*You cannot rust non-metal armor*", oCaster, FALSE);
            return;
        }

        // Metal armor has -1d6 penalty to its AC put on it, in addition to
        // any already on it, up to what AC it gives.
        int nACItGives = PHS_GetArmorType(oItem);

        // Get the current penalties on the armor
        int nCurrent = PHS_IP_GetArmorEnchantedPenalties(oItem);
        // Remove the current penalties
        IPRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_DECREASED_AC, DURATION_TYPE_PERMANENT, IP_CONST_ACMODIFIERTYPE_ARMOR);

        // Add 1d4 + 1 onto the armor
        nCurrent += d4();
        nCurrent += 1;
        // (No metamagic)
        if(nCurrent > 5) nCurrent = 5;

        // Apply VFX
        PHS_ApplyVFX(oTarget, eVis);

        // Add this penalty, and notify enemy
        FloatingTextStringOnCreature("*Your armor seems to rust instantly, corroding its usefulness*", oTarget, FALSE);
        itemproperty IP_Armor = ItemPropertyDecreaseAC(IP_CONST_ACMODIFIERTYPE_ARMOR, nCurrent);
        AddItemProperty(DURATION_TYPE_PERMANENT, IP_Armor, oItem);
    }
    else// if(nSpellId == PHS_SPELL_RUSTING_GRASP_WEAPON)
    {
        // We rust a weapon
        // Get the righthand weapon
        oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
        // Not valid? Check lefthand
        if(!GetIsObjectValid(oItem))
        {
            // Lefthand next
            oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
        }

        // Make sure they are not immune to spells
        if(PHS_TotalSpellImmunity(oItem)) return;

        // Check if valid
        if(!GetIsObjectValid(oItem))
        {
            FloatingTextStringOnCreature("*The target is using no weapon*", oCaster, FALSE);
            return;
        }

        // We always do damage
        DelayCommand(1.0, FloatingTextStringOnCreature("*You touch the opponents weapon, taking damage*", oCaster, FALSE));
        effect eDam = EffectDamage(GetAttackDamage(oTarget, oItem));
        AssignCommand(oTarget, PHS_ApplyInstant(oCaster, eDam));

        // Check if enchanted
        if(PHS_IP_GetIsEnchanted(oItem))
        {
            FloatingTextStringOnCreature("*You cannot rust magical weapons*", oCaster, FALSE);
            return;
        }

        // If valid, we check if we can rust it
        if(!PHS_GetIsMetalWeapon(oItem))
        {
            FloatingTextStringOnCreature("*You cannot rust non-metal weapon*", oCaster, FALSE);
            return;
        }

        // We destroy the item - ouch!
        FloatingTextStringOnCreature("*Your metal weapon rusts away and is destroyed!*", oTarget, FALSE);
        DestroyObject(oItem);
    }
}

// Get how much damage they have done for a normal hit. Uses 2da lookups.
int GetAttackDamage(object oTarget, object oItem)
{
    // Check how much damage oItem does
    // Get dice
    int nItemType = GetBaseItemType(oItem);
    int nDiceSides = StringToInt(Get2DAString("baseitems", "DieToRoll", nItemType));
    int nDice = StringToInt(Get2DAString("baseitems", "NumDice", nItemType));
    int nDam = PHS_MaximizeOrEmpower(nDiceSides, nDice, FALSE);

    // Add any penalties or anything from the item
    nDam += PHS_IP_GetItemBonusDamage(oItem);

    // Check how much extra from strength
    nDam += GetAbilityModifier(ABILITY_STRENGTH, oTarget);

    // Return damage
    return nDam;
}
