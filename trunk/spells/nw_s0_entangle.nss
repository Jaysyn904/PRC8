//::///////////////////////////////////////////////
//:: Entangle
//:: NW_S0_Enangle
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Area of effect spell that places the entangled
  effect on enemies if they fail a saving throw
  each round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On:  Dec 12, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: July 31, 2001
//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);

    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_ENTANGLE);
    location lTarget = PRCGetSpellTargetLocation();
    int CasterLvl = PRCGetCasterLevel();
    int nDuration = 3 + CasterLvl / 2;
    int nMetaMagic = PRCGetMetaMagicFeat();
    //Make sure duration does no equal 0
    if(nDuration < 1)
        nDuration = 1;

    //Check Extend metamagic feat.
    if(nMetaMagic & METAMAGIC_EXTEND)
       nDuration *= 2;    //Duration is +100%

    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));

    object oAoE = GetAreaOfEffectObject(lTarget, "VFX_PER_ENTANGLE");
    SetAllAoEInts(SPELL_ENTANGLE, oAoE, PRCGetSpellSaveDC(SPELL_ENTANGLE, SPELL_SCHOOL_TRANSMUTATION), 0, CasterLvl);

    PRCSetSchool();
}

