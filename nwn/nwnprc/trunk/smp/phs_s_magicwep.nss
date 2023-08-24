/*:://////////////////////////////////////////////
//:: Spell Name Magic Weapon
//:: Spell FileName PHS_S_MagicWep
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Clr 1, Pal 1, Sor/Wiz 1, War 1
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: Touch
    Target: Weapon touched
    Duration: 1 min./level
    Saving Throw: Will negates (harmless, object)
    Spell Resistance: Yes (harmless, object)

    Magic weapon gives a melee weapon a +1 enhancement bonus on attack and
    damage rolls, or a bow the same amount in an attack bonus.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Enchantment bonus, very easy.

    Does just +1, to melee weapons only.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"
#include "prc_x2_itemprop"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_MAGIC_WEAPON)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oItem = GetSpellTargetObject(); // Should be an item!
    object oPossessor = GetItemPossessor(oItem);
    int nItemType = GetBaseItemType(oItem);
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Duration is 1 minute a level
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel, nMetaMagic);

    // Declare bonus property
    itemproperty IP_Enchant = ItemPropertyEnhancementBonus(1);
    itemproperty IP_Attack = ItemPropertyAttackBonus(1);
    effect eVis = EffectVisualEffect(PHS_VFX_IMP_MAGIC_WEAPON);

    if(GetIsObjectValid(oPossessor))
    {
        // Signal event
        PHS_SignalSpellCastAt(oPossessor, PHS_SPELL_MAGIC_WEAPON, FALSE);
    }

    // Should target the melee weapon to enchant
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
