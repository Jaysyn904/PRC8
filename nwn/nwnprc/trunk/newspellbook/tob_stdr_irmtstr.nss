//////////////////////////////////////////////////
// Irresistible Mountain Strike
// tob_stdr_irmtstr.nss
// Tenjac 9/12/07
//////////////////////////////////////////////////
/** @file Irresistable Mountain Strike
Stone Dragon (Strike)
Level: Crusader 6, swordsage 6, warblade 6
Initiation Action: 1 standard action
Range: Melee attack
Target: One creature
Duration: 1 round
Saving Throw: Fortitude partial

You slam your weapon into your foe with irresistable force. He can barely move as he struggles
to marshal his defenses against you.

Your mighty attack causes your opponent to stagger aimlessly for a few key moments, leaving
him unable to act fully on his next turn.

As part of this maneuver, you make a single melee attack. This asstack deals an extra 4d6 
points of damage. A creature hit by this strike must also make a successful Fortitude save 
(DC 16 + your Str modifier) or be unable to take a standard action for 1 round. It can 
otherwise act as normal. A creature that successfully saves still takes the extra damage.

This maneuver functions only against opponents standing on the ground. A flying creature or
a levitating target need not save against the action loss effect, but still takes the extra
damage.

*/

#include "tob_inc_move"
#include "tob_movehook"
//#include "prc_alterations"

void TOBAttack(object oTarget, object oInitiator)
{
                effect eNone;
                PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, d6(4), 0, "Iron Bones Hit", "Iron Bones Miss");
                
                if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
                {
                        //Save
                        int nDC = 16 + GetAbilityModifier(ABILITY_STRENGTH, oInitiator);
                        if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE, oInitiator, 1.0))
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
                                