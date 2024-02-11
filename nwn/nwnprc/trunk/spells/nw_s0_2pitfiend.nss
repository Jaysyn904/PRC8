 //::///////////////////////////////////////////////
//:: Pit Fiend Payload
//:: NW_S0_2PitFiend
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    DEATH --- DEATH --- BO HA HA HA
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 11, 2002
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    object oTarget = OBJECT_SELF;
    effect eDrain = EffectDeath();
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH);

    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDrain, oTarget);
}
