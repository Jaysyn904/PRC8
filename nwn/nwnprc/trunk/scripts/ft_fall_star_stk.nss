//:://////////////////////////////////////////////////////////////////
//::	;-.  ,-.   ,-.  ,-. 
//::	|  ) |  ) /    (   )
//::	|-'  |-<  |     ;-: 
//::	|    |  \ \    (   )
//::	'    '  '  `-'  `-' 
//:://////////////////////////////////////////////////////////////////
//;;
//:: ft_fall_star_stk.nss
//;:
//:://////////////////////////////////////////////////////////////////
//:
/*
	Falling Star Strike
	(Oriental Adventures, p. 62)
	
	[General]

	You have mastered the art of striking a nerve that blinds a 
	humanoid opponent.
	
	Prerequisite
	Improved Unarmed Strike (PH) , Stunning Fist (PH) (or monk's 
	stunning attack) , Base attack bonus +4, WIS 17
	
	Required for
	Meditation of War Mastery (OA)
	
	Benefit
	Against a humanoid opponent, you can make an unarmed attack that 
	has a chance of blinding your target. If your attack is successful,
	your target must attempt a Fortitude saving throw (DC 10 + 1/2 your
	level + your Wisdom modifier). If the target fails this saving throw,
	he is blinded for 1 round per level you possess. In addition to the 
	obvious effects, a blinded creature suffers a 50% miss chance in 
	combat (all opponents have full concealment), loses any Dexterity 
	bonus to AC, grants a +2 bonus on attackers' attack rolls (they 
	are effectively invisible), moves at half speed, and suffers a —4 
	penalty on most Strength- and Dexterity-based skills.

	Using this feat uses up one of your stunning attacks for the day (
	either a monk stunning attack or a use of the Stunning Fist feat).

*/
//:
//:://////////////////////////////////////////////////////////////////
//:: 
//:: Created by: Jaysyn
//:: Created on: 2026-02-13 07:58:24
//::
//:://////////////////////////////////////////////////////////////////
#include "prc_inc_spells"  
#include "prc_inc_combat"  
#include "prc_inc_stunfist"
  
void DoFallingStarStrike(object oTarget, object oInitiator)  
{  
	if (!PRCAmIAHumanoid(oTarget))  
	{  
		SendMessageToPC(oInitiator, "Target is not humanoid.");  
		AssignCommand(oInitiator, ActionAttack(oTarget)); // fallback  
		return;  
	}  
	if (!GetIsUnarmed(oInitiator))  
	{  
		SendMessageToPC(oInitiator, "You must be unarmed to use this ability.");  
		AssignCommand(oInitiator, ActionAttack(oTarget)); // fallback  
		return;  
	}  
	if (!ExpendStunfistUses(oInitiator, 1))  
	{  
		SendMessageToPC(oInitiator, "You have no stunning fist uses remaining.");  
		AssignCommand(oInitiator, ActionAttack(oTarget)); // fallback  
		return;  
	}
	
    int iLevel = GetHitDice(oInitiator);  
    effect eHit = EffectVisualEffect(VFX_COM_HIT_SONIC);  
    PerformAttack(oTarget, oInitiator, eHit, 0.0, 0, 0, 0,  
                  "Falling Star Strike Hit", "Falling Star Strike Miss");  
  
    if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))  
    {  
        int nDC = 10 + (iLevel / 2) + GetAbilityModifier(ABILITY_WISDOM, oInitiator);  
        if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))  
        {  
            effect eBlind = EffectBlindness();  
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlind, oTarget,  
                                  RoundsToSeconds(iLevel));  
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
  
    DoFallingStarStrike(oTarget, oInitiator);  
}