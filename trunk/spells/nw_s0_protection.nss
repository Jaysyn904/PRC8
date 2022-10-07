/*
    nw_s0_protection

    Protection From Good, Evil, Law, Chaos

    By: Flaming_Sword
    Created: Jun 15, 2006
    Modified: Jun 15, 2006

    Consolidation of 4 scripts, cleaned up
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
    int nMetaMagic = PRCGetMetaMagicFeat();
    int AlignLC = ALIGNMENT_ALL;
    int AlignGE = ALIGNMENT_ALL;
    effect eDur;

    switch(nSpellID)
    {
        case SPELL_PROTECTION_FROM_LAW: AlignLC = ALIGNMENT_LAWFUL; break;
        case SPELL_PROTECTION__FROM_CHAOS: AlignLC = ALIGNMENT_CHAOTIC; break;
        case SPELL_PROTECTION_FROM_GOOD: AlignGE = ALIGNMENT_GOOD; break;
        case SPELL_PROTECTION_FROM_EVIL: AlignGE = ALIGNMENT_EVIL; break;
    }
    if((nSpellID == SPELL_PROTECTION__FROM_CHAOS) ||
        (nSpellID == SPELL_PROTECTION_FROM_EVIL))
        eDur = EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR);
    else
        eDur = EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MINOR);

    int nDuration = nCasterLevel;
    if (nMetaMagic & METAMAGIC_EXTEND)
       nDuration *= 2;    //Duration is +100%

    effect eAC = VersusAlignmentEffect(EffectACIncrease(2, AC_DEFLECTION_BONUS), AlignLC, AlignGE);
    effect eSave = VersusAlignmentEffect(EffectSavingThrowIncrease(SAVING_THROW_ALL, 2), AlignLC, AlignGE);
    effect eImmune = VersusAlignmentEffect(EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS), AlignLC, AlignGE);
    effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    effect eLink = EffectLinkEffects(eImmune, eSave);
    eLink = EffectLinkEffects(eLink, eAC);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eDur2);
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID, FALSE));
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