/*:://////////////////////////////////////////////
//:: Spell Name Imprisonment
//:: Spell FileName PHS_S_ImprisonC
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This is used, when a PC is in the area, it randomly does globes
    around the area to make it look pretty.

    Goes in the imprisonment area's on heartbeat.

    Change: Since it is just a sphere under the earth, uncommented the main
    of this script. Still will be useful for other things however (Planes!)
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_CONSTANTS"

// Creates a random globe effect at a random location (using oWP, as the
// center of the area)
void GlobeRandom(location lWP);

void main()
{
/*
    // Get WP
    object oWP = GetWaypointByTag(PHS_S_IMPRISONMENT_TARGET);

    // Get PC to target
    object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oWP);

    // If not valid, stop
    if(!GetIsObjectValid(oPC)) return;

    // Get WP location
    location lWP = GetLocation(oWP);

    // Do 6 of these each heartbeat
    GlobeRandom(lWP);
    GlobeRandom(lWP);
    GlobeRandom(lWP);
    GlobeRandom(lWP);
    GlobeRandom(lWP);
    GlobeRandom(lWP);
*/
}

// Creates a random globe effect at a random location (using oWP, as the
// center of the area)
void GlobeRandom(location lWP)
{
    // Get a random location around lWP
    // The area is 40x40, so we want a random point up to 20M from the location.
    vector vOld = GetPositionFromLocation(lWP);
    // X and Y are randomly 20M from the centre.
    float fNewX = vOld.x + IntToFloat(Random(40) - 20);
    float fNewY = vOld.y + IntToFloat(Random(40) - 20);
    // Z - it will be 1 to 6 meters
    float fNewZ = vOld.z + IntToFloat(d6());
    vector vNew = Vector(fNewX, fNewY, fNewZ);
    // Create new location
    location lGlobe = Location(OBJECT_SELF, vNew, 0.0);

    // Declare effects
    effect eGlobe = EffectVisualEffect(VFX_DUR_GLOBE_INVULNERABILITY);
    effect eUse = EffectVisualEffect(VFX_IMP_GLOBE_USE);
    float fRandom = IntToFloat(d6());
    float fDelay = 5.0;
    float fDelayRandom = fRandom + 3.4;

    // Apply Effects
    DelayCommand(fRandom, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eGlobe, lGlobe, fDelay));
    DelayCommand(fDelayRandom, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eUse, lGlobe));
}
