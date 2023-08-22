//::///////////////////////////////////////////////
//:: Blur
//:: sp_blur.nss
//:://////////////////////////////////////////////
/*
Illusion (Glamer)
Level:            Brd 2, Sor/Wiz 2
Components:       V
Casting Time:     1 standard action
Range:            Touch
Target:           Creature touched
Duration:         1 min./level (D)
Saving Throw:     Will negates (harmless)
Spell Resistance: Yes (harmless)


The subject’s outline appears blurred, shifting and wavering.
This distortion grants the subject concealment (20% miss chance).

A see invisibility spell does not counteract the blur effect, but
a true seeing spell does.

Opponents that cannot see the subject ignore the spell’s effect
(though fighting an unseen opponent carries penalties of its own).
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: August 20, 2004
//:://////////////////////////////////////////////

#include "prc_inc_sp_tch"
#include "prc_sp_func"

int DoSpell(object oCaster, object oTarget, int nCasterLvl)
{
    float fDuration = TurnsToSeconds(nCasterLvl);
    int nMetaMagic = PRCGetMetaMagicFeat();
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_ODD);

    effect eLink = EffectConcealment(20);
           eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_GLOW_GREY));
           eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));

    if(nMetaMagic & METAMAGIC_EXTEND)
        fDuration *= 2;

    // Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_BLUR, FALSE));

    // Remove previous castings
    PRCRemoveEffectsFromSpell(oTarget, SPELL_BLUR);

    // Apply the bonuses and the VFX impact
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, SPELL_BLUR, nCasterLvl);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

    return TRUE;// return TRUE if spell charges should be decremented
}

void main()
{
    if (!X2PreSpellCastCode()) return;
    PRCSetSchool(SPELL_SCHOOL_ILLUSION);
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)
        {
            //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges
            return;
        }
        DoSpell(oCaster, oTarget, nCasterLevel);
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            if(DoSpell(oCaster, oTarget, nCasterLevel))
            DecrementSpellCharges(oCaster);
        }
    }
    PRCSetSchool();
}