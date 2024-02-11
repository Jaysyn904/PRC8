//::///////////////////////////////////////////////
//:: Mind Fog
//:: NW_S0_MindFog.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a bank of fog that lowers the Will save
    of all creatures within who fail a Will Save by
    -10.  Affect lasts for 2d6 rounds after leaving
    the fog
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 1, 2001
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_ENCHANTMENT);

    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_FOGMIND);
    location lTarget = PRCGetSpellTargetLocation();
    int CasterLvl = PRCGetCasterLevel();
    int nDuration = 2 + CasterLvl / 2;
    effect eImpact = EffectVisualEffect(262);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);
    int nMetaMagic = PRCGetMetaMagicFeat();
    //Check Extend metamagic feat.
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
       nDuration = nDuration *2;    //Duration is +100%
    }
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));

    object oAoE = GetAreaOfEffectObject(lTarget, "VFX_PER_FOGMIND");
    SetAllAoEInts(SPELL_MIND_FOG, oAoE, PRCGetSpellSaveDC(SPELL_MIND_FOG, SPELL_SCHOOL_ENCHANTMENT), 0, CasterLvl);

    PRCSetSchool();
}

