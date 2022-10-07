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

    With every miss, your opponents become more uncertain, their doubt growing
    like an irritating pearl in the mouth of a helpless oyster.
    
    Whenever a foe swings and misses you, you gain +2 AC.
*/

void PoBDACRecursive(object oTarget);

#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"

void PoBDACRecursive(object oTarget)
{
	// No need to do this if the spell doesn't exist
	if(GetHasSpellEffect(MOVE_DM_PEARL_BLACK_DOUBT, oTarget))
	{	// No bonuses when not in combat
		if (GetIsInCombat(oTarget))
		{
			int nBonus = GetLocalInt(oTarget, "PearlOfBlackDoubtBonus");
			nBonus += 2;
		
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectACIncrease(nBonus)), oTarget, 1.01);
			SetLocalInt(oTarget, "PearlOfBlackDoubtBonus", nBonus);
		}
		DelayCommand(1.0, PoBDACRecursive(oTarget));
	}
	
}

// All this one does is zero out the boost every six seconds.
void PoBDZeroRecursive(object oTarget)
{
	if(GetHasSpellEffect(MOVE_DM_PEARL_BLACK_DOUBT, oTarget))
	{
		DeleteLocalInt(oTarget, "PearlOfBlackDoubtBonus");
		DelayCommand(6.0, PoBDZeroRecursive(oTarget));
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

    object oInitiator    = OBJECT_SELF;
    object oTarget       = PRCGetSpellTargetObject();
    struct maneuver move = EvaluateManeuver(oInitiator, oTarget);

    if(move.bCanManeuver)
    {
	object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oInitiator);
	// Add the OnHit
	IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        effect eDur = EffectVisualEffect(VFX_DUR_BLUESHIELDPROTECT);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eDur), oTarget, 9999.0);
        
        
    }
}