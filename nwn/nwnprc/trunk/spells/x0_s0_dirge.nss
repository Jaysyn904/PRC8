//::///////////////////////////////////////////////
//:: Dirge
//:: x0_s0_dirge.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All creatures within the AoE take 2 points of Strength
    and Dexterity ability score damage.
    Lasts 1 round/level
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
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_EVOCATION);

    //Declare major variables including Area of Effect Object
    object oCaster = OBJECT_SELF;
    location lTarget = GetLocation(oCaster);
    int nCasterLvl = PRCGetCasterLevel(oCaster);
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nAoE = AOE_MOB_CIRCGOOD;

    //Make sure duration does no equal 0
    if(nCasterLvl < 1)
        nCasterLvl = 1;

    float fDuration = RoundsToSeconds(nCasterLvl);
    //Check Extend metamagic feat.
    if(nMetaMagic & METAMAGIC_EXTEND)
       fDuration *= 2;    //Duration is +100%

    //change from AOE_PER_FOGMIND to AOE_MOB_CIRCGOOD
    effect eAOE = EffectAreaOfEffect(nAoE, "x0_s0_dirgeEN", "x0_s0_dirgeHB", "x0_s0_dirgeEX");

    PRCRemoveEffectsFromSpell(oCaster, SPELL_DIRGE);

    //Fire cast spell at event for the target
    SignalEvent(oCaster, EventSpellCastAt(oCaster, SPELL_DIRGE, FALSE));

    //Create an instance of the AOE Object using the Apply Effect function
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oCaster, fDuration, TRUE, SPELL_DIRGE, nCasterLvl);
    //Apply the FNF to the spell location
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SOUND_BURST), lTarget);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(257), lTarget);

    //Setup Area Of Effect object
    object oAoE = GetAreaOfEffectObject(GetLocation(oCaster), GetAreaOfEffectTag(nAoE));
    SetAllAoEInts(SPELL_DIRGE, oAoE, PRCGetSpellSaveDC(SPELL_DIRGE, SPELL_SCHOOL_EVOCATION), 0, nCasterLvl);

    PRCSetSchool();
}