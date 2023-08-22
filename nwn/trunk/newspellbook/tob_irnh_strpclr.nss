//////////////////////////////////////////////////
//  Strike of Perfect Clarity
//  tob_irnh_strpclr.nss
//  Tenjac 9/26/07
//////////////////////////////////////////////////
/** Strike of Perfect Clarity
Iron Heart(Strike)
Warblade 9
Prerequisite: Four Iron Heart maneuvers
Initiation Action: 1 standard action
Range: Melee attack
Target: One creature

Your supreme focus and perfect fighting form allow you to make a single, devastating attack.
You execute a flawless strike to drop your foe with a single attack.

The ultimate Iron Heart maneuver teaches the precise, perfect cut necessary to slay almost
any creature. Only the mightiest foes can withstand this attack. Adepts of the Iron Heart
tradition seek to use this attack to end fights as quickly as possible. You might open a 
fight with a quick flurry of attacks, but once a foe is injured, you seek to end the battle
with this decisive strike.

You make a single melee attack as part of this strike. If your attack hits, it deals an 
extra 100 points of damage (in addition to your normal melee damage).
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
        object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
        effect eNone;
        
        if(move.bCanManeuver)
        {
                DelayCommand(0.0, PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 100, GetWeaponDamageType(oWeap), "Strike of Perfect Clarity Hit", "Strike of Perfect Clarity Miss"));
        }
}                