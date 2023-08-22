//////////////////////////////////////////////////
//  Iron Heart Focus
//  tob_irnh_ihfoc.nss
//  Tenjac 9/21/07
//////////////////////////////////////////////////
/** Iron Heart Focus
Iron Heart(Counter)
Level: Warblade 5
Prerequisite: Two Iron Heart maneuvers
Initiation Action: 1 immediate action
Range: Personal
Target: You

With a last-second burst of speed, you summon reserves of mental and pysical will and
throw off the effects of your enemy's attack.

Your training in the Iron Heart discipline grants you excellent reflexes, mental toughness,
and stamina. You can draw upon your training and focus to overcome a variety of deadly effects.

As an immediate action, you can reroll a saving throw you have just made. You must accept the 
result of this second roll, even if the new result is lower than your initial roll.

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
                SetLocalInt(oInitiator, "PRC_Power_SecondChance_Active", 1);
                DelayCommand(RoundsToSeconds(1), DeleteLocalInt(oInitiator, "PRC_Power_SecondChance_Active"));
        }
}