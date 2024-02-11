/*
    nw_s0_awaken

    This spell makes an animal ally more
    powerful, intelligent and robust for the
    duration of the spell.  Requires the caster to
    make a Will save to succeed.

    By: Preston Watamaniuk
    Created: Aug 10, 2001
    Modified: Jun 12, 2006
*/

#include "prc_sp_func"
#include "inc_npc"

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    //Declare major variables
    effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, 4);
    effect eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION, 4);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eInt;
    effect eAttack = EffectAttackIncrease(2);
    effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);
    int nInt = d10();
    //int nDuration = 24;
    int nMetaMagic = PRCGetMetaMagicFeat();

    if(GetAssociateTypeNPC(oTarget) == ASSOCIATE_TYPE_ANIMALCOMPANION && GetMasterNPC(oTarget) == oCaster)
    {
        if(!GetHasSpellEffect(SPELL_AWAKEN))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_AWAKEN, FALSE));
            //Enter Metamagic conditions
            if(nMetaMagic & METAMAGIC_MAXIMIZE)
                nInt = 10;//Damage is at max
            if(nMetaMagic & METAMAGIC_EMPOWER)
                nInt += (nInt/2); //Damage/Healing is +50%
            //if(nMetaMagic & METAMAGIC_EXTEND)
            //    nDuration *= 2; //Duration is +100%

            eInt = EffectAbilityIncrease(ABILITY_WISDOM, nInt);

            effect eLink = EffectLinkEffects(eStr, eCon);
            eLink = EffectLinkEffects(eLink, eAttack);
            eLink = EffectLinkEffects(eLink, eInt);
            eLink = EffectLinkEffects(eLink, eDur);
            eLink = SupernaturalEffect(eLink);
            //Apply the VFX impact and effects
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget, 0.0f, TRUE, SPELL_AWAKEN, nCasterLevel);
        }
    }

    return TRUE;    //return TRUE if spell charges should be decremented
}

void main()
{
    if(!X2PreSpellCastCode()) return;
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