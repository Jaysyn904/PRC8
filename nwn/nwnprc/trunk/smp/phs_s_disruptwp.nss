/*:://////////////////////////////////////////////
//:: Spell Name Disrupting Weapon
//:: Spell FileName PHS_S_DisruptWp
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Clr 5
    Components: V, S
    Casting Time: 1 standard action
    Range: Touch
    Targets: One melee weapon
    Duration: 1 round/level
    Saving Throw: Will negates (harmless, object); see text
    Spell Resistance: Yes (harmless, object)

    This spell makes a melee weapon deadly to undead. Any undead creature with
    HD equal to or less than your caster level must succeed on a Will save or be
    destroyed utterly if struck in combat with this weapon. Spell resistance
    does not apply against the destruction effect.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Special On hit effect that kills undead.

    Sets a local on the weapon for the caster level, as well.

    Quote: x2_s3_darkfire

    We need to use this property because we can not
    add random elemental damage to a weapon in any
    other way and implementation should be as close
    as possible to the book.

    Behavior:
    The casterlevel is set as a variable on the
    weapon, so if players leave and rejoin, it
    is lost (and the script will just assume a
    minimal caster level).

    We set the DC onto the weapon as a local int. PHS_S_DisruptWpA has the
    actual "On hit" stuff.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

// These hold the all important weapon functions. Will seperate later and modify.
#include "prc_x2_itemprop"

void AddDisruptEffectToWeapon(object oTarget, float fDuration, int nCasterLevel)
{
   // If the spell is cast again, any previous itemproperties matching are removed.
   IPSafeAddItemProperty(oTarget, ItemPropertyOnHitCastSpell(PHS_IP_CONST_ONHIT_CASTSPELL_DISRUPTING_WEAPON, nCasterLevel), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
   IPSafeAddItemProperty(oTarget, ItemPropertyVisualEffect(ITEM_VISUAL_HOLY), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
   return;
}

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_DISRUPTING_WEAPON)) return;

    // Declare major variables
    object oTarget = GetSpellTargetObject(); // Should be object self.
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    // Duration in rounds
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eVis = EffectVisualEffect(SPELL_MAGE_ARMOR);

    // Get weapon cast on
    object oMyWeapon = IPGetTargetedOrEquippedMeleeWeapon();
    object oWeaponPossessor = GetItemPossessor(oMyWeapon);

    if(GetIsObjectValid(oMyWeapon))
    {
        // Signal spell cast at.
        PHS_SignalSpellCastAt(oWeaponPossessor, PHS_SPELL_DISRUPTING_WEAPON, FALSE);

        // haaaack: store caster level on item for the on hit spell to work properly
        PHS_ApplyDurationAndVFX(oWeaponPossessor, eVis, eCessate, fDuration);
        AddDisruptEffectToWeapon(oMyWeapon, fDuration, nCasterLevel);
        SetLocalInt(oMyWeapon, "PHS_DISRUPTING_WEAPON_DC", nSpellSaveDC);
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
