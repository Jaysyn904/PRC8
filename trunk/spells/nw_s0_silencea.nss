//::///////////////////////////////////////////////
//:: Silence: On Enter
//:: NW_S0_SilenceA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The target is surrounded by a zone of silence
    that allows them to move without sound.  Spell
    casters caught in this area will be unable to cast
    spells.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
//:: modified by mr_bumpkin  Dec 4, 2003
#include "prc_inc_spells"

void main()
{
    PRCSetSchool(SPELL_SCHOOL_ILLUSION);

    //Declare major variables including Area of Effect Object
    object oTarget = GetEnteringObject();
    object oCaster = GetAreaOfEffectCreator();
    int nPenetr = SPGetPenetrAOE(oCaster);

    //effect eDur1 = EffectVisualEffect(VFX_IMP_SILENCE);

    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
    {
        if(!PRCDoResistSpell(oCaster, oTarget, nPenetr))
        {
            effect eLink = EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC, 100);
                   eLink = EffectLinkEffects(eLink, EffectSilence());
                   eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));

            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_SILENCE, GetIsEnemy(oTarget, oCaster)));

            SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget, 0.0f, FALSE);
        }
    }
    PRCSetSchool();
}