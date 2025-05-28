/*
   ----------------
   Pearl of Black Doubt

   tob_dmnd_prlbdt
   ----------------

   15/07/07 by Stratovarius
*/ /** @file

    Pearl of Black Doubt

    Diamond Mind (Stance)
    Level: Swordsage 3, Warmage 3
    Prerequisite: One Diamond Mind maneuver.
    Initiation Action: 1 Swift Action
    Range: Personal
    Target: You
    Duration: Stance
	
	With every miss, your opponents become more uncertain, 
	their doubt growing like an irritating pearl in the mouth 
	of a helpless oyster.

	You prey on your opponents' fear and lack of confidence. 
	Each failed attack against you reminds them that their 
	skill cannot hope to match yours.

	When you enter this stance, you become more difficult to 
	hit with each successive attack that misses you. Each 
	time an opponent misses you with a melee attack, you 
	gain a +2 dodge bonus to AC. This bonus lasts until the 
	start of your next turn and is cumulative for the round. 
	The bonus applies to any attacks made by all opponents 
	until the beginning of your next turn.

*/

#include "x0_i0_match"
#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"

void PoBDACRecursive(object oTarget, object oAttacker);


// All this one does is zero out the boost every six seconds.
void PoBDZeroRecursive(object oTarget)
{
	if(GetHasSpellEffect(MOVE_DM_PEARL_BLACK_DOUBT, oTarget))
	{
		DeleteLocalInt(oTarget, "PearlOfBlackDoubtBonus");
		DelayCommand(6.0, PoBDZeroRecursive(oTarget));
	}
}


int GetApproximateAPR(object oCreature)
{
    int nBAB = GetBaseAttackBonus(oCreature);
    int nAttacks = 1;

    // +1 attack per +5 BAB over 6
    if (nBAB >= 6) nAttacks++;
    if (nBAB >= 11) nAttacks++;
    if (nBAB >= 16) nAttacks++;

    // Add 1 if hasted
    if (GetHasEffect(EFFECT_TYPE_HASTE, oCreature))
    {
        nAttacks++;
    }

    // NOTE: Dual-wielding or monk logic not included here
	
    return nAttacks;
}


void PoBDACRecursive(object oTarget, object oAttacker)
{
	// No need to do this if the spell doesn't exist
	if(GetHasSpellEffect(MOVE_DM_PEARL_BLACK_DOUBT, oTarget))
	{	// No bonuses when not in combat
		if (GetIsInCombat(oTarget))
		{
			int nAPR = GetApproximateAPR(oAttacker);
			
			int nBonus = GetLocalInt(oTarget, "PearlOfBlackDoubtBonus");
			nBonus += 2 * nAPR;
		
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectACIncrease(nBonus)), oTarget, 6.0f);
			SetLocalInt(oTarget, "PearlOfBlackDoubtBonus", nBonus);
			
			DelayCommand(0.0, PoBDACRecursive(oTarget, oAttacker));
			DelayCommand(6.0, PoBDZeroRecursive(oTarget));
		}
		else	
		{
			DeleteLocalInt(oTarget, "PearlOfBlackDoubtBonus");
		}
		
	}	
}

void main()
{
    if (!PreManeuverCastCode())
    {
    // If code within the PreManeuverCastCode (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    object oInitiator    	= OBJECT_SELF;
	object oAttacker		= GetLastAttacker();
    object oTarget       	= PRCGetSpellTargetObject();
	
    struct maneuver move	= EvaluateManeuver(oInitiator, oTarget);

    if(move.bCanManeuver)
    {
		object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oInitiator);
	// Add the OnHit
		IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        effect eDur = EffectVisualEffect(VFX_DUR_BLUESHIELDPROTECT);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eDur), oTarget, 9999.0);
		
		PoBDACRecursive(oInitiator, oAttacker);
		
    }
}