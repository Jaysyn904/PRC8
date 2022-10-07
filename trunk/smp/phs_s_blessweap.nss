/*:://////////////////////////////////////////////
//:: Spell Name Bless Weapon
//:: Spell FileName PHS_S_BlessWeap
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Bless Weapon
    Transmutation
    Level: Pal 1
    Components: V, S
    Casting Time: 1 standard action
    Range: Touch
    Target: Weapon touched
    Duration: 1 min./level
    Saving Throw: None
    Spell Resistance: No

    This transmutation makes a weapon strike true against evil foes. The weapon
    is enchanted to be +1 against evil, gaining +1 to hit, +1 damage and able
    to bypass level 1 damage reduction on evil creatures.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Just adds a +1 Enchantment Bonus against Evil creatures, to the weapon. Best
    we can do... :-(

    Should work as Bioware item property addings.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

// These hold the all important weapon functions. Will seperate later and modify.
#include "prc_x2_itemprop"

void AddEnhancementEffectToWeapon(object oMyWeapon, float fDuration)
{
    IPSafeAddItemProperty(oMyWeapon, ItemPropertyEnhancementBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, 1), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, TRUE, TRUE);
    return;
}

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck()) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oWeaponTarget = IPGetTargetedOrEquippedMeleeWeapon();
    object oTarget = GetItemPossessor(oWeaponTarget);
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // Duration in minutes
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel, nMetaMagic);

    //Declare major variables
    effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    if(GetIsObjectValid(oWeaponTarget))
    {
        // Signal event spel cast at
        PHS_SignalSpellCastAt(oTarget, PHS_SPELL_BLESS_WEAPON, FALSE);

        // Apply effects and enchantment, +1 VS evil, to weapon
        PHS_ApplyDurationAndVFX(oTarget, eVis, eCessate, fDuration);
        AddEnhancementEffectToWeapon(oWeaponTarget, fDuration);
        return;
    }
    else
    {
        // * Spell Failed - Target must be a melee weapon or creature
        //   with a melee weapon equipped *
        FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
        return;
    }
}
