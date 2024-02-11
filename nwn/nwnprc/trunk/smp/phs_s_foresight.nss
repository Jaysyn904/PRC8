/*:://////////////////////////////////////////////
//:: Spell Name Foresight
//:: Spell FileName PHS_S_Foresight
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Divination
    Level: Drd 9, Knowledge 9, Sor/Wiz 9
    Components: V, S, M/DF
    Casting Time: 1 standard action
    Range: Personal
    Target: See text
    Duration: 10 min./level
    Saving Throw: None or Will negates (harmless)
    Spell Resistance: No or Yes (harmless)

    This spell grants you a powerful sixth sense in relation to yourself. Once
    foresight is cast, you receive instantaneous warnings of impending danger or
    harm to the yourself.

    You recieve +4 inititive (Unless you already have improved inititive) and
    become immune to knockdown, and gain the Uncanny Dodge feat, if you do not
    already know it, so you are never caught flat footed.

    In addition, the spell gives you a general idea of what action you might
    take to best protect yourself and gives you a +2 dodge bonus to AC and
    Reflex saves.

    Arcane Material Component: A hummingbird’s feather.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Different from 3E. Casts only on self is much easier :-)

    It'd not grant as many bonuses to an ally anyway.

    Immunity to knockdown, +4 intitive VIA Improved Inititive, Uncanny dodge
    to retain thier dex bonus to thier AC. Add these feats onto the creature
    hide. +2 AC and +2 reflex saves too.

    Type of Feat: Class
    Prerequisite: Barbarian level 2, rogue level 3, shadowdancer level 2 or
                  assassin level 2.
    Specifics: The character retains his Dex bonus to AC, even if caught
               flat-footed or attacked by a hidden or invisible creature.
    Use: Automatic.


    TO DO:

    - Add correct feats to somewhere

    The "somewhere" where the feats go is thier current armor. If unequipped,
    the effects are lost.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

// These hold the all important weapon functions. Will seperate later and modify.
#include "prc_x2_itemprop"

void main()
{
    // Spell Hook check
    if(!PHS_SpellHookCheck(PHS_SPELL_FORESIGHT)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();// Should be OBJECT_SELF
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget);
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // If oArmor is not valid, we will at least use the creature hide
    if(!GetIsObjectValid(oArmor))
    {
        // If this also is invalid, no feats are put on items.
        oArmor = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oTarget);
    }

    // Duration is 10 turns/level
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel * 10, nMetaMagic);

    // Declare effects
    effect eDur = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);
    effect eAC = EffectACIncrease(2, AC_DODGE_BONUS);
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_REFLEX, 2);
    effect eImmune = EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Item properties. Need to update sometime to real ones.
    itemproperty IP_UncannyDodge = ItemPropertyBonusFeat(IP_CONST_FEAT_DODGE);
    itemproperty IP_ImprovedInitiative = ItemPropertyBonusFeat(IP_CONST_FEAT_DODGE);

    // Link effects
    effect eLink = EffectLinkEffects(eDur, eAC);
    eLink = EffectLinkEffects(eLink, eSave);
    eLink = EffectLinkEffects(eLink, eImmune);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Signal spell cast at event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_FORESIGHT, FALSE);

    // Remove previous castings
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_FORESIGHT, oTarget);

    // Apply new effects
    PHS_ApplyDuration(oTarget, eLink, fDuration);

    if(GetIsObjectValid(oArmor))
    {
        IPSafeAddItemProperty(oArmor, IP_UncannyDodge, fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        IPSafeAddItemProperty(oArmor, IP_ImprovedInitiative, fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }
}
