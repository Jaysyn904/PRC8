//:://////////////////////////////////////////////////////////////////
//::	;-.  ,-.   ,-.  ,-. 
//::	|  ) |  ) /    (   )
//::	|-'  |-<  |     ;-: 
//::	|    |  \ \    (   )
//::	'    '  '  `-'  `-' 
//:://////////////////////////////////////////////////////////////////
//;;
//:: ft_unbal_strike.nss
//;:
//:://////////////////////////////////////////////////////////////////
//:
/*
	Unbalancing Strike
	(Oriental Adventures, p. 66)

	[General]

	You can strike a humanoid opponent's joints to knock your target 
	off balance. This feat is called kuzushi in Rokugan.
	
	Prerequisite
	Improved Unarmed Strike (PH) , Stunning Fist (PH) (or monk's 
	stunning attack) , WIS 15
	
	Benefit
	Against a humanoid opponent, you can make an unarmed attack that 
	has a chance of unbalancing your target. If your attack is 
	successful, you deal normal damage and your target must attempt 
	a Reflex saving throw (DC 10 + 1/2 your level + your Wisdom 
	modifier). If the target fails this saving throw, he is thrown off 
	balance for 1 round, losing any Dexterity bonus to AC and giving 
	attackers a +2 bonus on their attack rolls.
	
*/
//:
//:://////////////////////////////////////////////////////////////////
//:: 
//:: Created by: Jaysyn
//:: Created on: 2026-02-13 20:54:17
//::
//:://////////////////////////////////////////////////////////////////
#include "prc_inc_spells"  
#include "prc_inc_combat"  
#include "prc_inc_stunfist"  
  
void DoUnbalancingStrike(object oTarget, object oInitiator)  
{  
    // Must target a humanoid  
    if (!PRCAmIAHumanoid(oTarget))  
    {  
        SendMessageToPC(oInitiator, "Target is not humanoid.");  
        AssignCommand(oInitiator, ActionAttack(oTarget));  
        return;  
    }  
  
    // Must be unarmed  
    if (!GetIsUnarmed(oInitiator))  
    {  
        SendMessageToPC(oInitiator, "You must be unarmed to use this ability.");  
        AssignCommand(oInitiator, ActionAttack(oTarget));  
        return;  
    }  
  
    // Optional: expend a Stunning Fist use if you want it to consume one  
    if (!ExpendStunfistUses(oInitiator, 1))  
    {  
        SendMessageToPC(oInitiator, "You have no stunning fist uses remaining.");  
        AssignCommand(oInitiator, ActionAttack(oTarget));  
        return;  
    }  
  
    // Perform a normal unarmed attack  
    effect eNone;  
    PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0,  
                  "Unbalancing Strike Hit", "Unbalancing Strike Miss");  
  
    if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))  
    {  
        int nDC = 10 + (GetHitDice(oInitiator) / 2) + GetAbilityModifier(ABILITY_WISDOM, oInitiator);  
        if (!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_NONE))  
        {  
            // Lose Dex bonus to AC: apply an AC penalty equal to the target’s Dex modifier  
            int nDexPenalty = GetAbilityModifier(ABILITY_DEXTERITY, oTarget);  
            effect eLink = EffectLinkEffects(eLink, EffectACDecrease(2+nDexPenalty, AC_DODGE_BONUS));
            eLink = ExtraordinaryEffect(eLink);  
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1));  
        }  
    }
	else
	{
		//:: To prevent being flatfooted.
		AssignCommand(oInitiator, ActionAttack(oTarget)); 
	}		
}  
  
void main()  
{  
    object oInitiator = OBJECT_SELF;  
    object oTarget = PRCGetSpellTargetObject();  
    DoUnbalancingStrike(oTarget, oInitiator);  
}