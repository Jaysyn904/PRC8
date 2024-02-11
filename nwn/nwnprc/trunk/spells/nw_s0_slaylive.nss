/*
    nw_s0_slaylive

    Caster makes a touch attack and if the target
        fails a Fortitude save they die.

    By: Preston Watamaniuk
    Created: Jan 22, 2001
    Modified: Jun 28, 2006

    Cleaned up slightly
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
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nDamage;
    effect eVis2 = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);

    nCasterLevel +=SPGetPenetr();
    int iAttackRoll;
    if(!GetIsReactionTypeFriendly(oTarget) && PRCGetIsAliveCreature(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SLAY_LIVING));
        //Make SR check
        if(!PRCDoResistSpell(oCaster, oTarget,nCasterLevel))
        {
            iAttackRoll = PRCDoMeleeTouchAttack(oTarget);
            if(iAttackRoll)
            {
                if  (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (PRCGetSaveDC(oTarget,oCaster)), SAVING_THROW_TYPE_DEATH))
                {
                    DeathlessFrenzyCheck(oTarget);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
                }
                else if (GetHasMettle(oTarget, SAVING_THROW_FORT))
                {
			// This script does nothing if it has Mettle, bail
				return 0;
		}
                else
                {
                    nDamage = d6(3)+ nCasterLevel;
                    if ((nMetaMagic & METAMAGIC_MAXIMIZE))
                    {
                        nDamage = 18 + nCasterLevel;
                    }
                    if ((nMetaMagic & METAMAGIC_EMPOWER))
                    {
                        nDamage = nDamage + (nDamage/2);
                    }
                    nDamage += SpellDamagePerDice(oCaster, 3);
                    ApplyTouchAttackDamage(oCaster, oTarget, iAttackRoll, nDamage, DAMAGE_TYPE_MAGICAL);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
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