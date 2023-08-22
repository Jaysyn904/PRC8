/*
    nw_s0_magearm

    Rewrite of Mage Armor to follow pnp rules of +4 armor bonus.

    By: ???
    Created: ???
    Modified: Jun 29, 2006

    Flaming_Sword: cleaned up,
        added improved mage armour
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
    int bMA = (nSpellID == SPELL_MAGE_ARMOR);
    PRCSignalSpellEvent(oTarget, FALSE);
    int nBonus;
    if(bMA)
        nBonus = 4;
    else
        nBonus = 3 + nCasterLevel / 2;
    if(nBonus > 8) nBonus = 8;
    effect eAC = EffectLinkEffects(EffectACIncrease(nBonus, AC_ARMOUR_ENCHANTMENT_BONUS), EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
    float fDuration = PRCGetMetaMagicDuration((bMA) ? HoursToSeconds(nCasterLevel) : MinutesToSeconds(nCasterLevel));
    PRCRemoveEffectsFromSpell(oTarget, nSpellID);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, oTarget, fDuration,TRUE,-1,nCasterLevel);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_AC_BONUS), oTarget);

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