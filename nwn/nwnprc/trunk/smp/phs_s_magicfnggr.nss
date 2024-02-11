/*:://////////////////////////////////////////////
//:: Spell Name Magic Fang, Greater
//:: Spell FileName PHS_S_MagicFngGr
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Drd 3, Rgr 3
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: Close (8M)
    Target: One living creature
    Duration: 1 hour/level
    Saving Throw: Will negates (harmless)
    Spell Resistance: Yes (harmless)

    This spell functions like magic fang, except that the enhancement bonus on
    attack and damage rolls is +1 per four caster levels (maximum +5). The spell
    can affect slam attack, fist, bite, or other natural weapons.

    Alternatively, you may imbue all of the creature’s natural weapons with a
    +1 enhancement bonus (regardless of your caster level).
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    It affects all of the targets creature weapons if they havn't got a enchantment
    bonus already, +1 all.

    Or +5 to one.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_MAGIC_FANG_GREATER)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    object oItem;
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int bDone = FALSE;
    int bDoAll = FALSE;
    int nSpellId = GetSpellId();
    int nBonus;

    // Duration is 1 hour a level
    float fDuration = PHS_GetDuration(PHS_HOURS, nCasterLevel, nMetaMagic);

    // Signal event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_MAGIC_FANG_GREATER, FALSE);

    // Get what spell it is
    if(nSpellId == PHS_SPELL_MAGIC_FANG_GREATER_ALL)
    {
        // ALL weapons +1
        nBonus = 1;
        bDoAll = TRUE;
    }
    else //if(nSpellId == PHS_SPELL_MAGIC_FANG_GREATER_ONE)
    {
        // ONE weapon, up to +5.
        nBonus = PHS_LimitInteger(nCasterLevel/4, 5);
    }

    // Declare effects
    effect eVis = EffectVisualEffect(PHS_VFX_IMP_MAGIC_FANG_GREATER);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    itemproperty IP_Enchant = ItemPropertyEnhancementBonus(nBonus);

    // Get the creatures items and apply the effect
    oItem = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oTarget);
    if(GetIsObjectValid(oItem) &&
      !GetItemHasItemProperty(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS))
    {
        bDone = TRUE;
        AddItemProperty(DURATION_TYPE_TEMPORARY, IP_Enchant, oItem, fDuration);
    }
    if(bDone == FALSE || bDoAll == TRUE)
    {
        oItem = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oTarget);
        if(GetIsObjectValid(oItem) &&
          !GetItemHasItemProperty(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS))
        {
            bDone = TRUE;
            AddItemProperty(DURATION_TYPE_TEMPORARY, IP_Enchant, oItem, fDuration);
        }
    }
    if(bDone == FALSE || bDoAll == TRUE)
    {
        oItem = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oTarget);
        if(GetIsObjectValid(oItem) &&
          !GetItemHasItemProperty(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS))
        {
            bDone = TRUE;
            AddItemProperty(DURATION_TYPE_TEMPORARY, IP_Enchant, oItem, fDuration);
        }
    }
    if(bDone == TRUE)
    {
        // Apply duration and instant VFX's if we appled it
        PHS_ApplyDurationAndVFX(oTarget, eVis, eDur, fDuration);
    }
}
