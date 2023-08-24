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

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "prc_inc_spells"


//::///////////////////////////////////////////////
//:: PRCDoAura
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Used in the Alignment aura - unholy and holy
    aura scripts fromthe original campaign
    spells. Cleaned them up to be consistent.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void PRCDoAura(int nAlign, int nVis1, int nVis2, int nDamageType)
{
    //Declare major variables
    object oTarget = PRCGetSpellTargetObject();
    int nDuration = PRCGetCasterLevel(OBJECT_SELF);

    effect eVis = EffectVisualEffect(nVis1);
    effect eAC = EffectACIncrease(4, AC_DEFLECTION_BONUS);
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 4);
    //Change the effects so that it only applies when the target is evil
    effect eImmune = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
    effect eSR = EffectSpellResistanceIncrease(25); //Check if this is a bonus or a setting.
    effect eDur = EffectVisualEffect(nVis2);
    effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eEvil = EffectDamageShield(6, DAMAGE_BONUS_1d8, nDamageType);


    // * make them versus the alignment

    eImmune = VersusAlignmentEffect(eImmune, ALIGNMENT_ALL, nAlign);
    eSR = VersusAlignmentEffect(eSR,ALIGNMENT_ALL, nAlign);
    eAC =  VersusAlignmentEffect(eAC,ALIGNMENT_ALL, nAlign);
    eSave = VersusAlignmentEffect(eSave,ALIGNMENT_ALL, nAlign);
    eEvil = VersusAlignmentEffect(eEvil,ALIGNMENT_ALL, nAlign);


    //Link effects
    effect eLink = EffectLinkEffects(eImmune, eSave);
    eLink = EffectLinkEffects(eLink, eAC);
    eLink = EffectLinkEffects(eLink, eSR);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eDur2);
    eLink = EffectLinkEffects(eLink, eEvil);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, PRCGetSpellId(), FALSE));

    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
}


void main()
{

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);

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


    //--------------------------------------------------------------------------
    // GZ: Make sure this aura is only active once
    //--------------------------------------------------------------------------
    PRCRemoveSpellEffects(GetSpellId(),OBJECT_SELF,PRCGetSpellTargetObject());


    PRCDoAura(ALIGNMENT_EVIL, VFX_DUR_PROTECTION_GOOD_MAJOR, VFX_DUR_PROTECTION_GOOD_MAJOR, DAMAGE_TYPE_DIVINE);


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}

