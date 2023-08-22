/*
   ----------------
   Assassin's Stance

   tob_sdhd_assassn
   ----------------

   15/07/07 by Stratovarius
*/ /** @file

    Assassin's Stance

    Shadow Hand (Stance)
    Level: Swordsage 3
    Prerequisite: One Shadow Hand maneuver.
    Initiation Action: 1 Swift Action
    Range: Personal.
    Target: You
    Duration: Stance

    As your foe struggles to regain his defensive posture, you line up an exacting strike
    that hits with superior accuracy and deadly force.
    
    You gain +2d6 Sneak Attack.
*/

#include "tob_inc_move"
#include "tob_movehook"

void main()
{
    if(!PreManeuverCastCode()) return;

    object oInitiator    = OBJECT_SELF;
    object oTarget       = PRCGetSpellTargetObject();
    struct maneuver move = EvaluateManeuver(oInitiator, oTarget);

    if(move.bCanManeuver)
    {
        effect eLink = ExtraordinaryEffect(EffectVisualEffect(PSI_DUR_SHADOW_BODY));

        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
        DelayCommand(0.1, ExecuteScript("prc_sneak_att", oInitiator));
    }
}