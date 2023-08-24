/*
    sp_tru_truefrnd.nss

The spell grants the subject a +2 enhancement bonus to Strength, Dexterity, and Constitution. 
Truename Component: When you cast this spell, you must correctly speak the personal truename of the creature you’re augmenting.
*/

#include "prc_sp_func"
#include "prc_inc_sp_tch"
#include "prc_add_spell_dc"
#include "true_inc_trufunc"

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eDur, EffectAbilityIncrease(ABILITY_STRENGTH, 2));
           eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_DEXTERITY, 2));
           eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_CONSTITUTION, 2));

    float fDuration = 60.0 * nCasterLevel;
    
    int nMetaMagic = PRCGetMetaMagicFeat();
    if (nMetaMagic & METAMAGIC_EXTEND)
        fDuration = fDuration *2; //Duration is +100%
        
	if (DoSpellTruenameCheck(oCaster, oTarget, TRUE)) 
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, -1, nCasterLevel);
	
	return TRUE;
}

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
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