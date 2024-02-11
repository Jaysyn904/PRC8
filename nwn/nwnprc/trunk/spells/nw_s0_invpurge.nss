//::///////////////////////////////////////////////
//:: Invisibility Purge
//:: NW_S0_InvPurge.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All invisible creatures become invisible in the
    area of effect even if they leave the AOE.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "prc_inc_spells"  

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_EVOCATION);

    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(35);
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nDuration = CasterLvl;
    int nMetaMagic = PRCGetMetaMagicFeat();
    effect eDur1 = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);
    effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eDur1, eDur2);

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
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, OBJECT_SELF, TurnsToSeconds(nDuration),TRUE,-1,CasterLvl);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, TurnsToSeconds(nDuration));

    object oAoE = GetAreaOfEffectObject(GetLocation(OBJECT_SELF), "VFX_MOB_INVISIBILITY_PURGE");
    SetAllAoEInts(SPELL_INVISIBILITY_PURGE, oAoE, 10, 0, CasterLvl);

    PRCSetSchool();
}