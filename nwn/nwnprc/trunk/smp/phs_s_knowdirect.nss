/*:://////////////////////////////////////////////
//:: Spell Name Know Direction
//:: Spell FileName PHS_S_KnowDirect
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Divination
    Level: Brd 0, Drd 0
    Components: V, S
    Casting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: Instantaneous

    You instantly know the direction of north from your current position by a
    flame flaring at the position just north of you.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Just tells them where north is - in degrees, from thier current facing.

    Yes, there is a compass...and a map...but this is for RP.
    It will check facing, and state the direction.

    Added a small visual effect too, which makes the spell better :-D
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"


void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_KNOW_DIRECTION)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    vector vCasterVector = GetPosition(oCaster);
    object oCasterArea = GetArea(oCaster);
    float fCasterFacing = GetFacing(OBJECT_SELF);

    // Get the current facing of the person.
    float fFacing = GetFacing(oCaster);
    /* 1800 = west, so 90 is north, 0 is east and 270 is south
          90
      180     0
          270
    */
    // We make a small visual effect at the place north of the caster.
    effect eImpact = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_NATURE);

    // We get 1 meter north of the caster.
    float fNewY = vCasterVector.y + 1.0;
    vector vNorthPosition = Vector(vCasterVector.x, fNewY, vCasterVector.z);

    // Set final location for the visual effect - The orientation shouldn't matter.
    location lNorth = Location(oCasterArea, vNorthPosition, DIRECTION_NORTH);

    // Apply visual effect.
    PHS_ApplyLocationVFX(lNorth, eImpact);

    // Fire spell cast at event
    PHS_SignalSpellCastAt(oCaster, PHS_SPELL_KNOW_DIRECTION, FALSE);

    // We set our facing to north as an action
    // * May remove
    ClearAllActions();
    SetFacing(DIRECTION_NORTH);
}
