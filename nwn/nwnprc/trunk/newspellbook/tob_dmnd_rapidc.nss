/*
Rapid Counter
Diamond Mind (Counter)
Level: Swordsage 5, warblade 5
Initiation Action: 1 immediate action
Range: Touch
Target: One Creature

You lash out, your weapon a blur, hammering at the slightest gap that appears in your foe’s defenses.

The attack granted by the maneuver is not an extra attack of opportunity. You can initiate this maneuver before, after, in addition to, or instead of making an attack of opportunity against an opponent (thus possibly saving your attack of opportunity to use against another enemy later in the round).*/

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
        effect eNone;
        
        if(move.bCanManeuver)
        {
                //it's basically a free attack as an immediate action
                DelayCommand(0.0, PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Rapid Counter Hit", "Rapid Counter Miss"));
        }
}
                
