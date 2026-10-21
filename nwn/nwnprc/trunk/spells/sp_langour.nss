//::////////////////////////////////////////////////////////
//::
/*
	Languor (sp_langour.nss)

	Transmutation
	Level: 				Druid 4,
	Components: 		V, S,
	Casting 			Time: 1 standard action
	Range: 				Close (25 ft. + 5 ft./2 levels)
	Effect: 			Ray
	Duration: 			1 round/level
	Saving Throw: 		Will partial
	Spell Resistance:	Yes

*/
//::
//::////////////////////////////////////////////////////////
//::
/*	 
	With a low thrumming sound, a blue beam lances from your 
	finger to strike your foe and weaken him.

	You must succeed on a ranged touch attack with the ray 
	to strike a target. This ray causes creatures it hits 
	to become weak and slow for the spell's duration. A 
	struck creature takes a penalty to Strength equal to 
	1d6+1 per two caster levels (maximum 1d6+10). In addition, 
	a subject that fails a Will save is slowed.

	The spell's slow effect counters and is countered by haste.
	
	PnP notes:  
	- Ranged touch; Str penalty 1d6 + 1/2 CL (max 1d6+10).  
	  It's a penalty, not damage -> temporary  
	  EffectAbilityDecrease, does not stack with itself.  
	- Failed Will save: slowed for the duration.  
	- Slow counters/is countered by haste.  
*/
//::
//::////////////////////////////////////////////////////////
//::
//:: Created by: Jaysyn
//:: Date: 2026-10-08 20:34:05
//::
//::////////////////////////////////////////////////////////  
#include "prc_inc_sp_tch"  
#include "prc_sp_func"  
#include "prc_add_spell_dc"  
  
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)  
{  
    int nMetaMagic = PRCGetMetaMagicFeat();  
    int nSaveDC    = PRCGetSaveDC(oTarget, oCaster);  
    int nPenetr    = nCasterLevel + SPGetPenetr();  
    int nSpellID   = PRCGetSpellId();  
    float fDur     = RoundsToSeconds(nCasterLevel);  
  
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))  
        fDur += fDur;  
  
    // Str penalty: 1d6 + 1 per 2 CL, max bonus +10 (CL 20)  
    int nBonus = PRCMin(10, nCasterLevel / 2);  
    int nLoss  = PRCMaximizeOrEmpower(6, 1, nMetaMagic, nBonus);  
  
    int iAttackRoll = 0;  
  
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))  
    {  
        PRCSignalSpellEvent(oTarget, TRUE);  
  
        iAttackRoll = PRCDoRangedTouchAttack(oTarget);  
  
        // Blue ray; miss branch draws past the target  
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,  
            EffectBeam(VFX_BEAM_LIGHTNING, oCaster, BODY_NODE_HAND, !iAttackRoll),  
            oTarget, 1.0f, FALSE);  
  
        if (iAttackRoll > 0 && PRCGetIsAliveCreature(oTarget))  
        {  
            if (!PRCDoResistSpell(oCaster, oTarget, nPenetr))  
            {  
                // Str penalty applies on hit — no save  
                effect eLink = EffectAbilityDecrease(ABILITY_STRENGTH, nLoss);  
                eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));  
  
                // Failed Will save adds slow (counters/countered by haste)  
                if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nSaveDC, SAVING_THROW_TYPE_SPELL))  
                    eLink = EffectLinkEffects(eLink, EffectSlow());  
  
                eLink = MagicalEffect(eLink);  
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur, TRUE, nSpellID, nCasterLevel);  
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE), oTarget);  
            }  
        }  
    }  
  
    return iAttackRoll;    // TRUE = decrement held charge  
}  
  
void main()  
{  
    object oCaster = OBJECT_SELF;  
    int nCasterLevel = PRCGetCasterLevel(oCaster);  
    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);  
    if (!X2PreSpellCastCode()) return;  
  
    object oTarget = PRCGetSpellTargetObject();  
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT);  
  
    if (!nEvent) // normal cast  
    {  
        if (GetLocalInt(oCaster, PRC_SPELL_HOLD)  
            && GetHasFeat(FEAT_EF_HOLD_RAY, oCaster)  
            && oCaster == oTarget)  
        {  
            // Holding the charge — cast on self stores it  
            SetLocalSpellVariables(oCaster, 1);  
            return;  
        }  
        if (oCaster != oTarget) // can't target self except to hold  
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