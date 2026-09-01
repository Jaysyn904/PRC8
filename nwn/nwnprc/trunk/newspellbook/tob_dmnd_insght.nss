/*
   ----------------
   Insightful Strike

   tob_dmnd_insght
   ----------------

   15/07/07 by Stratovarius
*/ /** @file

    Insightful Strike

    Diamond Mind (Strike)
    Level: Swordsage 3, Warblade 3
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature

    You study your opponent and spot a weak point in her armour. With a quick
    decisive strike, you take advantage of this weakness with a devastating attack.
    
    You make an attack. If it hits, you roll a concentration check and do damage equal to the result.
    Your weapon's normal damage modifiers do not apply.
*/

#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"

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
    	effect eNone;
		object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
		int nAB = 0;
		if (GetLocalInt(oInitiator, "SupernalAttack")) nAB += 1;
		if (GetAttackRoll(oTarget, oInitiator, oWeap, 0, nAB) > 0)
		{
			int nDam = GetSkillRank(SKILL_CONCENTRATION, oInitiator) + d20();
			int nDamType = GetWeaponDamageType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator));
		
			effect eLink = EffectLinkEffects(EffectDamage(nDam, nDamType), EffectVisualEffect(VFX_COM_HIT_POSITIVE));
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
		}
    }
}