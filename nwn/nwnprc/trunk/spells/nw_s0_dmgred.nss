/*
    nw_s0_dmgred

    Consolidation of Stoneskin,
        Greater Stoneskin, Premonition

    By: Flaming_Sword
    Created: Jun 28, 2006
    Modified: Jun 28, 2006

    Merged, cleaned up
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
    int nSpellID = PRCGetSpellId();
    int nSoak = 0;
    int nCap = -1;
    int nMetaMagic = PRCGetMetaMagicFeat();
    effect eLink;
    int nDuration = nCasterLevel;
    int nLimit = 10 * nCasterLevel;
    if(nSpellID == SPELL_PREMONITION)
    {
        nSoak = 30;
        eLink = EffectVisualEffect(VFX_DUR_PROT_PREMONITION);
    }
    else if(nSpellID == SPELL_GREATER_STONESKIN)
    {
        nSoak = 20;
        eLink = EffectVisualEffect(VFX_DUR_PROT_STONESKIN);
        if(nLimit > 150) nLimit = 150;
    }
    else if(nSpellID == SPELL_STONESKIN)
    {
        nSoak = 10;
        eLink = EffectVisualEffect(VFX_DUR_PROT_STONESKIN);
        if(nLimit > 100) nLimit = 100;
    }
    eLink = EffectLinkEffects(eLink, EffectDamageReduction(nSoak, DAMAGE_POWER_PLUS_FIVE, nLimit));
    if(nSpellID != SPELL_PREMONITION)
    {
        eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
        int nImp = (nSpellID == SPELL_GREATER_STONESKIN) ? VFX_IMP_POLYMORPH : VFX_IMP_SUPER_HEROISM;
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nImp), oTarget);
    }
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID, FALSE));
    if (nMetaMagic & METAMAGIC_EXTEND)
        nDuration *= 2;
    PRCRemoveEffectsFromSpell(oTarget, nSpellID);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration),TRUE,-1,nCasterLevel);

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