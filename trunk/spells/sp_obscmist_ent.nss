//::///////////////////////////////////////////////
//:: Obscuring Mist
//:: sp_obscmist_ent.nss
//:://////////////////////////////////////////////
/*
    All people within the AoE get 20% conceal,
    50% vs ranged.
*/
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    //Declare major variables
    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();

    effect eLink = EffectConcealment(50, MISS_CHANCE_TYPE_VS_RANGED);
           eLink = EffectLinkEffects(eLink, EffectConcealment(20));
           eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_GLOW_GREY));

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_OBSCURING_MIST, FALSE));

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);

    PRCSetSchool();
}