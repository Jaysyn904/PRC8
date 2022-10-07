/*
    sp_pestilence

    Disease effect on target. The disease will spawn an AOE
    that will spread the disease for 24h from infection.

    By: Ornedan
    Created: Dec 25, 2004
    Modified: Jul 2, 2006
*/

#include "prc_sp_func"
#include "prc_inc_sp_tch"
#include "prc_add_spell_dc"

void SetupPestilenceAura(object oTarget, object oCaster, int nCasterLevel)
{
    effect eAoE = EffectAreaOfEffect(AOE_MOB_PESTILENCE);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAoE, oTarget, HoursToSeconds(24) /*+10*/, FALSE, SPELL_PESTILENCE, nCasterLevel, oCaster);

    object oAoE = GetAreaOfEffectObject(GetLocation(oTarget), "VFX_MOB_PESTILENCE");
    SetAllAoEInts(SPELL_PESTILENCE, oAoE, PRCGetSpellSaveDC(SPELL_PESTILENCE, SPELL_SCHOOL_NECROMANCY), 1, nCasterLevel);
}

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nSaveDC = PRCGetSaveDC(oTarget, oCaster);
    int nPenetr = nCasterLevel + SPGetPenetr();
    float fMaxDuration = RoundsToSeconds(nCasterLevel); //modify if necessary

    effect eDisease = EffectDisease(DISEASE_PESTILENCE);

    int iAttackRoll;
    // Check for the disease component
    if(!PRCGetHasEffect(EFFECT_TYPE_DISEASE, oCaster))
    {
        if(GetIsPC(oCaster))
        {
            SendMessageToPC(oCaster, "You need to to be diseased to cast this spell");
        }// end if - is oCaster a PC
    }// end if - caster isn't diseased
    else
    {
        // Check if the target is valid
        if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_PESTILENCE));
            //Make touch attack
            iAttackRoll = PRCDoMeleeTouchAttack(oTarget);
            if(iAttackRoll)
            {
                //Make sure the target is a living one
                if(PRCGetIsAliveCreature(oTarget))
                {
                    //Make SR Check
                    if (!PRCDoResistSpell(oCaster, oTarget, nPenetr))
                    {
                        if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC, SAVING_THROW_TYPE_DISEASE))
                        {
                            SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eDisease, oTarget, 0.0f, FALSE, SPELL_PESTILENCE, nCasterLevel, oCaster);
                            SetLocalInt(oTarget, "SPELL_PESTILENCE_DC", nSaveDC);
                            SetLocalInt(oTarget, "SPELL_PESTILENCE_CASTERLVL", nCasterLevel);
                            SetLocalInt(oTarget, "SPELL_PESTILENCE_SPELLPENETRATION", nPenetr);
                            SetLocalObject(oTarget, "SPELL_PESTILENCE_CASTER", oCaster);
                            SetLocalInt(oTarget, "SPELL_PESTILENCE_DO_ONCE", TRUE);
//                          DelayCommand(4.0f, DeleteLocalInt(oTarget, "SPELL_PESTILENCE_DO_ONCE"));

                            // Delayed a bit. Seems like the presence of the disease effect may
                            // not register immediately, resulting in the AoE killing itself
                            // right away due to that check failing.
                            DelayCommand(0.4f, SetupPestilenceAura(oTarget, oCaster, nCasterLevel));
                        }// end if - fort save
                    }// end if - spell resistance
                }//end if - only living targets
            }// end if - touch attack
        }// end if - is the target valid
    }// end else - the caster is diseased

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