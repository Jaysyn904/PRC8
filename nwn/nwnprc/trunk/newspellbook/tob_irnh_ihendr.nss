//////////////////////////////////////////////////
//  Iron Heart Endurance
//  tob_irnh_ihendr.nss
//  Tenjac 9/21/07
//////////////////////////////////////////////////
/** @file Iron Heart Endurance
Iron Heart (Boost)
Level: Warblade 6
Prerequisite: Two Iron Heart maneuvers
Initiation Action: 1 swift action
Range: Personal
Target: You

You push aside the pain of your injuries to fight on past mortal limits.

If you have half or fewer of your full normal hit points remaining, you can
initiate this maneuver to heal hit points equal to 2 x your level.
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
                int nHalfHP = GetMaxHitPoints(oInitiator);
                nHalfHP = nHalfHP/2;
                int nHP = GetCurrentHitPoints(oInitiator);
                int nHeal = GetHitDice(oInitiator) * 2;
                
                if(nHP <= nHalfHP)
                {
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEAD_HEAL), oInitiator);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHeal), oInitiator);
                }
        }
}