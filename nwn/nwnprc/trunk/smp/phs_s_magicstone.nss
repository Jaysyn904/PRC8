/*:://////////////////////////////////////////////
//:: Spell Name Magic Stone
//:: Spell FileName PHS_S_MagicStone
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Clr 1, Drd 1, Earth 1
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: Touch
    Targets: Up to three pebbles touched
    Duration: 30 minutes or until discharged
    Saving Throw: Will negates (harmless, object)
    Spell Resistance: Yes (harmless, object)

    You transmute as many as three nonmagical sling bullets so that they strike
    with great force when slung. The spell gives them a +1 bonus on damage rolls,
    and an additional 1d6 + 1 damage bonus versus undead.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Adds +1 damage VS all to 3 bullets.

    Also adds 1d6 + 1 damage verus undead.

    Must be totally unmagical bullets targeted.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_MAGIC_STONE)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oItem = GetSpellTargetObject(); // Should be an item!
    object oPossessor = GetItemPossessor(oItem);
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Apply all of these damage bonuses
    itemproperty IP_Normal = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_PIERCING, IP_CONST_DAMAGEBONUS_1);
    itemproperty IP_Undead1 = ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, IP_CONST_DAMAGETYPE_PIERCING, IP_CONST_DAMAGEBONUS_1);
    itemproperty IP_Undead2 = ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, IP_CONST_DAMAGETYPE_PIERCING, IP_CONST_DAMAGEBONUS_1d6);
    effect eVis = EffectVisualEffect(PHS_VFX_IMP_MAGIC_STONE);

    // Duration is 30 minutes
    float fDuration = PHS_GetDuration(PHS_MINUTES, 30, nMetaMagic);

    if(GetIsObjectValid(oPossessor))
    {
        // Signal event
        PHS_SignalSpellCastAt(oPossessor, PHS_SPELL_MAGIC_STONE, FALSE);
    }

    // Should target the projectiles to change
    if(GetIsObjectValid(oItem) &&
       GetBaseItemType(oItem) == BASE_ITEM_BULLET &&
      !PHS_IP_GetIsEnchanted(oItem) /* && Is not enchanted*/)
    {
        // Divide the item up
        int nStack = GetItemStackSize(oItem);
        int nCreateNew = nStack - 3;
        object oNew;
        if(nCreateNew > 0)
        {
            // Split the CopyItemitems if we have over 50 in a stack
            oNew = CopyItem(oItem, oPossessor, TRUE);
            SetItemStackSize(oNew, nCreateNew);
            // Set orignal to 3
            SetItemStackSize(oItem, 3);
        }
        if(GetIsObjectValid(oPossessor))
        {
            // Apply visuals
            PHS_ApplyVFX(oPossessor, eVis);
        }

        // Enchant item of the new 3 stack.
        AddItemProperty(DURATION_TYPE_TEMPORARY, IP_Normal, oItem, fDuration);
        AddItemProperty(DURATION_TYPE_TEMPORARY, IP_Undead1, oItem, fDuration);
        AddItemProperty(DURATION_TYPE_TEMPORARY, IP_Undead2, oItem, fDuration);
        return;
    }
}
