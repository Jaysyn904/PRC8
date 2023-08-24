//////////////////////////////////////////////////
// Iron Bones
// tob_stdr_irnbns.nss
// Tenjac 9/12/07
//////////////////////////////////////////////////
/** @file Iron Bones
Stone Dragon (Strike)
Level: Crusader 6, swordsage 6, warblade 6
Prerequisite: Two Stone Dragon maneuvers
Inititation Action: 1 standard action
Range: Personal
Target: You
Duration: 1 round

As you make a successful attack, you enter a meditative state that leaves you almost
invulnerable to harm. For a few brief moments, arrows bounce off your skin, and sword
blows barely draw any blood.

This maneuver is an evolution of the techniques and abilities covered by the stone bones
maneuver. Your meditative focus, ki, and training allow your mind to overcome matter.
Weapons bounce from your skin and barely injure you.

When you use this maneuver, you make a single melee attack. If this attack hits, you gain
damage reduction 10/+5 for 1 round.
*/

#include "tob_inc_move"
#include "tob_movehook"
//#include "prc_alterations"

void TOBAttack(object oTarget, object oInitiator)
{
                effect eNone;
                PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Iron Bones Hit", "Iron Bones Miss");
                if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
                {
                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageReduction(10, DAMAGE_POWER_PLUS_FIVE, 0), oInitiator, RoundsToSeconds(1));
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
        	DelayCommand(0.0, TOBAttack(oTarget, oInitiator));
        }
}