/*:://////////////////////////////////////////////
//:: Spell Name Flame Arrow
//:: Spell FileName PHS_S_FlameArrow
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    50 projectiles are given 1d6 fire damage for 10min/level.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Using the hordes functions, and checking inventory, it applies 10 minutes/level
    worth of damage increase.

    Only works on ones which don't have it already, normally base items.

    Searches:
    - If the target is a projectile
    - Ammo slot for an equipped ranged weapon
    - First valid ammo slot
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"
#include "prc_x2_itemprop"

// Adds 1d6 damage to oItem, fire damage.
void AddDamageToItem(object oItem, float fDuration);

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_FLAME_ARROW)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject(); // Should be an item!
    object oPossessor = GetItemPossessor(oTarget);
    int nAmmoType = GetBaseItemType(oTarget);
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    itemproperty IP_COMPARE = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d6);

    // Duration is 10 minutes a level
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel * 10, nMetaMagic);

    if(GetIsObjectValid(oPossessor))
    {
        // Signal event
        PHS_SignalSpellCastAt(oPossessor, PHS_SPELL_FLAME_ARROW, FALSE);
    }

    // Should target the projectiles to change
    if(GetIsObjectValid(oTarget) &&
      (nAmmoType == BASE_ITEM_ARROW ||
       nAmmoType == BASE_ITEM_BULLET ||
       nAmmoType == BASE_ITEM_BOLT) &&
      !PHS_IP_GetIsEnchanted(oTarget) /* && Is not enchanted*/)
    {
        // Enchant item
        AddDamageToItem(oTarget, fDuration);
        return;
    }
}

// Adds 1d6 damage to oItem, fire damage.
void AddDamageToItem(object oItem, float fDuration)
{
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
    object oPossessor = GetItemPossessor(oItem);
    if(GetIsObjectValid(oPossessor))
    {
        PHS_ApplyVFX(oPossessor, eVis);
    }
    else
    {
        PHS_ApplyLocationVFX(GetLocation(oItem), eVis);
    }
    // Split stack size
    int nStack = GetItemStackSize(oItem);
    int nCreateNew = nStack - 50;
    object oNew;
    if(nCreateNew > 0)
    {
        // Split the CopyItemitems if we have over 50 in a stack
        oNew = CopyItem(oItem, oPossessor, TRUE);
        SetItemStackSize(oNew, nCreateNew);
        // Set orignal to 50
        SetItemStackSize(oItem, 50);
    }
    // Apply effects using Bioware's way
    itemproperty IP_Fire = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d6);
    // Add new one
    IPSafeAddItemProperty(oItem, IP_Fire, fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, TRUE);
}
