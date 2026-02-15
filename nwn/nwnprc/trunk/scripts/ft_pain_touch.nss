//:://////////////////////////////////////////////////////////////////
//::	;-.  ,-.   ,-.  ,-. 
//::	|  ) |  ) /    (   )
//::	|-'  |-<  |     ;-: 
//::	|    |  \ \    (   )
//::	'    '  '  `-'  `-' 
//:://////////////////////////////////////////////////////////////////
//;;
//:: ft_pain_touch.nss
//;:
//:://////////////////////////////////////////////////////////////////
//:
/*
	Pain Touch
	(Complete Warrior, p. 103)

	[General]

	You cause intense pain in an opponent with a successful stunning attack.
	
	Prerequisite
	Stunning Fist, WIS 15, base attack bonus +2
	
	Benefit
	Victims of a successful stunning attack are subject to such 
	debilitating pain that they are nauseated for 1 round following 
	the round they are stunned. Creatures that are immune to stunning 
	attacks are also immune to the effect of this feat, as are any 
	creatures that are more than one size category larger than the 
	feat user.	
*/
//:
//:://////////////////////////////////////////////////////////////////
//:: 
//:: Created by: Jaysyn
//:: Created on: 2026-02-14 19:37:06
//::
//:://////////////////////////////////////////////////////////////////
#include "prc_inc_combat"  
#include "prc_inc_stunfist"  
#include "prc_effect_inc"  
  
void main()  
{  
    object oPC = OBJECT_SELF;  
    object oTarget = PRCGetSpellTargetObject();  
      
    // Must target a humanoid  
    if (!PRCAmIAHumanoid(oTarget))  
    {  
        SendMessageToPC(oPC, "Target is not humanoid.");  
        AssignCommand(oPC, ActionAttack(oTarget));  
        return;  
    }  
  
    // Must be unarmed  
    if (!GetIsUnarmed(oPC))  
    {  
        SendMessageToPC(oPC, "You must be unarmed to use this ability.");  
        AssignCommand(oPC, ActionAttack(oTarget));  
        return;  
    }  
      
    // Check size restriction  
    int nAttackerSize = PRCGetCreatureSize(oPC);  
    int nTargetSize = PRCGetCreatureSize(oTarget);  
    if(nTargetSize > nAttackerSize + 1)  
    {  
        SendMessageToPC(oPC, "Target is too large for Pain Touch");  
		AssignCommand(oPC, ActionAttack(oTarget));  
        return;  
    }  
      
    // Check stunning fist uses  
    if(!ExpendStunfistUses(oPC, 1))  
    {  
        SendMessageToPC(oPC, "No stunning fist uses remaining");  
		AssignCommand(oPC, ActionAttack(oTarget));  
        return;  
    }  
      
    // Prepare stun effect  
    effect eStun = EffectStunned();  
    effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);  
    eStun = EffectLinkEffects(eStun, eVis);  
    eStun = SupernaturalEffect(eStun);  
      
    // Perform attack  
    string sSuccess = "*Pain Touch Hit*";  
    string sMiss = "*Pain Touch Miss*";  
      
    PerformAttackRound(oTarget, oPC, eStun, RoundsToSeconds(1), 0, 0, 0, FALSE, sSuccess, sMiss);  
      
    // Check if attack hit and apply delayed nausea  
    if(GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))  
    {  
        // Apply nausea 1 round after stun (6 second delay)  
        DelayCommand(6.0f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY,   
                         EffectNausea(oTarget, 6.0f), oTarget, RoundsToSeconds(1)));  
    }
	else
	{
		//:: To prevent being flatfooted.
		AssignCommand(oPC, ActionAttack(oTarget)); 
	}	
}