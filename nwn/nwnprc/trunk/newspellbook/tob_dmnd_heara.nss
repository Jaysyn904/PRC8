//////////////////////////////////////////////////
//  Hearing the Air
//  tob_dmnd_heara.nss
//  Tenjac 
//////////////////////////////////////////////////
/** @file Hearing the Air
Diamond Mind (Stance)
Level: Swordsage 5, warblade 5
Prerequisite: Two Diamond Mind maneuvers
Inititation Action: 1 swift action
Range: Personal
Target: You
Duration: Stance

Your perception becomes so fine that you can hear the tiniest flutter of air
moving past you. Invisible foes and other hidden threats become as plain as 
day in the area of your heightened senses.

Drawing on your combat training, sharpened senses, and capability to predict
your enemy's moves, you become a faultless sentinel on the battlefield. Even
the smallest detail or stealthiest enemey cannot hope to evade your notice.

While you are in this stance, you gain blindsense out to 30 feet and a +5
insight bonus on Listen checks.

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
                effect eLink = EffectLinkEffects(EffectSkillIncrease(SKILL_LISTEN, 5), EffectUltravision());
                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
        }
}