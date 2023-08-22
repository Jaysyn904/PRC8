//::///////////////////////////////////////////////
//:: Invisibility Sphere: On Enter
//:: NW_S0_InvSphA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All allies within 15ft are rendered invisible.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
#include "prc_inc_spells"

void main()
{
    PRCSetSchool(SPELL_SCHOOL_ILLUSION);

    //Declare major variables
    object oTarget = GetEnteringObject();
    object oCaster = GetAreaOfEffectCreator();

    if(GetIsFriend(oTarget, oCaster) && !GetIsDead(oTarget))
    {
        effect eLink = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
               eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_INVISIBILITY));
               eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));

        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_INVISIBILITY_SPHERE, FALSE));

        //Apply the VFX impact and effects
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget, 0.0f, FALSE);
    }
    PRCSetSchool(SPELL_SCHOOL_ILLUSION);
}