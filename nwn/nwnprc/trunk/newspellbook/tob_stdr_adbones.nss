///////////////////////////////////////////////
// Adamantine Bones
// tob_stdr_adbones.nss
///////////////////////////////////////////////
/** @file Adamantine Bones
Stone Dragon (Strike)
Level: Crusader 8, swordsage 8, warblade 8
Prerequisite: Three Stone Dragon maneuvers
Initiation Action: 1 standard action
Range: Personal
Target: You
Duration: 1 round

You are an impenetrable tower of defiance on the battlefield. Attacking 
you is as fruitless as striking a mountain with a walking stick.

The supreme focus, mental toughness, and physical durability taught by the
Stone Dragon discipline culminate in this powerful combat maneuver. When
you make a successful attack, your mind focuses your body into the equivalent
of a living shard of rock. Even the most ferocious attacks bounce off you without
harm.

As part of this maneuver, you make a single melee attack.  If this attack hits,
you gain damage reduction 20/+5 for one round.
*/

///////////////////////////////////////////////
//   Tenjac
//   10.9.07
//////////////////////////////////////////////

#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"

void TOBAttack(object oTarget, object oInitiator)
{
                effect eNone;
                PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, DAMAGE_TYPE_SLASHING, "Adamantine Bones Hit", "Adamantine Bones Miss");
                
                if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
                {
                        effect eResist = EffectDamageReduction(20, DAMAGE_POWER_PLUS_FIVE, 0);
                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eResist, oInitiator, 6.0);
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