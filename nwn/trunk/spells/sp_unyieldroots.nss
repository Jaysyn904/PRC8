/*
    sp_unyieldroots

    The target you touch grow thick tree roots that
    anchor him to the ground and provide him with
    life-sustaining healing. The creature can't move
    but gains immunity to Bigby's Forceful Hand,
    Earthquake, Poison, Negative level (as the
    Restoration spell ) and healing up 30 point of
    damage per round. The Target gets a +4 to Fort
    and Will saves, but -4 to Ref saves.

    By: ???
    Created: ???
    Modified: Jul 2, 2006
*/

#include "prc_sp_func"

int GetIsSupernaturalCurse(effect eEff)
{
    object oCreator = GetEffectCreator(eEff);
    if(GetTag(oCreator) == "q6e_ShaorisFellTemple")
        return TRUE;
    return FALSE;
}

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    //Declare major variables
    effect eHold = EffectCutsceneImmobilize();
    effect eEntangle = EffectVisualEffect(VFX_DUR_ENTANGLE);
    int nDuration = nCasterLevel;
    if (nDuration < 1) nDuration = 1;
    int nMetaMagic = PRCGetMetaMagicFeat();
    //Check Extend metamagic feat.
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
       nDuration = nDuration *2;    //Duration is +100%
    effect eBad = GetFirstEffect(oTarget);
    //Search for negative effects
    while(GetIsEffectValid(eBad))
    {
        if (GetEffectType(eBad) == EFFECT_TYPE_ABILITY_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_AC_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_ATTACK_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_SAVING_THROW_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_SKILL_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_BLINDNESS ||
            GetEffectType(eBad) == EFFECT_TYPE_DEAF ||
            GetEffectType(eBad) == EFFECT_TYPE_PARALYZE ||
            GetEffectType(eBad) == EFFECT_TYPE_NEGATIVELEVEL)
            {
                //Remove effect if it is negative.
                if(!GetIsSupernaturalCurse(eBad))
                    RemoveEffect(oTarget, eBad);
            }
        eBad = GetNextEffect(oTarget);
    }

    //Link Entangle and Hold effects
    effect eLink = EffectLinkEffects(eHold, eEntangle);
    eLink = EffectLinkEffects(eLink,EffectSpellImmunity(SPELL_BIGBYS_FORCEFUL_HAND));
    eLink = EffectLinkEffects(eLink,EffectSpellImmunity(SPELL_EARTHQUAKE));
    eLink = EffectLinkEffects(eLink,EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE));
    eLink = EffectLinkEffects(eLink,EffectImmunity(IMMUNITY_TYPE_AC_DECREASE));
    eLink = EffectLinkEffects(eLink,EffectImmunity(IMMUNITY_TYPE_ATTACK_DECREASE));
    eLink = EffectLinkEffects(eLink,EffectImmunity(IMMUNITY_TYPE_DAMAGE_DECREASE));
    eLink = EffectLinkEffects(eLink,EffectImmunity(IMMUNITY_TYPE_DAMAGE_IMMUNITY_DECREASE));
    eLink = EffectLinkEffects(eLink,EffectImmunity(IMMUNITY_TYPE_SAVING_THROW_DECREASE));
    eLink = EffectLinkEffects(eLink,EffectImmunity(IMMUNITY_TYPE_SKILL_DECREASE));
    eLink = EffectLinkEffects(eLink,EffectImmunity(IMMUNITY_TYPE_SPELL_RESISTANCE_DECREASE));
    eLink = EffectLinkEffects(eLink,EffectImmunity(IMMUNITY_TYPE_BLINDNESS));
    eLink = EffectLinkEffects(eLink,EffectImmunity(IMMUNITY_TYPE_DEAFNESS));
    eLink = EffectLinkEffects(eLink,EffectImmunity(IMMUNITY_TYPE_PARALYSIS));
    eLink = EffectLinkEffects(eLink,EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL));
    eLink = EffectLinkEffects(eLink,EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN));
    eLink = EffectLinkEffects(eLink,EffectImmunity(IMMUNITY_TYPE_POISON));
    eLink = EffectLinkEffects(eLink,EffectRegenerate(30,6.0));

    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_FORT,4);
    eSave = EffectLinkEffects(eSave,EffectSavingThrowIncrease(SAVING_THROW_WILL,4));
    eSave = EffectLinkEffects(eSave,EffectSavingThrowDecrease(SAVING_THROW_REFLEX,4));

    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSave, oTarget, TurnsToSeconds(nDuration),TRUE,-1,nCasterLevel);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration),TRUE,-1,nCasterLevel);

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