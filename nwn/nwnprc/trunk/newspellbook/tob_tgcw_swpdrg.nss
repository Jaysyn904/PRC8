//////////////////////////////////////////////////
// Swooping Dragon Strike
// Tiger Claw (Strike)
// tob_tgcw_swpdrg.nss
//////////////////////////////////////////////////
/** @file Swooping Dragon Strike
Tiger Claw (Strike)
Level: Swordsage 7, warblade 7
Prerequisite: Three Tiger Claw maneuvers
Initiation Action: 1 standard action
Range: Melee attack
Target: One creature
Saving Throw: Fortitude partial

Like a dragon you swoop down upon you foe and let loose with a devastating attack. You
leap over her and, as you soar through the air, unleash a devastating volley of attacks.

You leap over an opponent and chop down at her, ruining her defenses and striking with a
critical blow.

As part of this maneuver, you attempt a Jump check to leap over your target. The result 
of this Jump check must be sufficient to allow you to move through an opponent's space 
and over her. If you fail the Jump check needed to jump over your foe, you provoke attacks
of opportunity for the distance you jump, if applicable. If your jump was too short to clear
your opponent but far enough that you would land in a space she occupies, you land adjacent
to your opponent in the square closest to your starting square.

If your check is insufficient to jump over your target, you can also make a single attack 
against your foe with no special benefits or penalties, as long as your target is within reach.
If the check succeeds, you do not provoke attacks of opportunity for leaving threatened 
squares during your jump. Your foe loses her Dexterity bonus to AC against your melee attack.
This attack deals an extra 10d6 points of damage, and the target must succeed on a Fortitude
save (DC equal to your Jump check result) or be stunned for 1 round.
*/

#include "tob_inc_move"
#include "tob_movehook"
#include "prc_inc_combmove" 

void TOBAttack(object oTarget, object oInitiator, int iJumpRoll)
{
	object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
	effect eNone;
	int nAB = GetAbilityModifier(ABILITY_DEXTERITY, oTarget);
	int nBonus = TOBSituationalAttackBonuses(oInitiator, DISCIPLINE_TIGER_CLAW);
	DelayCommand(0.0, PerformAttack(oTarget, oInitiator, eNone, 0.0, nAB + nBonus, d6(10), GetWeaponDamageType(oWeap), "Swooping Dragon Strike Hit", "Swooping Dragon Strike Miss"));

	if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
	{
	        // Saving Throw
	        if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, iJumpRoll))
	        {
	                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectStunned(), oTarget, RoundsToSeconds(1));
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
        
        object oInitiator    = OBJECT_SELF;
        object oTarget       = PRCGetSpellTargetObject();
        struct maneuver move = EvaluateManeuver(oInitiator, oTarget);
                
        if(move.bCanManeuver)
        {
                int iJumpRoll = d20() + GetSkillRank(SKILL_JUMP, oInitiator) + GetAbilityModifier(ABILITY_STRENGTH, oInitiator);
                int nDC = 12;
                int nSizePenalty;
                int nSize = PRCGetCreatureSize(oTarget);
                effect eNone;
                
                if(nSize == CREATURE_SIZE_MEDIUM) nSizePenalty = 5;
                if(nSize == CREATURE_SIZE_LARGE) nSizePenalty = 10;
                if(nSize == CREATURE_SIZE_HUGE) nSizePenalty = 15;
                if(nSize == CREATURE_SIZE_GARGANTUAN) nSizePenalty = 20;
                if(nSize == CREATURE_SIZE_COLOSSAL) nSizePenalty = 25;
                
                nDC += nSizePenalty;
                                
                if(iJumpRoll >= nDC)
                {
                        AssignCommand(oTarget, ClearAllActions(TRUE));
                        effect eJump = EffectDisappearAppear(GetLocation(oTarget));
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eJump, oInitiator, 3.1);
                        
                        DelayCommand(0.0, TOBAttack(oTarget, oInitiator, iJumpRoll));
                }
                
                else
                {
                        FloatingTextStringOnCreature("Jump check failed.", oInitiator);
                        DelayCommand(0.0, PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Hit", "Miss"));
                }
                DelayCommand(0.1, TigerBlooded(oInitiator, oTarget));
        }
}