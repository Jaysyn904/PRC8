/*
    nw_s0_circle

    Magic Circle Against Good, Evil, Law, Chaos

    By: Flaming_Sword
    Created: Jun 13, 2006
    Modified: Jun 13, 2006

    Consolidation of 4 scripts, cleaned up
*/

#include "prc_sp_func"

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel)
{
    int nSpellID = PRCGetSpellId();
    int nAOE;
    string temp;

    switch(nSpellID)
    {
        case SPELL_MAGIC_CIRCLE_AGAINST_CHAOS:
        {
            nAOE = AOE_MOB_CIRCCHAOS;
            temp = "TEMPO_CIRCCHAOS";
            break;
        }
        case SPELL_MAGIC_CIRCLE_AGAINST_EVIL:
        case SPELL_HALLOW:
        {
            nAOE = AOE_MOB_CIRCGOOD;
            temp = "TEMPO_CIRCEVIL";
            break;
        }
        case SPELL_MAGIC_CIRCLE_AGAINST_GOOD:
        {
            nAOE = AOE_MOB_CIRCEVIL;
            temp = "TEMPO_CIRCGOOD";
            break;
        }
        case SPELL_MAGIC_CIRCLE_AGAINST_LAW:
        {
            nAOE = AOE_MOB_CIRCLAW;
            temp = "TEMPO_CIRCLAW";
            break;
        }
    }

    effect eAOE = EffectAreaOfEffect(nAOE);
    effect eVis;

    if(nSpellID == SPELL_MAGIC_CIRCLE_AGAINST_CHAOS
    || nSpellID == SPELL_MAGIC_CIRCLE_AGAINST_GOOD)
        eVis = EffectVisualEffect(VFX_IMP_EVIL_HELP);
    else
        eVis = EffectVisualEffect(VFX_IMP_GOOD_HELP);

    int nTemp = GetLocalInt(oCaster, temp);
    DeleteLocalInt(oCaster, temp);

    float fDuration = nTemp ? RoundsToSeconds(nTemp) : HoursToSeconds(nCasterLevel);
    //Make sure duration does not equal 0
    //if nTemp == 0 we use caster level for duration, so check if it's not 0
    if(nCasterLevel < 1)
        fDuration = HoursToSeconds(1);

	if (nSpellID == SPELL_HALLOW) fDuration = HoursToSeconds(24);

    int nMetaMagic = PRCGetMetaMagicFeat();
    //Check Extend metamagic feat.
    if(nMetaMagic & METAMAGIC_EXTEND)
       fDuration *= 2;    //Duration is +100%

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellID, FALSE));

    //Create an instance of the AOE Object using the Apply Effect function
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, fDuration, TRUE, nSpellID, nCasterLevel);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

    //Setup Area Of Effect object
    object oAoE = GetAreaOfEffectObject(GetLocation(oTarget), GetAreaOfEffectTag(nAOE), oCaster);
    SetAllAoEInts(nSpellID, oAoE, 0, 0, nCasterLevel);

    return TRUE;    //return TRUE if spell charges should be decremented
}

void main()
{
    if (!X2PreSpellCastCode()) return;
    PRCSetSchool(SPELL_SCHOOL_ABJURATION);
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)
        {   //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges
            return;
        }
        DoSpell(oCaster, oTarget, nCasterLevel);
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            if(DoSpell(oCaster, oTarget, nCasterLevel))
                DecrementSpellCharges(oCaster);
        }
    }
    PRCSetSchool();
}
