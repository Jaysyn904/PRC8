/*:://////////////////////////////////////////////
//:: Spell Name Mirage Arcana
//:: Spell FileName PHS_S_MirageArc
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Illusion (Glamer)
    Level: Brd 5, Sor/Wiz 5
    Components: V, S
    Casting Time: 1 standard action
    Range: Long (40M)
    Area: Up to a 20x20 meter cube area (S)
    Duration: 2 hour/ level (D)
    Saving Throw: Will disbelief (if area is entered)
    Spell Resistance: No

    This spell functions like hallucinatory terrain, except that it enables you
    to make any area appear to be something other than it is. Unlike
    hallucinatory terrain, the spell can add the appearance of structures.
    Still, it can’t disguise, conceal, or add creatures (though creatures
    within the area might hide themselves within the illusion just as they can
    hide themselves within a real location).

    Material Component: A stone, a twig, and a bit of green plant.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    It has a special (hidden!) Will Save for this spell, when they enter in the
    area and stay in for a cirtain number of rounds.

    Choose the terrain from a preset list. Bioware's "tilemagic" is what is used,
    IE the visual effect is a terrain piece.

    The AOE is placed via. the use of a placeable, which also has the correct
    visual applied to it.

    Mirage Arcaner has bigger AOE (or possibly bigger) and can do structures.

    It also was "concentration + 1 hour/level" but made just to the same
    as the other terrain one - 2 hours/level.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_MIRAGE_ARCANA)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oArea = GetArea(oCaster);
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Duration in hours
    float fDuration = PHS_GetDuration(PHS_HOURS, nCasterLevel * 2, nMetaMagic);

    // Centre lTarget to the nearest centre of a tile - which is going to be,
    // say, like 5M in, 5M up.
    vector vPosition = GetPositionFromLocation(lTarget);
    float fX = vPosition.x;
    float fY = vPosition.y;
    float fZ = vPosition.z; // Keep the same

    // Get area side size
    float fAreaSize = (GetPosition(oArea).x * 2.0);

    // We round X and Y to the nearest 5M.
    // Round to the neareat 10, then add 5.
    int nX10 = FloatToInt(fX/10);
    // So final X is the integer (rounded) value, add 5
    fX = (IntToFloat(nX10) * 10) + 5.0;

    // We round X and Y to the nearest 5M.
    // Round to the neareat 10, then add 5.
    int nY10 = FloatToInt(fY/10);
    // So final X is the integer (rounded) value, add 5
    fY = (IntToFloat(nY10) * 10) + 5.0;

    // If either are over the area size, we must go down.
    if(fX > fAreaSize)
    {
        fX = fAreaSize - 5.0;
    }
    if(fY > fAreaSize)
    {
        fY = fAreaSize - 5.0;
    }

    location lNewTarget = Location(oArea, Vector(fX, fY, fZ), GetFacing(oCaster));

    // Create the placeable to apply the effects too
    object oTerrain = CreateObject(OBJECT_TYPE_PLACEABLE, "phs_miragearcana", lNewTarget);

    // Get VFX to use for the terrain
    int nVFX = GetLocalInt(oCaster, "PHS_HALLUCINATORY_TERRAIN_VFX");

    if(nVFX <= 0)
    {
        nVFX = SCENE_TOWER;
    }

    // Declare effects
    effect eAOE = EffectAreaOfEffect(PHS_AOE_MOB_MIRAGE_ARCANA);
    effect eDur = EffectVisualEffect(nVFX);

    // Apply effects
    PHS_ApplyDuration(oTerrain, eAOE, fDuration);
    PHS_ApplyDuration(oTerrain, eDur, fDuration);
}
