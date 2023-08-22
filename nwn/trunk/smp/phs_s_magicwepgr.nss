/*:://////////////////////////////////////////////
//:: Spell Name Magic Weapon, Greater
//:: Spell FileName PHS_S_MagicWepGr
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Clr 4, Pal 3, Sor/Wiz 3
    Components: V, S, M/DF
    Casting Time: 1 standard action
    Range: Close (8M)
    Target: One weapon or fifty projectiles (all of which must be in contact
            with each other at the time of casting)
    Duration: 1 hour/level
    Saving Throw: Will negates (harmless, object)
    Spell Resistance: Yes (harmless, object)

    This spell functions like magic weapon, except that it gives a melee weapon an
    enhancement bonus on attack and damage rolls of +1 per four caster levels
    (maximum +5).

    Alternatively, you can affect as many as fifty arrows, bolts, or bullets of
    the same type, granting an appropriate bonus to damage.

    Arcane Material Component: Powdered lime and carbon.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Enchantment bonus, very easy, or a damage bonus to projectiles.

    Easy enough.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"
#include "prc_x2_itemprop"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_MAGIC_WEAPON_GREATER)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oItem = GetSpellTargetObject(); // Should be an item!
    object oPossessor = GetItemPossessor(oItem);
    int nItemType = GetBaseItemType(oItem);
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Duration is 1 hour a level
    float fDuration = PHS_GetDuration(PHS_HOURS, nCasterLevel, nMetaMagic);

    // Get bonus for the weapon - 1 per 4 caster levels, max +5
    int nBonus = PHS_LimitInteger(nCasterLevel/4, 5);

    // Declare bonus property
    itemproperty IP_Enchant = ItemPropertyEnhancementBonus(nBonus);
    itemproperty IP_Damage = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_PIERCING, IPGetDamageBonusConstantFromNumber(nBonus));
    itemproperty IP_Attack = ItemPropertyAttackBonus(nBonus);
    effect eVis = EffectVisualEffect(PHS_VFX_IMP_MAGIC_WEAPON_GREATER);

    if(GetIsObjectValid(oPossessor))
    {
        // Signal event
        PHS_SignalSpellCastAt(oPossessor, PHS_SPELL_MAGIC_WEAPON_GREATER, FALSE);
    }

    // Should target the weapon to enchant
    if(GetIsObjectValid(oItem))
    {
        if(IPGetIsMeleeWeapon(oItem))
        {
            // Apply VFX
            PHS_IP_ApplyImactVisualAtItemLocation(eVis, oItem);

            // Enchant item
            IPSafeAddItemProperty(oItem, IP_Enchant, fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, TRUE);
            return;
        }
        else if(nItemType == BASE_ITEM_ARROW ||
                nItemType == BASE_ITEM_BOLT ||
                nItemType == BASE_ITEM_BULLET)
        {
            // Divide the item up
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

            // Visuals
            PHS_IP_ApplyImactVisualAtItemLocation(eVis, oItem);

            // Enchant item of the new 50 stack.
            AddItemProperty(DURATION_TYPE_TEMPORARY, IP_Damage, oItem, fDuration);
        }
        else if(GetWeaponRanged(oItem))
        {
            // Apply VFX
            PHS_IP_ApplyImactVisualAtItemLocation(eVis, oItem);

            // Enchant item
            IPSafeAddItemProperty(oItem, IP_Attack, fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, TRUE);
            return;
        }
    }
}
