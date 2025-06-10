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

#include "x0_i0_match"
#include "tob_inc_move"
#include "tob_movehook"

const float POBD_RADIUS_MELEE = 8.0;

int GetApproximateAPR(object oCreature)
{
    int nBAB = GetBaseAttackBonus(oCreature);
    int nAttacks = 1;

    if (nBAB >= 6)  nAttacks++;
    if (nBAB >= 11) nAttacks++;
    if (nBAB >= 16) nAttacks++;

    if (GetHasEffect(EFFECT_TYPE_HASTE, oCreature))
    {
        nAttacks++;
    }

    return nAttacks;
}

void PoBDZeroRecursive(object oTarget)
{
	if (GetHasSpellEffect(MOVE_DM_PEARL_BLACK_DOUBT, oTarget))
	{
		DeleteLocalInt(oTarget, "PearlOfBlackDoubtBonus");
		DelayCommand(6.0, PoBDZeroRecursive(oTarget));
	}
}

void PoBDACRecursive(object oTarget)
{
    if (!GetHasSpellEffect(MOVE_DM_PEARL_BLACK_DOUBT, oTarget))
        return;

    if (!GetIsInCombat(oTarget))
    {
        DeleteLocalInt(oTarget, "PearlOfBlackDoubtBonus");
        return;
    }

    int nTotalAPR = 0;
    location lLoc = GetLocation(oTarget);
    object oEnemy = GetFirstObjectInShape(SHAPE_SPHERE, 8.0, lLoc, TRUE, OBJECT_TYPE_CREATURE);

    while (GetIsObjectValid(oEnemy))
    {
        if (GetIsEnemy(oTarget, oEnemy) && GetIsInCombat(oEnemy))
        {
            // Melee only: must be in range and not holding ranged weapon
            object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oEnemy);
            int nWeaponBase = GetBaseItemType(oWeapon);
            if (nWeaponBase == BASE_ITEM_INVALID || !GetWeaponRanged(oWeapon))
            {
                nTotalAPR += GetApproximateAPR(oEnemy);
            }
        }

        oEnemy = GetNextObjectInShape(SHAPE_SPHERE, 8.0, lLoc);
    }

    int nBonus = 0;
    if (nTotalAPR > 0)
    {
        nBonus = 2 * nTotalAPR;
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectACIncrease(nBonus)), oTarget, 6.0);
    }

    SetLocalInt(oTarget, "PearlOfBlackDoubtBonus", nBonus);
    DelayCommand(1.0, PoBDACRecursive(oTarget));
}


void main()
{
	if (!PreManeuverCastCode())
		return;

	object oInitiator = OBJECT_SELF;
	object oTarget = PRCGetSpellTargetObject();
	struct maneuver move = EvaluateManeuver(oInitiator, oTarget);

	if (!move.bCanManeuver)
		return;

	object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oInitiator);

	IPSafeAddItemProperty(
		oItem,
		ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1),
		9999.0,
		X2_IP_ADDPROP_POLICY_KEEP_EXISTING,
		FALSE,
		FALSE
	);

	effect eDur = EffectVisualEffect(VFX_DUR_BLUESHIELDPROTECT);
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eDur), oTarget, 9999.0);

	PoBDACRecursive(oInitiator);
	PoBDZeroRecursive(oInitiator);
}
