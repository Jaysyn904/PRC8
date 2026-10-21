//::////////////////////////////////////////////////////////
//::
/*	
	Vertigo (sp_vertigo)
	Illusion (Phantasm) [Fear, Mind-Affecting]
	Level: 				Bard 2, Beguiler 2, Sorcerer 2, 
						Wizard 2,
	Components: 		V, S,
	Casting Time: 		1 standard action
	Range: 				Close (25 ft. + 5 ft./2 levels)
	Target: 			One living creature
	Duration: 			1 round/level (D)
	Saving Throw: 		Will disbelief
	Spell Resistance:	No
*/
//::
//::////////////////////////////////////////////////////////
//::
/*	 

	You cripple a target with sensations of falling.
	The subject of this spell becomes dizzy as the ground 
	seems to drop away beneath its feet.
	The subject must succeed on a DC 10 Balance check at the 
	start of each turn to take a move action.
	If it fails, it cannot move.
	If it fails the check by 5 or more, it falls prone.
	While affected, the subject also takes a -2 penalty on 
	attack rolls and saving throws.
	Airborne creatures receive a +4 bonus on saves against 
	this spell and do not need to make the Balance checks.
	
*/
//::
//::////////////////////////////////////////////////////////
//::
//:: Created by: Jaysyn
//:: Date: 2026-10-08 10:33:46
//::
//::////////////////////////////////////////////////////////
#include "prc_inc_spells"  
#include "prc_add_spell_dc"  
#include "prc_inc_skills"  
  
const int VERTIGO_BALANCE_DC = 10;  
const int VERTIGO_PRONE_THRESHOLD = 5;  
  
// Per-round Balance check loop. Runs while the spell effect  
// is still on the target; each iteration is one round.  
void VertigoBalanceCheck(object oTarget, int nRoundsLeft, int bFlying, int nSpellID)  
{  
    if (!GetIsObjectValid(oTarget) || GetIsDead(oTarget))  
        return;  
  
    if (!GetHasSpellEffect(nSpellID, oTarget))  
        return;  
  
    // Airborne creatures never make Balance checks (PnP)  
    if (!bFlying)  
    {  
        // PnP: DC 10 Balance check at start of each turn,  
        // failure = no move action; fail by 5+ = prone  
        int nResult = d20() + GetSkillRank(SKILL_BALANCE, oTarget);  
  
        if (nResult < VERTIGO_BALANCE_DC)  
        {  
            // "cannot take a move action" -> immobilized this round  
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,  
                EffectCutsceneImmobilize(), oTarget, 6.0);  
  
            // fail by 5 or more: falls prone  
            if (VERTIGO_BALANCE_DC - nResult >= VERTIGO_PRONE_THRESHOLD)  
            {  
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,  
                    EffectKnockdown(), oTarget, 6.0);  
            }  
        }  
    }  
  
    nRoundsLeft--;  
    if (nRoundsLeft > 0)  
        DelayCommand(6.0, VertigoBalanceCheck(oTarget, nRoundsLeft, bFlying, nSpellID));  
}  
  
void main()  
{  
    PRCSetSchool(SPELL_SCHOOL_ILLUSION);  
  
    //:: Spellcast hook  
    if (!X2PreSpellCastCode())  
    {  
        PRCSetSchool();  
        return;  
    }  
  
    //:: Declare major variables  
    object oCaster = OBJECT_SELF;  
    object oTarget = PRCGetSpellTargetObject();  
    int nSpellID   = PRCGetSpellId();  
    int nMetaMagic = PRCGetMetaMagicFeat();  
    int nDuration  = PRCGetCasterLevel(oCaster);   // 1 round/level  
  
    if (!GetIsReactionTypeFriendly(oTarget))  
    {  
        PRCSignalSpellEvent(oTarget, TRUE, nSpellID, oCaster);  
  
        // Airborne creatures get +4 on the save -> -4 DC  
        int bFlying = PRCIsFlying(oTarget);  
        int nDC = PRCGetSaveDC(oTarget, oCaster);  
        if (bFlying)  
            nDC -= 4;  
  
        // Will save
        if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC,  
                SAVING_THROW_TYPE_MIND_SPELLS, oCaster))  
        {  
            // Metamagic: extend doubles duration  
            if (nMetaMagic & METAMAGIC_EXTEND)  
                nDuration *= 2;  
  
            // -2 attack rolls, -2 saving throws while affected  
            effect eLink = EffectLinkEffects(  
                EffectAttackDecrease(2),  
                EffectSavingThrowDecrease(SAVING_THROW_ALL, 2));  
  
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,  
                eLink, oTarget, RoundsToSeconds(nDuration));  
  
            // Kick off the per-round Balance check loop  
            VertigoBalanceCheck(oTarget, nDuration, bFlying, nSpellID);  
        }  
    }  
  
    PRCSetSchool();  
}