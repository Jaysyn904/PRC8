//::///////////////////////////////////////////////
//:: Divine Favor
//:: x0_s0_divfav.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
Evocation
Level:        Clr 1, Pal 1
Components:   V, S, DF
Casting Time: 1 standard action
Range:        Personal
Target:       You
Duration:     1 minute

Calling upon the strength and wisdom of a deity,
you gain a +1 luck bonus on attack and weapon
damage rolls for every three caster levels you
have (at least +1, maximum +5). The bonus doesn’t
apply to spell damage.

NOTE: Official rules say +6, we can only go to +5
 Duration: 1 turn
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: July 15, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By:
//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
//:: Updated by Strat to fix bug

#include "prc_inc_spells"

void main()
{
    if (!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_EVOCATION);

    //Declare major variables
    object oCaster = OBJECT_SELF;
    int CasterLvl = PRCGetCasterLevel(oCaster);
    int nMetaMagic = PRCGetMetaMagicFeat();
    float fDuration = TurnsToSeconds(1); // * Duration 1 turn
    if(nMetaMagic & METAMAGIC_EXTEND)
        fDuration *= 2;
    int nScale = PRCMin(5, PRCMax(1, CasterLvl / 3));

    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);

    // * determine the damage bonus to apply
    effect eAttack = EffectAttackIncrease(nScale);
    effect eDamage = EffectDamageIncrease(nScale, DAMAGE_TYPE_MAGICAL);
    effect eDur  = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eAttack, eDamage);
           eLink = EffectLinkEffects(eLink, eDur);

    //Apply Impact
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, PRCGetSpellTargetLocation());

    //Fire spell cast at event for target
    SignalEvent(oCaster, EventSpellCastAt(oCaster, SPELL_DIVINE_FAVOR, FALSE));

    //Apply VFX impact and bonus effects
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oCaster);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, fDuration, TRUE, SPELL_DIVINE_FAVOR, CasterLvl);

    PRCSetSchool();
}
