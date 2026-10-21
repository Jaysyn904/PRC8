//::////////////////////////////////////////////////////////
//::
/*
	Saltray	(sp_saltray)
	Evocation
	Level: 				Druid 2,
	Components: 		V, S,
	Casting Time: 		1 standard action
	Range: 				Close (25 ft. + 5 ft./2 levels)
	Effect: 			Ray
	Duration: 			Instantaneous
	Saving Throw: 		Fortitude partial
	Spell Resistance: 	Yes
*/
//::
//::////////////////////////////////////////////////////////
//::
/*	 

	A thin shaft of whirling salt crystals lances out from 
	your crooked finger to strike and shred your foe.

	You must succeed on a ranged touch attack with the ray 
	to strike a target. A creature struck by a saltray takes 
	1d6 points of damage per two caster levels (maximum 5d6) 
	and must make a Fortitude save or be stunned for 1 round.

	PnP notes:  
	- Ranged touch; 1d6 per 2 CL (max 5d6).  
	- Fort save or stunned 1 round. Damage is untyped	
	
*/
//::
//::////////////////////////////////////////////////////////
//::
//:: Created by: Jaysyn
//:: Date: 2026-10-08 18:19:11
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
  
    int iAttackRoll = 0;  
  
    if (!GetIsReactionTypeFriendly(oTarget))  
    {  
        PRCSignalSpellEvent(oTarget, TRUE, nSpellID, oCaster);  
  
        iAttackRoll = PRCDoRangedTouchAttack(oTarget);  
  
        // Beam 
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,  
            EffectBeam(VFX_BEAM_COLD, oCaster, BODY_NODE_HAND, !iAttackRoll),  
            oTarget, 1.0, FALSE);  
  
        if (iAttackRoll > 0)  
        {  
            if (!PRCDoResistSpell(oCaster, oTarget, nPenetr))  
            {  
                // 1d6 per 2 CL, max 5d6 (CL 10)  
                int nDice = PRCMin(5, nCasterLevel / 2);  
                int nDamage = PRCMaximizeOrEmpower(6, nDice, nMetaMagic);  
                nDamage += SpellDamagePerDice(oCaster, nDice);  
   
                ApplyTouchAttackDamage(oCaster, oTarget, iAttackRoll,  
                    nDamage, DAMAGE_TYPE_UNTYPED);  
                PRCBonusDamage(oTarget);  
  
                SPApplyEffectToObject(DURATION_TYPE_INSTANT,  
                    EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY), oTarget);  
  
                // Fort partial: fail = stunned 1 round  
                if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC,  
                        SAVING_THROW_TYPE_SPELL))  
                {  
                    if (GetHasMettle(oTarget, SAVING_THROW_FORT))  
                        return iAttackRoll;   // Mettle: ignore rider  
  
                    effect eStun = EffectStunned();  
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT,  
                        EffectVisualEffect(VFX_IMP_STUN), oTarget);  
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,  
                        eStun, oTarget, 6.0, TRUE, nSpellID, nCasterLevel);  
                }  
            }  
        }  
    }  
  
    return iAttackRoll;    // TRUE = decrement held charge  
}  
  
void main()  
{  
    object oCaster = OBJECT_SELF;  
    int nCasterLevel = PRCGetCasterLevel(oCaster);  
    PRCSetSchool(GetSpellSchool(PRCGetSpellId()));  
    if (!X2PreSpellCastCode()) return;  
    object oTarget = PRCGetSpellTargetObject();  
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT);  
    if (!nEvent)  
    {  
        if (GetLocalInt(oCaster, PRC_SPELL_HOLD)  
            && GetHasFeat(FEAT_EF_HOLD_RAY, oCaster)  
            && oCaster == oTarget)  
        {  
            SetLocalSpellVariables(oCaster, 1);  
            return;  
        }  
        if (oCaster != oTarget)  
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