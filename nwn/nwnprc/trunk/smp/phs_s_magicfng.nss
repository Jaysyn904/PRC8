/*:://////////////////////////////////////////////
//:: Spell Name Magic Fang
//:: Spell FileName PHS_S_MagicFng
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Drd 1, Rgr 1
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: Touch
    Target: Living creature touched
    Duration: 1 min./level
    Saving Throw: Will negates (harmless)
    Spell Resistance: Yes (harmless)

    Magic fang gives one natural weapon of the subject a +1 enhancement bonus
    on attack and damage rolls. The spell can affect a slam attack, fist or bite.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    It affects ONE of the targets creature weapons if they havn't got a enchantment
    bonus already.

    Greater version can do all OR +5 to one.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_MAGIC_FANG)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    object oItem;
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int bDone = FALSE;

    // Duration is 1 minute a level
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel, nMetaMagic);

    // Signal event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_MAGIC_FANG, FALSE);

    // Declare effects
    effect eVis = EffectVisualEffect(PHS_VFX_IMP_MAGIC_FANG);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    itemproperty IP_Enchant = ItemPropertyEnhancementBonus(1);

    // Get the creatures items and apply the effect
    oItem = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oTarget);
    if(GetIsObjectValid(oItem) &&
      !GetItemHasItemProperty(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS))
    {
        bDone = TRUE;
        AddItemProperty(DURATION_TYPE_TEMPORARY, IP_Enchant, oItem, fDuration);
    }
    if(bDone == FALSE)
    {
        oItem = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oTarget);
        if(GetIsObjectValid(oItem) &&
          !GetItemHasItemProperty(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS))
        {
            bDone = TRUE;
            AddItemProperty(DURATION_TYPE_TEMPORARY, IP_Enchant, oItem, fDuration);
        }
    }
    if(bDone == FALSE)
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
