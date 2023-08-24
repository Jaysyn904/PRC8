/*
    x0_s0_shieldfait

    +2 deflection AC bonus, +1 every 6 levels (max +5)
    Duration: 1 turn/level

    By: Brent Knowles
    Created: Sep 6, 2002
    Modified: Jun 29, 2006
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
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nValue = 2 + (nCasterLevel)/6;
    if(nValue > 5)
        nValue = 5; // * Max of 5
    effect eLink = EffectLinkEffects(EffectACIncrease(nValue, AC_DEFLECTION_BONUS), EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR));
    int nDuration = nCasterLevel; // * Duration 1 turn/level
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))    //Duration is +100%
         nDuration *= 2;
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 421, FALSE));
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_AC_BONUS), oTarget);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration),TRUE,-1,nCasterLevel);

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