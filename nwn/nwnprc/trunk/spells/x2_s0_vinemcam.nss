//::///////////////////////////////////////////////
//:: Vine Mine, Camouflage
//:: X2_S0_VineMCam
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Area of effect spell that places concealment
  bonus of +4 on all friendly creatures.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 25, 2002
//:://////////////////////////////////////////////

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_inc_spells"

#include "prc_add_spell_dc"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);
/*
  Spellcast Hook Code
  Added 2003-07-07 by Georg Zoeller
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(40);
    location lTarget = PRCGetSpellTargetLocation();
    int nCasterLvl = PRCGetCasterLevel();
    int nDuration = nCasterLvl * 10;
    //Make sure duration does no equal 0
    if (nDuration < 1)
    {
        nDuration = 1;
    }
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));

    object oAoE = GetAreaOfEffectObject(lTarget, "VFX_PER_CAMOUFLAGE");
    SetAllAoEInts(SPELL_VINE_MINE_CAMOUFLAGE, oAoE, PRCGetSpellSaveDC(SPELL_VINE_MINE_CAMOUFLAGE, SPELL_SCHOOL_CONJURATION), 0, nCasterLvl);

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}

