/*
    x0_s0_displace

    Target gains a 50% concealment bonus.

    By: Brent
    Created: Sept 7, 2002
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
    int nDuration = nCasterLevel;
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
        nDuration *= 2; //Duration is +100%
    effect eDisplace = EffectConcealment(50);
    if (GetEffectType(eDisplace) != EFFECT_TYPE_INVALIDEFFECT)  //WTF?! Don't want to mess with this
    {
        effect eLink = EffectLinkEffects(eDisplace, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DISPLACEMENT, FALSE));
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration),TRUE,-1,nCasterLevel);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_AC_BONUS), oTarget);
    }

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