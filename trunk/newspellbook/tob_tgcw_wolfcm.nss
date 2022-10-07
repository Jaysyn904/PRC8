//////////////////////////////////////////////////
// Wolf Climbs the Mountain
// tob_tgcw_wolfcm.nss
// Tenjac  12/5/07
//////////////////////////////////////////////////
/** @file Wolf Climbs the Mountain
Tiger Claw (Strike)
Level: Swordsage 6, warblade 6
Prerequisite: Two Tiger Claw maneuvers
Initiation Action: 1 full-round action
Range: Melee attack
Target: One creature

You slip between a larger foe's legs and strike its exposed side. You then cover in the shadow
of your enemy's bulk.

You can use this maneuver only against an opponent of a size category larger than yours.
As part of the maneuver, you enter your target's space without provoking an attack of opportunity.
You can then attack your target as part of this maneuver. Your attack deals an extra 5d6 points
of damage. You remain within your opponent's space after you complete this maneuver. You gain
cover against all attacks until the end of the round, including those made by the target. 
*/

#include "tob_inc_move"
#include "tob_movehook"
#include "prc_inc_combmove" 

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
        effect eNone;
        object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
        
        if(move.bCanManeuver)
        {
                //Size
                int nSize = PRCGetCreatureSize(oInitiator);
                int nTargetSize = PRCGetCreatureSize(oTarget);
                
                if(nSize == CREATURE_SIZE_SMALL)
                {
                        if(nTargetSize != CREATURE_SIZE_MEDIUM &&
                        nTargetSize != CREATURE_SIZE_LARGE &&
                        nTargetSize != CREATURE_SIZE_HUGE &&
                        nTargetSize != CREATURE_SIZE_GARGANTUAN &&
                        nTargetSize != CREATURE_SIZE_COLOSSAL)
                        {
                                SendMessageToPC(oInitiator, "Target creature is too small.");
                                return;
                        }
                }
                
                if(nSize == CREATURE_SIZE_MEDIUM)
                {
                        if(nTargetSize != CREATURE_SIZE_LARGE &&
                        nTargetSize != CREATURE_SIZE_HUGE &&
                        nTargetSize != CREATURE_SIZE_GARGANTUAN &&
                        nTargetSize != CREATURE_SIZE_COLOSSAL)
                        {
                                SendMessageToPC(oInitiator, "Target creature is too small.");
                                return;
                        }
                }
                         
                //insane amounts of tumble ;p
                effect eLink = EffectLinkEffects(EffectSkillIncrease(SKILL_TUMBLE, 50), EffectConcealment(50));             
                           
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oInitiator, RoundsToSeconds(1));
                
                //Run to target
                AssignCommand(oInitiator, ActionForceMoveToObject(oTarget, TRUE));
                int nBonus = TOBSituationalAttackBonuses(oInitiator, DISCIPLINE_TIGER_CLAW);
                DelayCommand(0.0, PerformAttack(oTarget, oInitiator, eNone, 0.0, nBonus, d6(5), GetWeaponDamageType(oWeap), "Wolf Climbs the Mountain Hit", "Wolf Climbs the Mountain Miss"));
                DelayCommand(0.1, TigerBlooded(oInitiator, oTarget));
        }
}
  