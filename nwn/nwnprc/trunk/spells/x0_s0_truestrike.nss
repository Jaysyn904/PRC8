//::///////////////////////////////////////////////
//:: True Strike
//:: x0_s0_truestrike.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
Divination
Level:        Sor/Wiz 1
Components:   V, F
Casting Time: 1 standard action
Range:        Personal
Target:       You
Duration:     See text

You gain temporary, intuitive insight into the
immediate future during your next attack. Your
next single attack roll (if it is made before the
end of the next round) gains a +20 insight bonus.
Additionally, you are not affected by the miss
chance that applies to attackers trying to strike
a concealed target.

Focus
A small wooden replica of an archery target.

CHANGE: Miss chance still applies, unlike rules.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: July 15, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By:
//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff

#include "prc_inc_spells"

void main()
{
    if (!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_DIVINATION);

    //Declare major variables
    object oCaster = OBJECT_SELF;
    int CasterLvl = PRCGetCasterLevel(oCaster);

    //Construct effects
    effect eAttack = EffectAttackIncrease(20);
    effect eDur    = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink   = EffectLinkEffects(eAttack, eDur);
    effect eVis    = EffectVisualEffect(VFX_IMP_HEAD_ODD);

    //Fire spell cast at event for target
    SignalEvent(oCaster, EventSpellCastAt(oCaster, SPELL_TRUE_STRIKE, FALSE));

    //Apply VFX impact and bonus effects
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, 9.0, TRUE, SPELL_TRUE_STRIKE, CasterLvl, oCaster);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oCaster);

    PRCSetSchool();
}

