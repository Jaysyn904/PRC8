/*
    sp_spiderskin

    Spiderskin toughens the target's skin, making
    it more like a spider's carapace. The target
    gains a bonus to natural armor, saves vs. poison,
    and hide checks. The bonus is equal to 1 +1 per 3
    caster levels, to a maximum of +5 at 12th level.

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
    float fDuration = PRCGetMetaMagicDuration(TenMinutesToSeconds(nCasterLevel));
    // Calculate buff amount.
    int nBuff = 1 + nCasterLevel / 3;
    if (nBuff > 5) nBuff = 5;
    // Apply the buff and vfx.
    effect eBuff = EffectACIncrease(nBuff, AC_NATURAL_BONUS);
    eBuff = EffectLinkEffects(eBuff, EffectSkillIncrease(SKILL_HIDE, nBuff));
    eBuff = EffectLinkEffects(eBuff,
        EffectSavingThrowIncrease(SAVING_THROW_ALL, nBuff, SAVING_THROW_TYPE_POISON));
    eBuff = EffectLinkEffects(eBuff, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oTarget, fDuration,TRUE,-1,nCasterLevel);

    SPApplyEffectToObject(DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_IMP_POLYMORPH), oTarget);

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