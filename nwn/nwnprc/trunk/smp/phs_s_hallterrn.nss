/*:://////////////////////////////////////////////
//:: Spell Name Hallucinatory Terrain
//:: Spell FileName PHS_S_HallTerrn
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Illusion (Glamer)
    Level: Brd 4, Sor/Wiz 4
    Components: V, S, M
    Casting Time: 10 minutes
    Range: Long (40M)
    Area: One 10M cube area (S)
    Duration: 2 hours/level (D)
    Saving Throw: Will disbelief (if area is entered)
    Spell Resistance: No

    You make natural terrain look, sound, and smell like some other sort of
    natural terrain, chosen beforehand, which overlays ontop of the exsisting
    item. Structures, equipment, and creatures within the area are not hidden
    or changed in appearance, nor covered if they jut out of the illusion.

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
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_HALLUCINATORY_TERRAIN)) return;

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
    object oTerrain = CreateObject(OBJECT_TYPE_PLACEABLE, "phs_hallterrain", lNewTarget);

    // Get VFX to use for the terrain
    int nVFX = GetLocalInt(oCaster, "PHS_HALLUCINATORY_TERRAIN_VFX");

    if(nVFX <= 0)
    {
        nVFX = SCENE_TOWER;
    }

    // Declare effects
    effect eAOE = EffectAreaOfEffect(PHS_AOE_MOB_HALLUCINATORY_TERRAIN);
    effect eDur = EffectVisualEffect(nVFX);

    // Apply effects
    PHS_ApplyDuration(oTerrain, eAOE, fDuration);
    PHS_ApplyDuration(oTerrain, eDur, fDuration);
}
