//::///////////////////////////////////////////////
//:: Consecrate
//:: sp_consecrate.nss
//:: //////////////////////////////////////////////
/*
Evocation [Good]
Level:            Clr 2
Components:       V, S, M, DF
Casting Time:     1 standard action
Range:            Close (25 ft. + 5 ft./2 levels)
Area:             20-ft.-radius emanation
Duration:         2 hours/level
Saving Throw:     None
Spell Resistance: No


This spell blesses an area with positive energy.
Each Charisma check made to turn undead within this
area gains a +3 sacred bonus. Every undead creature
entering a consecrated area suffers minor disruption,
giving it a -1 penalty on attack rolls, damage rolls,
and saves. Undead cannot be created within or
summoned into a consecrated area.

If the consecrated area contains an altar, shrine,
or other permanent fixture dedicated to your deity,
pantheon, or aligned higher power, the modifiers
given above are doubled (+6 sacred bonus on turning
checks, -2 penalties for undead in the area). You
cannot consecrate an area with a similar fixture of
a deity other than your own patron.

If the area does contain an altar, shrine, or other
permanent fixture of a deity, pantheon, or higher
power other than your patron, the consecrate spell
instead curses the area, cutting off its connection
with the associated deity or power. This secondary
function, if used, does not also grant the bonuses
and penalties relating to undead, as given above.

Consecrate counters and dispels desecrate.

Material Component
A vial of holy water and 25 gp worth (5 pounds) of
silver dust, all of which must be sprinkled around
the area.
*/
//:://////////////////////////////////////////////
//:: Created By: Soultaker
//:: Created On: ??????
//:://////////////////////////////////////////////

//:: rewritten by Tenjac  Sep 17, 2008 for correct functioning
#include "prc_inc_spells"

void main()
{
    PRCSetSchool(SPELL_SCHOOL_EVOCATION);
    if (!X2PreSpellCastCode()) return;

    //Declare major variables including Area of Effect Object
    object oPC = OBJECT_SELF;
    location lLoc = PRCGetSpellTargetLocation();
    int nCastLvl = PRCGetCasterLevel(oPC);
    float fDuration = HoursToSeconds(2 * nCastLvl);
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nDesecrate;
    string sTag = Get2DACache("vfx_persistent", "LABEL", AOE_PER_DESECRATE); //111 is Desecrate

    //Make sure duration does no equal 0
    if(fDuration < 2.0)
        fDuration = 2.0;

    //Check Extend metamagic feat.
    if(nMetaMagic & METAMAGIC_EXTEND)
        fDuration *= 2;

    //If within area of Desecrate
    object oAoE = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(21.0), lLoc, FALSE, OBJECT_TYPE_AREA_OF_EFFECT);
    while(GetIsObjectValid(oAoE))
    {
        //if it is Desecrate
        if(GetTag(oAoE) == sTag)
        {
            nDesecrate = 1;
            FloatingTextStringOnCreature("You feel the desecration come to an end.", oPC, FALSE);
            DestroyObject(oAoE);
            break;
        }
        oAoE = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(21.0), lLoc, FALSE, OBJECT_TYPE_AREA_OF_EFFECT);
    }

    if(!nDesecrate)
    {
        effect eAOE = EffectAreaOfEffect(AOE_PER_CONSECRATE);

        //Create AoE
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lLoc, fDuration);

        object oAoE = GetAreaOfEffectObject(lLoc, "VFX_AOE_CONSECRATE_20");
        SetAllAoEInts(SPELL_CONSECRATE, oAoE, 20, 0, nCastLvl);
    }

    PRCSetSchool();
}