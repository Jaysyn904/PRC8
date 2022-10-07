/*:://////////////////////////////////////////////
//:: Spell Name Holy Sword
//:: Spell FileName
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation [Good]
    Level: Pal 4
    Components: V, S
    Casting Time: 1 standard action
    Range: Touch
    Target: Melee weapon touched in hand
    Duration: 1 round/level
    Saving Throw: None
    Spell Resistance: No

    This spell allows you to channel holy power into your sword, or any other
    melee weapon you choose. The weapon acts as a holy weapon (+3 enhancement
    bonus on attack and damage rolls, extra 2d6 damage against evil opponents,
    25% chance to dispel magic On hit).
    It also emits a magic circle against evil effect (as the spell). The spell
    is automatically canceled after the weapon leaves your hand. You cannot have
    more than one holy sword at a time.

    This spell is not cumulative with bless weapon or any other spell that might
    modify the weapon in any way. This spell does not work on artifacts.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    We target the first melee weapon without a On Hit property equipped.

    This is similar to Biowares, except it adds a Magic circle Against Evil

    The Magic Circle against Evil will be added as soon as the spell and AOe
    entries are!

    The difference of this is that if the spell is removed, the holy sword
    property is too.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"
#include "prc_x2_itemprop"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_HOLY_SWORD)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject(); // Should be only OBJECT_SELF.
    // It auto picks the item to cast on
    object oItem;
    int nAmmoType = GetBaseItemType(oTarget);
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    itemproperty IP_Add = ItemPropertyHolyAvenger();

    // Duration is 1 round a level
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // Declare effects
    effect eDur;
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_GOOD_HELP);
    effect eMagicAura;

    // Link effects
    effect eLink = eCessate;

    // Signal event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_HOLY_SWORD, FALSE);

    // Is the item equipped
    object oLefthand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCaster);
    object oRighthand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCaster);

    // Get the first (Righthand first), else lefthand, and make sure neither
    // have it.
    if(!GetItemHasItemProperty(oLefthand, ITEM_PROPERTY_HOLY_AVENGER) &&
       !GetItemHasItemProperty(oRighthand, ITEM_PROPERTY_HOLY_AVENGER))
    {
        // Use the righthand first
        if(GetIsObjectValid(oRighthand))
        {
            oItem = oRighthand;
        }
        // Else lefthand
        else if(GetIsObjectValid(oLefthand))
        {
            oItem = oLefthand;
        }
        // else invalid
        else
        {
            return;
        }
    }

    // Enchant item and apply duration effects
    PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
    IPSafeAddItemProperty(oItem, IP_Add, fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, TRUE, TRUE);
    return;
}
