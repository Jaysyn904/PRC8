//::///////////////////////////////////////////////
//:: Holy Aura
//:: NW_S0_HolyAura.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The cleric casting this spell gains +4 AC and
    +4 to saves. Is immune to Mind-Affecting Spells
    used by evil creatures and gains an SR of 25
    versus the spells of Evil Creatures
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 28, 2001
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
    //--------------------------------------------------------------------------
    // GZ: Make sure this aura is only active once
    //--------------------------------------------------------------------------
    PRCRemoveSpellEffects(GetSpellId(),OBJECT_SELF,PRCGetSpellTargetObject());

    //Declare major variables
    object oTarget = PRCGetSpellTargetObject();
    int nDuration = 10;

    effect eVis = EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MAJOR);
    effect eAC = EffectACIncrease(4, AC_DEFLECTION_BONUS);
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 4);
    effect eImmune = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
    effect eSR = EffectSpellResistanceIncrease(25);
    effect eDur = EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MAJOR);
    effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eEvil = EffectDamageShield(6, DAMAGE_BONUS_1d8, DAMAGE_TYPE_DIVINE);

    // * make them versus the alignment
    eImmune = VersusAlignmentEffect(eImmune, ALIGNMENT_ALL, ALIGNMENT_EVIL);
    eSR = VersusAlignmentEffect(eSR,ALIGNMENT_ALL, ALIGNMENT_EVIL);
    eAC =  VersusAlignmentEffect(eAC,ALIGNMENT_ALL, ALIGNMENT_EVIL);
    eSave = VersusAlignmentEffect(eSave,ALIGNMENT_ALL, ALIGNMENT_EVIL);
    eEvil = VersusAlignmentEffect(eEvil,ALIGNMENT_ALL, ALIGNMENT_EVIL);

    // * make them versus the racial type
    eImmune = VersusRacialTypeEffect(eImmune, RACIAL_TYPE_OUTSIDER);
    eSR = VersusRacialTypeEffect(eSR, RACIAL_TYPE_OUTSIDER);
    eAC =  VersusRacialTypeEffect(eAC, RACIAL_TYPE_OUTSIDER);
    eSave = VersusRacialTypeEffect(eSave, RACIAL_TYPE_OUTSIDER);
    eEvil = VersusRacialTypeEffect(eEvil, RACIAL_TYPE_OUTSIDER);

    //Link effects
    effect eLink = EffectLinkEffects(eImmune, eSave);
    eLink = EffectLinkEffects(eLink, eAC);
    eLink = EffectLinkEffects(eLink, eSR);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eDur2);
    eLink = EffectLinkEffects(eLink, eEvil);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
}

