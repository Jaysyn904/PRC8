//::///////////////////////////////////////////////
//:: Spike Growth
//:: x0_s0_spikegro.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All creatures within the AoE take 1d4 points of damage
    every round.
    If you are in the area of the effect, you also get a 24 hour slow
    effect on you (will only add one)

    Lasts 1 hour/level
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 2002
//:://////////////////////////////////////////////

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
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
    // * passing dirge script for exit because it is an empty script (i.e., there is no special exit effects)
    effect eAOE = EffectAreaOfEffect(AOE_PER_ENTANGLE, "x0_s0_spikegroEN", "x0_s0_spikegroHB", "x0_s0_dirgeEX");
    location lTarget = PRCGetSpellTargetLocation();
    int nCasterLevel = PRCGetCasterLevel(OBJECT_SELF);
    int nDuration = nCasterLevel;
    int nMetaMagic = PRCGetMetaMagicFeat();
//    effect eImpact = EffectVisualEffect(257);
//    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);
    //Make sure duration does no equal 0
    if (nDuration < 1)
    {
        nDuration = 1;
    }
    //Check Extend metamagic feat.
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
       nDuration = nDuration *2;    //Duration is +100%
    }
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, HoursToSeconds(nDuration));

    object oAoE = GetAreaOfEffectObject(lTarget, "VFX_PER_ENTANGLE");
    SetAllAoEInts(SPELL_SPIKE_GROWTH, oAoE, PRCGetSpellSaveDC(SPELL_SPIKE_GROWTH, SPELL_SCHOOL_TRANSMUTATION), 0, nCasterLevel);

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school

}


