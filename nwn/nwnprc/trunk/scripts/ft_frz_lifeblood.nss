//:://////////////////////////////////////////////////////////////////
//::	;-.  ,-.   ,-.  ,-. 
//::	|  ) |  ) /    (   )
//::	|-'  |-<  |     ;-: 
//::	|    |  \ \    (   )
//::	'    '  '  `-'  `-' 
//:://////////////////////////////////////////////////////////////////
//;;
//:: ft_frz_lifeblood.nss
//;:
//:://////////////////////////////////////////////////////////////////
//:
/*
	Freezing The Lifeblood
	(Complete Warrior, p. 99)

	[Fighter Bonus Feat, General]

	You can paralyze a humanoid opponent with an unarmed attack.
	
	Prerequisite
	Improved Unarmed Strike (PH) , Stunning Fist (PH) , WIS 17, 
	base attack bonus +10,
	
	Benefit
	Declare that you are using this feat before you make your attack 
	roll (thus, a missed attack roll ruins the attempt). Against a 
	humanoid opponent, you can make an unarmed attack that deals no 
	damage but has a chance of paralyzing your target. If your attack 
	is successful, your target must attempt a Fortitude saving throw 
	(DC 10 + 1/2 your character level + your Wis modifier). If the 
	target fails this saving throw, it is paralyzed for 1d4+1 rounds. 
	Each attempt to paralyze an opponent counts as one of your uses of 
	the Stunning Fist feat for the day. Creatures immune to stunning 
	cannot be paralyzed in this manner.
	
	Special
	A fighter may select Freezing the Lifeblood as one of his fighter 
	bonus feats.
*/
//:
//:://////////////////////////////////////////////////////////////////
//:: 
//:: Created by: Jaysyn
//:: Created on: 2026-02-13 18:31:43
//::
//:://////////////////////////////////////////////////////////////////
#include "prc_inc_spells"  
#include "prc_inc_combat"  
#include "prc_inc_stunfist"  
  
void DoFreezingTheLifeblood(object oTarget, object oInitiator)  
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
	
    // Simulate unarmed attack without damage  
    object oWeap = GetUnarmedWeapon(oInitiator);  
    int nHit = GetAttackRoll(oTarget, oInitiator, oWeap);  
    if (nHit > 0) // Hit  
    {  
        int nDC = 10 + (GetHitDice(oInitiator) / 2) + GetAbilityModifier(ABILITY_WISDOM, oInitiator);  
        if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))  
        {  
            if (GetIsImmune(oTarget, IMMUNITY_TYPE_STUN))  
            {  
                SendMessageToPC(oInitiator, "Target is immune to stunning.");  
                return;  
            }  
  
            float fDuration = RoundsToSeconds(d4() + 1);  
            effect eParal = EffectParalyze();  
            effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);  
            effect eDur2 = EffectVisualEffect(VFX_DUR_PARALYZED);  
            effect eDur3 = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);  
            effect eLink = EffectLinkEffects(eDur2, eDur);  
            eLink = EffectLinkEffects(eLink, eParal);  
            eLink = EffectLinkEffects(eLink, eDur3);  
  
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, -1, GetHitDice(oInitiator));  
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
  
    DoFreezingTheLifeblood(oTarget, oInitiator);  
}