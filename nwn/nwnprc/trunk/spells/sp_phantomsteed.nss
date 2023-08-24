/*
Phantom Steed
Conjuration (Creation)
Level: Bard 3, Sorc/Wiz 3, Knight of the Weave 3
Components: V, S
Range: Personal
Effect: One quasi-real, horselike creature
Duration: 1 hour/level (D)
Saving Throw: None
Spell Resistance: No

You summon a horse equal to a paladin's mount
*/

#include "prc_inc_spells"
#include "x3_inc_horse"

void main()
{
    PRCSetSchool(SPELL_SCHOOL_CONJURATION);
    if (!X2PreSpellCastCode())
        return;

    //Declare major variables
    object oPC     = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nDuration  = nCasterLvl;
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
        nDuration *= 2;

    object oMount = HorseGetPaladinMount(oPC);
    if (!GetIsObjectValid(oMount)) oMount = GetLocalObject(oPC, "oX3PaladinMount");
    // No duplicate mounts for sanity reasons
    if (GetIsObjectValid(oMount))
    {
        if (GetIsPC(oPC))
        {
            if (oMount == oPC) 
            	FloatingTextStrRefOnCreature(111987, oPC, FALSE);
            else 
            	FloatingTextStrRefOnCreature(111988, oPC, FALSE); 
        }
        return;
    }
    
     HorseSummonPhantomSteed(nCasterLvl, nDuration);

     PRCSetSchool();
}
