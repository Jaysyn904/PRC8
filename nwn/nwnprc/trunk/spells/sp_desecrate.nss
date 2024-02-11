//::///////////////////////////////////////////////
//:: Desecrate
//:: sp_desecrate.nss
//:: //////////////////////////////////////////////
/*
Evocation [Evil]
Level: Cleric 2, Divine Bard 2, Death Master 2, Blighter 3, Evil 2, Undeath 2,
Components: V, S, M, DF,
Casting Time: 1 standard action
Range: Close (25 ft. + 5 ft./2 levels)
Area: 20-ft.-radius emanation
Duration: 2 hours/level
Saving Throw: None
Spell Resistance: Yes

This spell imbues an area with negative energy.

Each Charisma check made to turn undead within this area takes a -3 profane penalty, and every undead creature entering a desecrated area gains a +1 profane bonus on attack rolls, damage rolls, and saving throws.

An undead creature created within or summoned into such an area gains +1 hit points per HD.

Furthermore, anyone who casts animate dead within this area may create as many as double the normal amount of undead (that is, 4 HD per caster level rather than 2 HD per caster level).

Desecrate counters and dispels consecrate.

Material Component: A vial of unholy water and 25 gp worth (5 pounds) of silver dust, all of which must be sprinkled around the area.
*/
//:: written by Stratovarius Jan 17, 2021

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
    string sTag = Get2DACache("vfx_persistent", "LABEL", AOE_PER_CONSECRATE);

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
            FloatingTextStringOnCreature("You feel the consecration come to an end.", oPC, FALSE);
            DestroyObject(oAoE);
            break;
        }
        oAoE = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(21.0), lLoc, FALSE, OBJECT_TYPE_AREA_OF_EFFECT);
    }

    if(!nDesecrate)
    {
        effect eAOE = EffectAreaOfEffect(AOE_MOB_DES_20, "prc_tn_des_a", "", "prc_tn_des_b");

        //Create AoE
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lLoc, fDuration);
        effect eVis = EffectVisualEffect(VFX_TN_DES_20);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, lLoc, fDuration);        

        oAoE = GetAreaOfEffectObject(lLoc, "VFX_AOE_DESECRATE_20");
        SetAllAoEInts(SPELL_CONSECRATE, oAoE, 20, 0, nCastLvl);
    }

    PRCSetSchool();
}