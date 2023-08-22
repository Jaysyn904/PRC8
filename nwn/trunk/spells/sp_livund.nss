/*
    sp_livund

    Living Undeath - Target becomes partially undead, gains immunity
    to critical hits and -4 CHA.

    By: ???
    Created: ???
    Modified: Jul 2, 2006
*/

#include "prc_sp_func"

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    PRCSignalSpellEvent(oTarget, FALSE);
    // Determine the spell's duration, taking metamagic feats into account.
    float fDuration = PRCGetMetaMagicDuration(MinutesToSeconds(nCasterLevel));
    // Apply the buff and vfx.
    effect eEffect = EffectLinkEffects(EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT), EffectVisualEffect(VFX_DUR_PARALYZED));
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, fDuration,TRUE,-1,nCasterLevel);
    ApplyAbilityDamage(oTarget, ABILITY_CHARISMA, 4, DURATION_TYPE_TEMPORARY, TRUE, fDuration, TRUE, oCaster);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH_L), oTarget);

    return TRUE;    //return TRUE if spell charges should be decremented
}

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    PRCSetSchool(GetSpellSchool(PRCGetSpellId()));
    if (!X2PreSpellCastCode()) return;
    object oTarget = PRCGetSpellTargetObject();
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)
        {   //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges
            return;
        }
        DoSpell(oCaster, oTarget, nCasterLevel, nEvent);
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            if(DoSpell(oCaster, oTarget, nCasterLevel, nEvent))
                DecrementSpellCharges(oCaster);
        }
    }
    PRCSetSchool();
}