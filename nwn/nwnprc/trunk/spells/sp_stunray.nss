//::////////////////////////////////////////////////////////
//::
/*	
	Stun Ray (sp_stunray.nss)
	Conjuration (Creation) [Electricity]
	Level: 				Sorcerer 7, Wizard 7,
	Components: 		V, S, M,
	Casting Time: 		1 standard action
	Range: 				Close (25 ft. + 5 ft./2 levels)
	Effect: 			Ray
	Duration: 			1d4+1 rounds; see text
	Saving Throw: 		Fortitude partial; see text
	Spell Resistance:	Yes
*/
//::
//::////////////////////////////////////////////////////////
//::
/*	 

	A quick jolt of electricity darts from your raised hand. 
	The slight smell of ozone lingers afterward.

	You blast an enemy with a scintillating ray of electricity. 
	You must succeed on a ranged touch attack with the ray 
	to strike a target. The target is stunned for 1d4+1 
	rounds by the ray of electricity. If the subject makes 
	a successful Fortitude save, it is stunned for only 1 
	round. Creatures that have immunity to electricity are 
	not affected by this spell.

	Material Component: A coiled copper wire.
	
	PnP notes:  
	- Ranged touch; on hit target is stunned 1d4+1 rounds.  
	- Fort save reduces the stun to only 1 round.  
	- NO damage. Electricity-immune creatures unaffected.  
	- Extend doubles the final duration in both cases:  
	  failed save -> (1d4+1)*2; successful save -> 2 rounds.	
*/
//::
//::////////////////////////////////////////////////////////
//::
//:: Created by: Jaysyn
//:: Date: 2026-10-08 13:55:00
//::
//::////////////////////////////////////////////////////////
//:: PnP notes:  
//:: - Ranged touch; on hit target is stunned 1d4+1 rounds.  
//:: - Fort save reduces the stun to only 1 round.  
//:: - NO damage. Electricity-immune creatures unaffected.  
//:: - Extend doubles the final duration in both cases.  
//:: - Ray spells hold the charge only w/ FEAT_EF_HOLD_RAY.  
//::////////////////////////////////////////////////////////  
  
#include "prc_inc_sp_tch"  
#include "prc_sp_func"  
#include "prc_add_spell_dc"  
  
//Implements the spell impact  
//  Returns TRUE if stored charges should be decremented  
//  (ray hits consume the charge; misses leave it held)  
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)  
{  
    int nMetaMagic = PRCGetMetaMagicFeat();  
    int nSaveDC    = PRCGetSaveDC(oTarget, oCaster);  
    int nPenetr    = nCasterLevel + SPGetPenetr();  
  
    //Fire cast spell at event  
    PRCSignalSpellEvent(oTarget, TRUE);  
  
    int iAttackRoll = PRCDoRangedTouchAttack(oTarget);  
  
    //Beam VFX — Ornedan is my hero (miss beam if attack failed)  
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,  
        EffectBeam(VFX_BEAM_LIGHTNING, oCaster, BODY_NODE_HAND, !iAttackRoll),  
        oTarget, 1.0f, FALSE);  
  
    if (iAttackRoll > 0)  
    {  
        // Check Spell Resistance  
        if (!PRCDoResistSpell(oCaster, oTarget, nPenetr))  
        {  
            // Stun duration: 1d4+1 rounds; Fort save -> 1 round  
            int nRounds = PRCMaximizeOrEmpower(4, 1, nMetaMagic) + 1;  
  
            if (PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC,  
                                 SAVING_THROW_TYPE_ELECTRICITY, oCaster))  
                nRounds = 1;  
  
            // Extend Spell doubles the *final* duration  
            if (nMetaMagic & METAMAGIC_EXTEND)  
                nRounds += nRounds;  
  
            effect eStun = EffectLinkEffects(  
                EffectStunned(),  
                EffectVisualEffect(VFX_IMP_STUN));  
  
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget,  
                RoundsToSeconds(nRounds));  
        }  
    }  
  
    return iAttackRoll;    // charge consumed only on a hit  
}  
  
void main()  
{  
    object oCaster = OBJECT_SELF;  
    int nCasterLevel = PRCGetCasterLevel(oCaster);  
    PRCSetSchool(SPELL_SCHOOL_CONJURATION);  
    if (!X2PreSpellCastCode())  
    {  
        PRCSetSchool();  
        return;  
    }  
    object oTarget = PRCGetSpellTargetObject();  
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //bitwise & to extract flags  
    if (!nEvent) //normal cast  
    {  
        if (GetLocalInt(oCaster, PRC_SPELL_HOLD)  
            && GetHasFeat(FEAT_EF_HOLD_RAY, oCaster)  
            && oCaster == oTarget)  
        {   //holding the charge, casting spell on self  
            SetLocalSpellVariables(oCaster, 1);   //1 charge  
            PRCSetSchool();  
            return;  
        }  
        if (oCaster != oTarget) //can't target self except to hold the charge  
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