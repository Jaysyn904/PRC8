/*:://////////////////////////////////////////////
//:: Spell Name Forcecage
//:: Spell FileName PHS_S_Forcecage
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Forcecage
    Evocation [Force]
    Level: Sor/Wiz 7
    Components: V, S, M
    Casting Time: 1 standard action
    Range: Close (8M)
    Area: Barred cage (6.67-M. cube)
    Duration: 2 hours/level (D)
    Saving Throw: None
    Spell Resistance: No

    This powerful spell brings into being an immobile cubical prison composed of
    either bars of force.

    Creatures within the area are caught and contained unless they are too big to
    fit inside, in which case the spell automatically fails. Teleportation and
    other forms of astral travel provide a means of escape, but the force walls
    or bars extend into the Ethereal Plane, blocking ethereal travel.

    Like a wall of force spell, a forcecage resists dispel magic, but it is
    vulnerable to a disintegrate spell, and it can be destroyed by a sphere of
    annihilation or a rod of cancellation.

    This spell produces a 6.67-meter cube made of bands of force (similar to a
    wall of force spell) for bars. The bands are a half-inch wide, with half-inch
    gaps between them. Creatures are confined within the space. You can’t attack
    a creature in a barred cage with a weapon unless the weapon can fit between
    the gaps (No melee weapons will reach inside). Even against such weapons
    (including arrows and similar ranged attacks), a creature in the barred cage
    has cover. All spells and breath weapons can pass through the gaps in the
    bars.

    Material Component: Ruby dust worth 1,500 gp, which is tossed into the air
    and disappears when you cast the spell.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Needs 4 placeables for the bars, and an AOE within the centre of it. If
    any of the bars are destroyed (via. disintegration ETC), it means the entire
    spell collapses.

    The AOE is plotted too, and does the correct 50% vs ranged attack consealment
    as they will have to shoot through the bars.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_FORCECAGE)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    object oArea = GetArea(oCaster);

    // Requires ruby dust of at least 1500 gp value
    if(!PHS_ComponentExactItemRemove(PHS_ITEM_RUBY_DUST_1500, "Ruby dust worth at least 1500 gp", "Forcecage")) return;

    // Duration - 2 hours/level
    float fDuration = PHS_GetDuration(PHS_HOURS, nCasterLevel * 2, nMetaMagic);

    // Declare effects
    effect eAOE = EffectAreaOfEffect(PHS_AOE_PER_FORCECAGE);
    // Impact VFX
    effect eImpact = EffectVisualEffect(PHS_VFX_FNF_FORCECAGE);

    // We create the barriers!
    // - Set the barriers on the caster so the AOE can grab them on its first
    //   OnEnter pass.
    string sResRef = "phs_forcewall";
    object oForceWall;
    // Get vectors to change
    vector vOriginal = GetPositionFromLocation(lTarget);
    float fXDefault = vOriginal.x;
    float fYDefault = vOriginal.y;
    float fZDefault = vOriginal.z;
    // Distance from centre the placeable will go
    float fDist = 3.34;

    // First one: North of the target location by half of 6.68M (3.34M), north
    // with DIRECTION_NORTH facing. Add on 3.34 onto X only.
    location lPlaceable = Location(oArea, Vector(fXDefault + fDist, fYDefault, fZDefault), DIRECTION_NORTH);
    // Create and set North one.
    oForceWall = CreateObject(OBJECT_TYPE_PLACEABLE, sResRef, lPlaceable);
    SetLocalObject(oCaster, "PHS_FORCEWALL_WALL1", oForceWall);

    // DIRECTION_EAST one - go +3.34 in Y
    lPlaceable = Location(oArea, Vector(fXDefault, fYDefault + fDist, fZDefault), DIRECTION_EAST);
    oForceWall = CreateObject(OBJECT_TYPE_PLACEABLE, sResRef, lPlaceable);
    SetLocalObject(oCaster, "PHS_FORCEWALL_WALL2", oForceWall);

    // DIRECTION_SOUTH one - go -3.34 in X
    lPlaceable = Location(oArea, Vector(fXDefault - fDist, fYDefault, fZDefault), DIRECTION_SOUTH);
    oForceWall = CreateObject(OBJECT_TYPE_PLACEABLE, sResRef, lPlaceable);
    SetLocalObject(oCaster, "PHS_FORCEWALL_WALL3", oForceWall);

    // DIRECTION_WEST one - go -3.34 in Y
    lPlaceable = Location(oArea, Vector(fXDefault, fYDefault + fDist, fZDefault), DIRECTION_WEST);
    oForceWall = CreateObject(OBJECT_TYPE_PLACEABLE, sResRef, lPlaceable);
    SetLocalObject(oCaster, "PHS_FORCEWALL_WALL4", oForceWall);

    // Apply effects
    PHS_ApplyLocationDurationAndVFX(lTarget, eImpact, eAOE, fDuration);
}
