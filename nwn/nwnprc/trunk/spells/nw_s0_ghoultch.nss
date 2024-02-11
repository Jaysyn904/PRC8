/*
    nw_s0_ghoultch.nss

    The caster attempts a touch attack on a target
    creature.  If successful creature must save
    or be paralyzed. Target exudes a stench that
    causes all enemies to save or be stricken with
    -2 Attack, Damage, Saves and Skill Checks for
    1d6+2 rounds.

    By: Preston Watamaniuk
    Created: Nov 7, 2001
    Modified: Jun 12, 2006
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
    effect eAOE = EffectAreaOfEffect(AOE_PER_FOGGHOUL);
    effect eParal = EffectParalyze();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDur2 = EffectVisualEffect(VFX_DUR_PARALYZED);

    effect eLink = EffectLinkEffects(eDur2, eDur);
    eLink = EffectLinkEffects(eLink, eParal);

    int iAttackRoll = 0;

    int nDuration = d6()+2;
    int nMetaMagic = PRCGetMetaMagicFeat();
    //Enter Metamagic conditions
    if (nMetaMagic & METAMAGIC_MAXIMIZE)
    {
        nDuration = 8;//Damage is at max
    }
    if (nMetaMagic & METAMAGIC_EMPOWER)
    {
        nDuration = nDuration + (nDuration/2); //Damage/Healing is +50%
    }
    if (nMetaMagic & METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }
    if(!GetIsReactionTypeFriendly(oTarget) && PRCAmIAHumanoid(oTarget) && PRCGetIsAliveCreature(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_GHOUL_TOUCH));
        //Make a touch attack to afflict target

       // GZ: * GetSpellCastItem() == OBJECT_INVALID is used to prevent feedback from showing up when used as OnHitCastSpell property
        iAttackRoll = PRCDoMeleeTouchAttack(oTarget);
        if (iAttackRoll)
        {
            //SR and Saves
            if(!PRCDoResistSpell(OBJECT_SELF, oTarget) && !/*Fort Save*/ PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (PRCGetSaveDC(oTarget,OBJECT_SELF)), SAVING_THROW_TYPE_NEGATIVE))
            {
                //Create an instance of the AOE Object using the Apply Effect function
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
                ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, GetLocation(oTarget), RoundsToSeconds(nDuration));
                
                object oAoE = GetAreaOfEffectObject(GetLocation(oTarget), "VFX_PER_FOGGHOUL");
                SetAllAoEInts(SPELL_GHOUL_TOUCH, oAoE, PRCGetSpellSaveDC(SPELL_GHOUL_TOUCH, SPELL_SCHOOL_NECROMANCY), 0, nCasterLevel);
            }
        }
    }

    return iAttackRoll;    //return TRUE if spell charges should be decremented
}

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    PRCSetSchool(SPELL_SCHOOL_NECROMANCY);
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