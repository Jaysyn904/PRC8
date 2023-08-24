/*
    nw_s0_invisib

    Target creature becomes invisible

    By: Preston Watamaniuk
    Created: Jan 7, 2002
    Modified: Jun 12, 2006
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
    int bBio = GetPRCSwitch(PRC_BIOWARE_INVISIBILITY);
    effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eCover = EffectConcealment(50);
    effect eLink;
    if(bBio)
    {
        eLink = EffectLinkEffects(eInvis, eDur);
    }
    else
    {
        eLink = EffectLinkEffects(eInvis, eCover);
        eLink = EffectLinkEffects(eLink, eDur);
    }

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_INVISIBILITY, FALSE));
    int CasterLvl = nCasterLevel;
    int nDuration = CasterLvl;
    int nMetaMagic = PRCGetMetaMagicFeat();
    if (GetHasFeat(FEAT_INSIDIOUSMAGIC,OBJECT_SELF) && GetHasFeat(FEAT_SHADOWWEAVE,oTarget))
       nDuration = nDuration*2;
    //Enter Metamagic conditions
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        nDuration = nDuration *2; //Duration is +100%
    }
    //Apply the VFX impact and effects
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration),TRUE,-1,CasterLvl);

    return TRUE;    //return TRUE if spell charges should be decremented
}

void main()
{
    if(!X2PreSpellCastCode()) return;
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    PRCSetSchool(GetSpellSchool(PRCGetSpellId()));
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