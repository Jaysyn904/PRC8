/*:://////////////////////////////////////////////
//:: Spell Name Disrupting Weapon: On Hit
//:: Spell FileName PHS_S_DisruptWpA
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

    This will:
    - Check caster item (jsut in case)
    - declare only what is needed when, to save some CPU time.
    - Get the caster level of the item being cast, the DC is set on the weapon itself
    - Make sure they are Undead, not immune to spells and under our HD.
    - Get spell save DC
    - Do the will save
    - Kill it (CurrentHP + 10 damage, divine) (um, only if they fail the save!).
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // On hit part of the spell.
    // This needs to make sure it was an item that calls it.
    object oItem = GetSpellCastItem();
    if(!GetIsObjectValid(oItem)) return;

    // Declare major variables
    object oTarget = GetSpellTargetObject(); // Should be object self.
    // We use the base GetCasterLevel(OBJECT_SELF) to get the item's caster stuff.
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);

    // Check HD, Racial type and Immunity to spells
    if(GetHitDice(oTarget) <= nCasterLevel &&
       GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD &&
    // Make sure they are not immune to spells
       !PHS_TotalSpellImmunity(oTarget))
    {
        // We get the spell save DC off the item being used to attack!
        int nSpellSaveDC = GetLocalInt(oItem, "PHS_DISRUPTING_WEAPON_DC");

        // If they fail a will save...
        if(!WillSave(oTarget, nSpellSaveDC))
        {
            // Declare effects
            effect eVis = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_HOLY);
            // Apply death effect.
            PHS_ApplyDeathByDamageAndVFX(oTarget, eVis, DAMAGE_TYPE_POSITIVE);
        }
    }
}
