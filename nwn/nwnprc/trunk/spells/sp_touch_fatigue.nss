//::///////////////////////////////////////////////
//:: Name      Touch of Fatigue
//:: FileName  sp_touch_fatigue.nss
//:://////////////////////////////////////////////
/*
Level:              Sor/Wiz 0, Duskblade 0, Blighter 0
Components:         V, S
Casting Time:       1 standard action
Range:              Touch
Target:             Creature touched
Duration:           1 round/level
Saving Throw:       Fort negates
Spell Resistance:   Yes

You channel negative energy through your touch, fatiguing the target.
You must succeed on a touch attack to strike a target.
The subject is immediately fatigued for the spell's duration.
This spell has no effect on a creature that is already fatigued.
Unlike with normal fatigue, the effect ends as soon as the spell's duration expires.

**/
//::////////////////////////////////////////////////
//:: Author: Strat
//:: Date  : 11.4.2020
//::////////////////////////////////////////////////

#include "prc_inc_sp_tch"
#include "prc_sp_func"
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
    int nPenetr = nCasterLevel + SPGetPenetr();
    int nDie = min(nCasterLevel, 5);
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget);
    effect eVis = EffectVisualEffect(VFX_DUR_BIGBYS_BIGBLUE_HAND2);

    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, PRCGetSpellId()));
    int iAttackRoll = PRCDoMeleeTouchAttack(oTarget, TRUE, oCaster);

    if(iAttackRoll > 0)
    {
        // Only creatures, and PvP check.
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            // Check Spell Resistance
            if(!PRCDoResistSpell(oCaster, oTarget, nPenetr))
            {
                if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, PRCGetSaveDC(oTarget, oCaster), SAVING_THROW_TYPE_SPELL))
                {
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectFatigue(), oTarget, nCasterLevel*6.0);
				}
            }
        }
    }

    return iAttackRoll;// return TRUE if spell charges should be decremented
}

void main()
{
    PRCSetSchool(SPELL_SCHOOL_EVOCATION);
    if (!X2PreSpellCastCode()) return;
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)
        {
            //holding the charge, casting spell on self
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