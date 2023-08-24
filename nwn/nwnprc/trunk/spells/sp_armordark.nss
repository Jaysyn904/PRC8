/*
    sp_armordark

    lvl 4
    +3 bonus to ac plus additional +1 per every 4 lvl of caster to max of +8 .
    Gives Darkvision , +2 save against holy , light , or good spells.

    By: ???
    Created: ???
    Modified: Jul 1, 2006
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
    int nCasterLvl = nCasterLevel;
    int nMetaMagic = PRCGetMetaMagicFeat();
    float fDuration = PRCGetMetaMagicDuration(TenMinutesToSeconds(nCasterLvl));

    int iAC = 3 + nCasterLvl/4;
    if (iAC >8)  iAC = 8;

    effect eAC=EffectACIncrease(iAC,AC_DEFLECTION_BONUS);
    effect eUltravision = EffectUltravision();
    effect eSaveG=EffectSavingThrowIncrease(2,SAVING_THROW_ALL,SAVING_THROW_TYPE_GOOD);
    effect eSaveD=EffectSavingThrowIncrease(2,SAVING_THROW_ALL,SAVING_THROW_TYPE_DIVINE);

    effect eLinks=EffectLinkEffects(eAC,eUltravision);
           eLinks=EffectLinkEffects(eLinks,eSaveG);
           eLinks=EffectLinkEffects(eLinks,eSaveD);

    object oTarget=PRCGetSpellTargetObject();

    //Fire cast spell at event for the specified target
    PRCSignalSpellEvent(oTarget, FALSE);

    if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
    {
       effect eTurn=EffectTurnResistanceIncrease(4);
       eLinks=EffectLinkEffects(eLinks,eTurn);
    }

    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinks, oTarget, fDuration,TRUE,-1,nCasterLevel);
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