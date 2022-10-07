/*
    x2_s0_magcvest

    Grants a +1 AC bonus to armor touched per 3 caster
    levels (maximum of +5).

    By: Andrew Nobbs
    Created: Nov 28, 2002
    Modified: Jun 30, 2006
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
    int nAmount = nCasterLevel/3;
    if(nAmount < 1)
        nAmount = 1;
    else if(nAmount > 5)
        nAmount = 5;

    float fDuration = HoursToSeconds(nCasterLevel);
    int nMetaMagic = PRCGetMetaMagicFeat();
    if(nMetaMagic & METAMAGIC_EXTEND)
        fDuration *= 2; //Duration is +100%

    effect eVis = EffectVisualEffect(VFX_IMP_GLOBE_USE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    object oMyArmor = IPGetTargetedOrEquippedArmor(TRUE);
    if(GetIsObjectValid(oMyArmor))
    {
        if(oTarget == oMyArmor)
            oTarget = GetItemPossessor(oMyArmor);

        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_MAGIC_VESTMENT, FALSE));

        DelayCommand(1.3f, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, fDuration);
        IPSafeAddItemProperty(oMyArmor, ItemPropertyACBonus(nAmount), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
    }
    else
    {
        FloatingTextStrRefOnCreature(83826, oCaster, FALSE);
    }

    return TRUE;    //return TRUE if spell charges should be decremented
}

void main()
{
    if (!X2PreSpellCastCode()) return;
    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
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