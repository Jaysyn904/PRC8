//::///////////////////////////////////////////////
//:: Restoration
//:: x2_s0_restother.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Removes all negative effects unless they come
    from Poison, Disease or Curses.
    Can only be cast on Others - not on oneself.
    Caster takes 5 points of damage when this
    spell is cast.
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Jan 3/03
//:://////////////////////////////////////////////
//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_inc_spells"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    effect eVisual = EffectVisualEffect(VFX_IMP_RESTORATION);
    int bValid;
    if(oTarget != oCaster)
    {
        effect eBad = GetFirstEffect(oTarget);
        //Search for negative effects
        while(GetIsEffectValid(eBad))
        {
            int nEffType = GetEffectType(eBad);
            if(nEffType == EFFECT_TYPE_ABILITY_DECREASE
            || nEffType == EFFECT_TYPE_AC_DECREASE
            || nEffType == EFFECT_TYPE_ATTACK_DECREASE
            || nEffType == EFFECT_TYPE_DAMAGE_DECREASE
            || nEffType == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE
            || nEffType == EFFECT_TYPE_SAVING_THROW_DECREASE
            || nEffType == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE
            || nEffType == EFFECT_TYPE_SKILL_DECREASE
            || nEffType == EFFECT_TYPE_BLINDNESS
            || nEffType == EFFECT_TYPE_DEAF
            || nEffType == EFFECT_TYPE_PARALYZE
            || nEffType == EFFECT_TYPE_NEGATIVELEVEL)
            {
                //Remove effect if it is negative.
                RemoveEffect(oTarget, eBad);
            }
            eBad = GetNextEffect(oTarget);
        }
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_RESTORATION, FALSE));

        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget);

        //Apply Damage Effect to the Caster
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, 5), oCaster);
    }
    PRCSetSchool();
}