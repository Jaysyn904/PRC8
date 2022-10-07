/*
    nw_s0_vamptch

    drain 1d6
    HP per 2 caster levels from the target.

    By: Preston Watamaniuk
    Created: Oct 29, 2001
    Modified: Jun 28, 2006

    Cleaned up
*/

//------------------------------------------------------------------------------
// GZ: gets rids of temporary hit points so that they will not stack
//------------------------------------------------------------------------------
void PRCRemoveTempHitPoints()
{
    effect eProtection;
    int nCnt = 0;

    eProtection = GetFirstEffect(OBJECT_SELF);
    while (GetIsEffectValid(eProtection))
    {
      if(GetEffectType(eProtection) == EFFECT_TYPE_TEMPORARY_HITPOINTS)
        RemoveEffect(OBJECT_SELF, eProtection);
      eProtection = GetNextEffect(OBJECT_SELF);
    }
}

#include "prc_sp_func"
#include "prc_inc_sp_tch"

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nDDice = nCasterLevel / 2;
    if ((nDDice) == 0)
        nDDice = 1;
    else if (nDDice > 10)
        nDDice = 10;

    int nDamage = PRCMaximizeOrEmpower(6,nDDice,nMetaMagic);
    nDamage += SpellDamagePerDice(oCaster, nDDice);
    int nDuration = nCasterLevel/2;

    if ((nMetaMagic & METAMAGIC_EXTEND))
        nDuration *= 2;

    int nMax = GetCurrentHitPoints(oTarget) + 10;
    if(nMax < nDamage)
        nDamage = nMax;


    effect eHeal = EffectTemporaryHitpoints(nDamage);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eHeal, eDur);

    //effect eDamage = PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_NEGATIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eVisHeal = EffectVisualEffect(VFX_IMP_HEALING_M);

    int nPenetr = nCasterLevel + SPGetPenetr();
    int iAttackRoll;
    if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
    {
        if(!GetIsReactionTypeFriendly(oTarget) &&
            MyPRCGetRacialType(oTarget) != RACIAL_TYPE_UNDEAD &&
            !(GetHasFeat(FEAT_TOMB_TAINTED_SOUL, oTarget) && GetAlignmentGoodEvil(oTarget) != ALIGNMENT_GOOD) &&
            MyPRCGetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT &&
            !GetHasSpellEffect(SPELL_NEGATIVE_ENERGY_PROTECTION, oTarget))
        {
            SignalEvent(oCaster, EventSpellCastAt(OBJECT_SELF, SPELL_VAMPIRIC_TOUCH, FALSE));
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_VAMPIRIC_TOUCH, TRUE));

            iAttackRoll = PRCDoMeleeTouchAttack(oTarget);

            if (iAttackRoll > 0)
            {
                if(!PRCDoResistSpell(oCaster, oTarget, nPenetr))
                 {
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    ApplyTouchAttackDamage(oCaster, oTarget, iAttackRoll, nDamage, DAMAGE_TYPE_NEGATIVE);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVisHeal, oCaster);
                    PRCRemoveTempHitPoints();
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, HoursToSeconds(nDuration),TRUE,-1,nCasterLevel);
                 }
            }
        }
    }

    return iAttackRoll;    //return TRUE if spell charges should be decremented
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