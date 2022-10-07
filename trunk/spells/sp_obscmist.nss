//::///////////////////////////////////////////////
//:: Obscuring Mist
//:: sp_obscmist.nss
//:://////////////////////////////////////////////
/*
Conjuration (Creation)
Level:            Air 1, Clr 1, Drd 1, Sor/Wiz 1,
                  Water 1
Components:       V, S
Casting Time:     1 standard action
Range:            20 ft.
Effect:           Cloud spreads in 20-ft. radius
                  from you, 20 ft. high
Duration:         1 min./level
Saving Throw:     None
Spell Resistance: No

A misty vapor arises around you. It is stationary
once created. The vapor obscures all sight,
including darkvision, beyond 5 feet. A creature
5 feet away has concealment (attacks have a 20%
miss chance). Creatures farther away have total
concealment (50% miss chance, and the attacker
cannot use sight to locate the target).

A moderate wind (11+ mph), such as from a gust of
wind spell, disperses the fog in 4 rounds. A
strong wind (21+ mph) disperses the fog in 1 round.
A fireball, flame strike, or similar spell burns
away the fog in the explosive or fiery spell’s
area. A wall of fire burns away the fog in the
area into which it deals damage.

This spell does not function underwater.

*/
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    //Declare major variables, including the Area of Effect object.
    object oCaster = OBJECT_SELF;
    location lTarget = GetLocation(oCaster);
    effect eAOE = EffectAreaOfEffect(AOE_PER_OBSCURING_MIST);
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nMetaMagic = PRCGetMetaMagicFeat();
    float fDuration = TurnsToSeconds(nCasterLevel);
    //Check for metamagic extend
    if(nMetaMagic & METAMAGIC_EXTEND)
        fDuration *= 2;   //Duration is +100%

    //Create the object at the location so that the objects scripts will start working.
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, fDuration);

    object oAoE = GetAreaOfEffectObject(lTarget, "VFX_PER_OBSCURING_MIST");
    SetAllAoEInts(SPELL_OBSCURING_MIST, oAoE, 20, 0, nCasterLevel);

    PRCSetSchool();
}