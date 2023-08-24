//::///////////////////////////////////////////////
//:: Magic Cirle Against Good
//:: NW_S0_CircGoodA
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Add basic protection from good effects to
    entering allies.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 20, 2001
//:://////////////////////////////////////////////
//:: modified by mr_bumpkin Dec 4, 2003
#include "prc_inc_spells"

void main()
{
    PRCSetSchool(SPELL_SCHOOL_ABJURATION);
    
    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();

    if(GetIsFriend(oTarget, oCaster))
    {
        //Declare major variables
        effect eLink = PRCCreateProtectionFromAlignmentLink(ALIGNMENT_GOOD);

        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_MAGIC_CIRCLE_AGAINST_GOOD, FALSE));

        //Apply the VFX impact and effects
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget, 0.0f, FALSE);
    }
    PRCSetSchool();
}