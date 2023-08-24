/*:://////////////////////////////////////////////
//:: Spell Name Magic Vestment
//:: Spell FileName PHS_S_MagicVestm
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Clr 3, Strength 3, War 3
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: Touch
    Target: Armor or shield touched
    Duration: 1 hour/level
    Saving Throw: Will negates (harmless, object)
    Spell Resistance: Yes (harmless, object)

    You imbue a suit of armor or a shield with an enhancement bonus of +1 per
    four caster levels (maximum +5 at 20th level).

    An outfit of regular clothing counts as armor that grants no AC bonus for
    the purpose of this spell.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Applies the bonus AC using the special function.

    Only can be put on armor or shields.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"
#include "prc_x2_itemprop"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_MAGIC_VESTMENT)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oItem = GetSpellTargetObject(); // Should be an item!
    object oPossessor = GetItemPossessor(oItem);
    int nItemType = GetBaseItemType(oItem);
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Duration is 1 hour a level
    float fDuration = PHS_GetDuration(PHS_HOURS, nCasterLevel, nMetaMagic);

    // Get enchantment bonus
    int nBonus = PHS_LimitInteger(nCasterLevel/4, 5);

    // Declare bonus property
    itemproperty IP_Enchant = ItemPropertyACBonus(nBonus);
    effect eVis = EffectVisualEffect(PHS_VFX_IMP_MAGIC_VESTMENT);

    if(GetIsObjectValid(oPossessor))
    {
        // Signal event
        PHS_SignalSpellCastAt(oPossessor, PHS_SPELL_MAGIC_VESTMENT, FALSE);
    }

    // Should target the armor to change
    if(GetIsObjectValid(oItem) &&
      (nItemType == BASE_ITEM_ARMOR ||
       nItemType == BASE_ITEM_LARGESHIELD ||
       nItemType == BASE_ITEM_SMALLSHIELD ||
       nItemType == BASE_ITEM_TOWERSHIELD))
    {
        // Apply VFX
        PHS_IP_ApplyImactVisualAtItemLocation(eVis, oItem);

        // Enchant item
        IPSafeAddItemProperty(oItem, IP_Enchant, fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, TRUE);
        return;
    }
}
