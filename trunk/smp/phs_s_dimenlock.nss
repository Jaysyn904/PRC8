/*:://////////////////////////////////////////////
//:: Spell Name Dimensional Lock
//:: Spell FileName PHS_S_Dimenlock
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Dimensional Lock
    Abjuration
    Level: Clr 8, Sor/Wiz 8
    Components: V, S
    Casting Time: 1 standard action
    Range: Medium (20M)
    Area: Huge AOE Radius (6.6M)
    Duration: One day/level
    Saving Throw: None
    Spell Resistance: Yes

    You create a shimmering emerald barrier that completely blocks
    extradimensional travel. Forms of movement barred include astral projection,
    blink, dimension door, ethereal jaunt, etherealness, gate, maze,
    plane shift, shadow walk, teleport, and similar spell-like or psionic
    abilities. Once dimensional lock is in place, extradimensional travel into
    or out of the area affected is not possible.

    A dimensional lock does not interfere with the movement of creatures already
    in ethereal or astral form when the spell is cast, nor does it block
    extradimensional perception or attack forms. Also, the spell does not
    prevent summoned creatures from disappearing at the end of a summoning
    spell.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    AOE and checked in PHS_GetDimensionalAnchor and PHS_CannotTeleport.

    Visual effect only applied.

    It is for 1 day/level...but this might not be wise. It can stay that way
    for now - it is a level 8 spell!!!
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_DIMENSIONAL_LOCK)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Duration is 1 day/level, therefore it is 24 hours/level
    float fDuration = PHS_GetDuration(PHS_HOURS, nCasterLevel * 24, nMetaMagic);

    // Declare effects
    effect eAOE = EffectAreaOfEffect(PHS_AOE_PER_DIMENSIONAL_LOCK);

    // Apply effects
    PHS_ApplyLocationDuration(lTarget, eAOE, fDuration);
}
