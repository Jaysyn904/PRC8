//::///////////////////////////////////////////////
//:: Invisibility Sphere
//:: NW_S0_InvSph.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All allies within 15ft are rendered invisible.
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

    PRCSetSchool(SPELL_SCHOOL_ILLUSION);

    //Declare major variables including Area of Effect Object
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLvl = PRCGetCasterLevel(oCaster);
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nAoE = AOE_PER_INVIS_SPHERE;

    //Make sure duration does no equal 0
    if(nCasterLvl < 1)
        nCasterLvl = 1;

    float fDuration = TurnsToSeconds(nCasterLvl);
    if(GetHasFeat(FEAT_INSIDIOUSMAGIC, oCaster))
       fDuration *= 2;
    if(nMetaMagic & METAMAGIC_EXTEND)
       fDuration *= 2;

    //Create an instance of the AOE Object using the Apply Effect function
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAreaOfEffect(nAoE), oTarget, fDuration, TRUE, SPELL_INVISIBILITY_SPHERE, nCasterLvl);

    //Setup Area Of Effect object
    object oAoE = GetAreaOfEffectObject(GetLocation(oTarget), "VFX_PER_INVIS_SPHERE");
    SetAllAoEInts(SPELL_INVISIBILITY_SPHERE, oAoE, 10, 0, nCasterLvl);

    PRCSetSchool();
}