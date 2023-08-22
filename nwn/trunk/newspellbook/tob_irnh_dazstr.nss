//////////////////////////////////////////////////
//  Dazing Strike
//  tob_irnh_dazstr.nss
//  Tenjac  9/20/07
//////////////////////////////////////////////////
/** Dazing Strike
Iron Heart(Strike)
Level: Warblade 5
Prerequisite: Two Iron Heart maneuvers
Initiation Action: 1 standard action
Range: Melee attack
Target: One creature
Duration: 1 round
Saving Throw: Fortitude partial

Through focus, raw power, and expert aim, you make a mighty attack against your
foe, leaving him temporarily knocked senseless by your attack.

The proper applications of force to just the right part of a foe's anatomy allows
you to disrupt his actions. While he stumbles back, senseless, you press the 
advantage.

You make a single melee attack as part of this strike. If this attack hits, the 
target takes melee damage normally and must make a Fortitude save (DC 15 + your
Str modifier) or be dazed for 1 round.
*/

#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"

void TOBAttack(object oTarget, object oInitiator)
{
        	effect eNone;
                PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Dazing Strike Hit", "Dazing Strike Miss");
                
                if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
                {
                        // Saving Throw
                        if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (15 + GetAbilityModifier(ABILITY_STRENGTH, oInitiator))))
                        {
                                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDazed(), oTarget, RoundsToSeconds(1));
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
        	DelayCommand(0.0, TOBAttack(oTarget, oInitiator));
        }
}                