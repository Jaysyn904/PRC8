//::///////////////////////////////////////////////
//:: Bestow Curse
//:: Greater Bestow Curse
//:: nw_s0_bescurse.nss
//::///////////////////////////////////////////////
/*
Bestow Curse
Necromancy
Level:            Clr 3, Sor/Wiz 4
Components:       V, S
Casting Time:     1 standard action
Range:            Touch
Target:           Creature touched
Duration:         Permanent
Saving Throw:     Will negates
Spell Resistance: Yes

You place a curse on the subject. Choose one of the
following three effects:
-6 decrease to an ability score (minimum 1).
-4 penalty on attack rolls, saves, ability checks,
and skill checks.
Each turn, the target has a 50% chance to act
normally; otherwise, it takes no action.

You may also invent your own curse, but it should
be no more powerful than those described above.

The curse bestowed by this spell cannot be dispelled,
but it can be removed with a break enchantment,
limited wish, miracle, remove curse, or wish spell.

Bestow curse counters remove curse.

Greater Bestow Curse
???
*/
//:://////////////////////////////////////////////
//:: NWN version:
//:: Afflicted creature must save or suffer a -2 penalty
//:: to all ability scores. This is a supernatural effect.
//:://////////////////////////////////////////////
//:: By: Bob McCabe
//:: Created: March 6, 2001
//:: Modified: Jun 12, 2006
//:://////////////////////////////////////////////
//:: Flaming_Sword: Added touch attack roll
//:://////////////////////////////////////////////

#include "prc_inc_sp_tch"
#include "prc_sp_func"
#include "prc_add_spell_dc"

int DoSpell(object oCaster, object oTarget, int nCasterLevel)
{
    int nSpellID = PRCGetSpellId();
    int iAttackRoll = PRCDoMeleeTouchAttack(oTarget);
    if (iAttackRoll > 0)
    {
        int nPenetr = nCasterLevel + SPGetPenetr();
        int nPenalty = nSpellID == SPELL_GREATER_BESTOW_CURSE ? 4 : 2;
            nPenalty *= iAttackRoll;//can score a *Critical Hit*

        effect eVis   = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
        effect eCurse = EffectCurse(nPenalty, //str
                                    nPenalty, //dex
                                    nPenalty, //con
                                    nPenalty, //int
                                    nPenalty, //wis
                                    nPenalty);//cha
        //Make sure that curse is of type supernatural not magical
               eCurse = SupernaturalEffect(eCurse);

        //Signal spell cast at event
        SignalEvent(oTarget, EventSpellCastAt(oTarget, nSpellID));

         //Make SR Check
        if (!PRCDoResistSpell(oCaster, oTarget, nPenetr))
        {
            //Make Will Save
            if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, PRCGetSaveDC(oTarget, oCaster)))
            {
                //Apply Effect and VFX
                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eCurse, oTarget, 0.0f, TRUE, nSpellID, nCasterLevel);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
    }

    return iAttackRoll;    //return TRUE if spell charges should be decremented
}

void main()
{
    if (!X2PreSpellCastCode()) return;
    PRCSetSchool(SPELL_SCHOOL_NECROMANCY);
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