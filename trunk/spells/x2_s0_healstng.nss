/*
    x2_s0_healstng

    You inflict 1d6 +1 point per level damage to
    the living creature touched and gain an equal
    amount of hit points. You may not gain more
    hit points then your maximum with the Healing
    Sting.

    By: Andrew Nobbs
    Created: Nov 19, 2002
    Modified: Jun 30, 2006
*/

#include "prc_sp_func"
#include "prc_inc_sp_tch"
#include "prc_add_spell_dc"

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
    int nDamage = d6(1) + nCasterLvl;

    //Enter Metamagic conditions
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_MAXIMIZE))
    {
        nDamage = 6 + nCasterLvl;//Damage is at max
    }
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
    {
         nDamage += nDamage / 2;
    }
	nDamage += SpellDamagePerDice(oCaster, 1);
    nCasterLvl +=SPGetPenetr();


    //Declare effects
    effect eHeal = PRCEffectHeal(nDamage, oTarget);
    effect eVs = EffectVisualEffect(VFX_IMP_HEALING_M);
    effect eLink = EffectLinkEffects(eVs,eHeal);

    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    int iAttackRoll = 0;
    if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
    {
        if(!GetIsReactionTypeFriendly(oTarget) &&
            MyPRCGetRacialType(oTarget) != RACIAL_TYPE_UNDEAD &&
            !(GetHasFeat(FEAT_TOMB_TAINTED_SOUL, oTarget) && GetAlignmentGoodEvil(oTarget) != ALIGNMENT_GOOD) &&
            (MyPRCGetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT || GetIsWarforged(oTarget)) &&
            !GetHasSpellEffect(SPELL_NEGATIVE_ENERGY_PROTECTION, oTarget))
        {
           //Signal spell cast at event

            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, PRCGetSpellId()));

            iAttackRoll = PRCDoMeleeTouchAttack(oTarget);
            if(iAttackRoll > 0)
            {
                 //Spell resistance
                 if(!PRCDoResistSpell(OBJECT_SELF, oTarget,nCasterLvl))
                 {
                    if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (PRCGetSaveDC(oTarget,OBJECT_SELF)), SAVING_THROW_TYPE_NEGATIVE))
                    {
                        //Apply effects to target and caster
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, OBJECT_SELF);
                        SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

                        ApplyTouchAttackDamage(OBJECT_SELF, oTarget, iAttackRoll, nDamage, DAMAGE_TYPE_NEGATIVE);
                    }
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