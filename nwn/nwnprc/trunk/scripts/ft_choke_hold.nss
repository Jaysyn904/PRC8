//:://////////////////////////////////////////////////////////////////
//::	;-.  ,-.   ,-.  ,-. 
//::	|  ) |  ) /    (   )
//::	|-'  |-<  |     ;-: 
//::	|    |  \ \    (   )
//::	'    '  '  `-'  `-' 
//:://////////////////////////////////////////////////////////////////
//;;
//:: ft_choke_hold.nss
//;:
//:://////////////////////////////////////////////////////////////////
//:
/*
	Choke Hold
	(Oriental Adventures, p. 61)

	[General]

	You have learned the correct way to apply pressure to render an 
	opponent unconscious.
	Prerequisite

	Improved Unarmed Strike, Improved Grapple, Stunning Fist
	
	Required for
	Mighty Works Mastery I
	
	Benefit
	If you pin your opponent while grappling and maintain the pin for 
	1 full round, at the end of the round your opponent must make a 
	Fortitude saving throw (DC 10 + 1/2 your level + your Wisdom 
	modifier). If the saving throw fails, your opponent falls 
	unconscious for 1d3 rounds.
	
*/
//:
//:://////////////////////////////////////////////////////////////////
//:: 
//:: Created by: Jaysyn
//:: Created on: 2026-02-13 20:54:17
//::
//:://////////////////////////////////////////////////////////////////
#include "prc_inc_combmove"  
  
void main()  
{  
    object oPC = OBJECT_SELF;  
    object oTarget = GetSpellTargetObject();  
  
    // First, initiate a grapple. If this fails, attack normally.  
    if (!DoGrapple(oPC, oTarget, 0, TRUE, FALSE))  
    {  
        AssignCommand(oPC, ActionAttack(oTarget));  
        return;  
    }  
  
    DoGrappleOptions(oPC, oTarget, 0, GRAPPLE_PIN);  
}