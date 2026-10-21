//::////////////////////////////////////////////////////////
//::
/*
	Sheltered Vitality (sp_sheltvital.nss)
	Abjuration
	Level: 				Cleric 4, Druid 4,
	Components: 		V, S, DF,
	Casting Time: 		1 standard action
	Range: 				Touch
	Target: 			Living creature touched
	Duration: 			1 minute/level
	Saving Throw: 		Fortitude negates (harmless)
	Spell Resistance:	Yes (harmless)

*/
//::
//::////////////////////////////////////////////////////////
//::
/*
	Pressing your hand to the creature's chest, you utter a 
	low chant, and a warm glow passes from your hand into the 
	subject.

	The subject gains immunity to fatigue, exhaustion, and 
	ability damage or ability drain (regardless of the source).

	PnP Mechanics
	- IMMUNITY_TYPE_ABILITY_DECREASE blocks ability  
	 damage/drain and most of EffectFatigue/EffectExhausted.  
	- Heartbeat strips any PRCFatigue/PRCExhausted-tagged  
	 effect that still lands (e.g. script-applied,  
	 extraordinary subtypes immune to IMMUNITY_TYPE checks).	
*/
//::
//::////////////////////////////////////////////////////////
//::
//:: Created by: Jaysyn
//:: Date: 2026-10-08 20:15:07
//::
//::////////////////////////////////////////////////////////
#include "prc_inc_sp_tch"  
#include "prc_sp_func"
#include "prc_inc_spells"  
  
void VitalMonitor(object oTarget, int nSpellID)  
{  
    if (!GetIsObjectValid(oTarget) || GetIsDead(oTarget)  
        || !GetHasSpellEffect(nSpellID, oTarget))  
        return;  
  
    // Strip any fatigue/exhaustion effects that got through  
    effect eCheck = GetFirstEffect(oTarget);  
    while (GetIsEffectValid(eCheck))  
    {  
        string sTag = GetEffectTag(eCheck);  
        if (sTag == "PRCFatigue" || sTag == "PRCExhausted")  
            RemoveEffect(oTarget, eCheck);  
        eCheck = GetNextEffect(oTarget);  
    }  
    DelayCommand(3.0, VitalMonitor(oTarget, nSpellID));  
}  
  
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)  
{  
    int nMetaMagic = PRCGetMetaMagicFeat();  
    int nSpellID   = PRCGetSpellId();  
    float fDur     = TurnsToSeconds(nCasterLevel);        
    if (nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;  
  
    effect eLink = EffectLinkEffects(  
        EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE),  
        EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));  
  
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur,  
                          TRUE, nSpellID, nCasterLevel);  
    SPApplyEffectToObject(DURATION_TYPE_INSTANT,  
        EffectVisualEffect(VFX_IMP_HEAD_HOLY), oTarget);  
  
    VitalMonitor(oTarget, nSpellID);                    // start heartbeat  
    return TRUE;  
}  
  
void main()  
{  
    object oCaster = OBJECT_SELF;  
    int nCasterLevel = PRCGetCasterLevel(oCaster);  
    PRCSetSchool(GetSpellSchool(PRCGetSpellId()));  
    if (!X2PreSpellCastCode()) return;  
    object oTarget = PRCGetSpellTargetObject();  
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT);  
  
    if (!nEvent) // normal cast  
    {  
        if (GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)  
        {  
            SetLocalSpellVariables(oCaster, 1);  
            return;  
        }  
        DoSpell(oCaster, oTarget, nCasterLevel, nEvent);  
    }  
    else  
    {  
        if (nEvent & PRC_SPELL_EVENT_ATTACK)  
        {  
            if (DoSpell(oCaster, oTarget, nCasterLevel, nEvent))  
                DecrementSpellCharges(oCaster);  
        }  
    }
	
    PRCSetSchool();  
}