//::///////////////////////////////////////////////
//:: Battletide
//:: X2_S0_BattTide
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    You create an aura that steals energy from your
    enemies. Your enemies suffer a -2 circumstance
    penalty on saves, attack rolls, and damage rolls,
    once entering the aura. On casting, you gain a
    +2 circumstance bonus to your saves, attack rolls,
    and damage rolls.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Dec 04, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs 06/06/03
//:: modified by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    if (!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);

    //Declare major variables
    object oCaster = OBJECT_SELF;
    int nCasterLvl = PRCGetCasterLevel(oCaster);
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nAOE = AOE_MOB_TIDE_OF_BATTLE;

    //Make nDuration at least 1 round.
    if (nCasterLvl < 1)
        nCasterLvl = 1;
    float fDuration = RoundsToSeconds(nCasterLvl);

    //Make metamagic check for extend
    if(nMetaMagic & METAMAGIC_EXTEND)
        fDuration *= 2;   //Duration is +100%

    effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);
    effect eLink = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2);
           eLink = EffectLinkEffects(eLink, EffectDamageIncrease(2));
           eLink = EffectLinkEffects(eLink, EffectAttackIncrease(2));
           eLink = EffectLinkEffects(eLink, EffectAreaOfEffect(nAOE));
           eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));

    SignalEvent(oCaster, EventSpellCastAt(oCaster, SPELL_BATTLETIDE, FALSE));

    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, fDuration, TRUE, SPELL_BATTLETIDE, nCasterLvl);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oCaster);

    //Setup Area Of Effect object
    object oAoE = GetAreaOfEffectObject(GetLocation(oCaster), "VFX_MOB_BATTLETIDE");
    SetAllAoEInts(SPELL_BATTLETIDE, oAoE, PRCGetSpellSaveDC(SPELL_BATTLETIDE, SPELL_SCHOOL_TRANSMUTATION), 0, nCasterLvl);

    PRCSetSchool();
}