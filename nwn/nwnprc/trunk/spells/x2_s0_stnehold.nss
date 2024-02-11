//::///////////////////////////////////////////////
//:: Stonehold
//:: X2_S0_Stnehold
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates an area of effect that will cover the
    creature with a stone shell holding them in
    place.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: December 03, 2002
//:://////////////////////////////////////////////
//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    //Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = PRCGetSpellTargetLocation();
    int nCasterLvl = PRCGetCasterLevel(oCaster);
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nAoE = AOE_PER_STONEHOLD;
    if(nCasterLvl < 1)
        nCasterLvl = 1;

    float fDuration = RoundsToSeconds(nCasterLvl);
    //Make metamagic check for extend
    if(nMetaMagic & METAMAGIC_EXTEND)
        fDuration *= 2;   //Duration is +100%

    //Create the AOE object at the selected location
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_NATURE), lTarget);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectAreaOfEffect(nAoE), lTarget, fDuration);

    //Setup Area Of Effect object
    object oAoE = GetAreaOfEffectObject(lTarget, "VFX_PER_STONEHOLD");
    SetAllAoEInts(SPELL_STONEHOLD, oAoE, PRCGetSpellSaveDC(SPELL_STONEHOLD, SPELL_SCHOOL_CONJURATION), 0, nCasterLvl);

    PRCSetSchool();
}