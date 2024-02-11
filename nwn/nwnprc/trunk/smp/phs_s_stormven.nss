/*:://////////////////////////////////////////////
//:: Spell Name Storm of Vengance
//:: Spell FileName PHS_S_StormVen
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Creates a storm, level 9,40M range, 120M AOE, and up to 10 rounds of concentration
    until finnished.

    On Enter: saving throw or deafened for 1d4x10 minutes.
    2nd round: Acid rain, 1d6 damage to everyone in AOE. No save.
    3rd round: 6 bolts of lightning. 6 enemies affected. 10d6 reflex electrcity.
    4th round: Hailstones, for 5d6 points of bludgeoning damage. No save.
    5th to 10th rounds: Speed reduced by 3/4ths, and 20% miss chance.

    No ranged attacks in the cloud. Spells cast within the area are disrupted unless
    the caster succeeds on a Concentration check against a DC equal to the storm
    of vengeance’s save DC + the level of the spell the caster is trying to cast.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As above, really!

    Concentration checks are made here in 2 second delay command heartbeats,
    which are checked for the integer each time in the heartbeat.

    If concentration is broken, the AOE is destroyed.

    Also note that only 1 AOE can be cast in an area. No overlapping.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check
    if(!PHS_SpellHookCheck(PHS_SPELL_STORM_OF_VENGEANCE)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = GetSpellTargetLocation();

    // We cannot actually cast it if it'll be in an exisiting AOE
    object oOtherAOE = GetNearestObjectByTag(PHS_AOE_TAG_PER_STORM_OF_VENGEANCE, oCaster, 1);
    object oArea = GetArea(oCaster);

    // check distance and validility
    if(GetIsObjectValid(oOtherAOE) &&
       GetDistanceBetweenLocations(GetLocation(oOtherAOE), lTarget) <= 120.0)
    {
        FloatingTextStringOnCreature("You cannot create another storm which overlaps with an exsisting one", oCaster, FALSE);
        return;
    }

    // Must be above ground, and outside, duh!
    if(GetIsAreaAboveGround(oArea) == AREA_UNDERGROUND ||
       GetIsAreaInterior(oArea))
    {
        FloatingTextStringOnCreature("You cannot cast Storm of Vengeance underground or inside!", oCaster, FALSE);
        return;
    }

    // Declare effects
    effect eAOE = EffectAreaOfEffect(PHS_AOE_PER_STORM_OF_VENGEANCE);
    effect eImpact = EffectVisualEffect(VFX_FNF_STORM);

    // Get 10 rounds worth of time
    float fDuration = RoundsToSeconds(10);

    // Apply AOE effects at location
    PHS_ApplyLocationDurationAndVFX(lTarget, eImpact, eAOE, fDuration);
}
