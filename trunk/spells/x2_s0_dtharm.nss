//::///////////////////////////////////////////////
//:: Death Armor
//:: X2_S0_DthArm
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    You are surrounded with a magical aura that injures
    creatures that contact it. Any creature striking
    you with its body or handheld weapon takes 1d4 points
    of damage +1 point per 2 caster levels (maximum +5).
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Jan 6, 2003
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs, 02/06/2003
//:: 2003-07-07: Stacking Spell Pass, Georg Zoeller

//:: modified by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_inc_spells"
//#include "prc_add_spell_dc"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_NECROMANCY);

    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();

    int nDuration = PRCGetCasterLevel(oCaster);
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nCasterLvl = nDuration/2;
    if(nCasterLvl > 5)
        nCasterLvl = 5;

    effect eLink = EffectDamageShield(nCasterLvl, DAMAGE_BONUS_1d4, DAMAGE_TYPE_MAGICAL);
           eLink = EffectLinkEffects(eLink, EffectVisualEffect(463));

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_DEATH_ARMOR, FALSE));

    //Enter Metamagic conditions
    if(nMetaMagic & METAMAGIC_EXTEND)
        nDuration *= 2;

    //Stacking Spellpass, 2003-07-07, Georg
    PRCRemoveEffectsFromSpell(oTarget, SPELL_DEATH_ARMOR);

    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));

    PRCSetSchool();
}