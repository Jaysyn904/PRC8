//////////////////////////////////////////////////
// Raging Mongoose
// tob_tgcw_ragmon.nss
// Tenjac   12/4/07
//////////////////////////////////////////////////
/** @file Raging Mongoose
Tiger Claw (Boost)
Level: Swordsage 8, warblade 8
Prerequisite: Three Tiger Claw maneuvers
Initiation Action: 1 swift action
Range: Personal
Target: You
Duration: End of turn

You unleash a ferocius volley of attacks, setting aside all thoughts of 
caution and self-control.

You make a flurry of deadly attacks. After initiating this boost, you can 
make two additional attacks with each weapon you wield (to a maximum of four
extra attacks if you wield two or more weapons). These extra attacks are 
made at your highest attack bonus for each of your repective weapons. You
direct these attacks at one foe.

*/

#include "tob_inc_move"
#include "tob_movehook"
//#include "prc_alterations"

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
                object oWeapR = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);  
                if(IPGetIsMeleeWeapon(oWeapR))  
                {  
                        int nDamageTypeR = GetWeaponDamageType(oWeapR);  
                        DelayCommand(0.0, PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, nDamageTypeR, "Raging Mongoose Hit", "Raging Mongoose Miss"));  
                        DelayCommand(0.0, PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, nDamageTypeR, "Raging Mongoose Hit", "Raging Mongoose Miss"));  
                }  
                  
                object oWeapL = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oInitiator);  
                if(IPGetIsMeleeWeapon(oWeapL))  
                {  
                        int nDamageTypeL = GetWeaponDamageType(oWeapL);  
                        DelayCommand(0.0, PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, nDamageTypeL, "Raging Mongoose Hit", "Raging Mongoose Miss",FALSE, OBJECT_INVALID,OBJECT_INVALID, 1));  
                        DelayCommand(0.0, PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, nDamageTypeL, "Raging Mongoose Hit", "Raging Mongoose Miss",FALSE, OBJECT_INVALID,OBJECT_INVALID, 1));                          
                }  
        }  
}

/* void main()
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
                if(IPGetIsMeleeWeapon(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator)))
                {
                        DelayCommand(0.0, PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Raging Mongoose Hit", "Raging Mongoose Miss"));
                        DelayCommand(0.0, PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Raging Mongoose Hit", "Raging Mongoose Miss"));
                }
                
                if(IPGetIsMeleeWeapon(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oInitiator)))
                {
                        DelayCommand(0.0, PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Raging Mongoose Hit", "Raging Mongoose Miss",FALSE, OBJECT_INVALID,OBJECT_INVALID, 1));
                        DelayCommand(0.0, PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Raging Mongoose Hit", "Raging Mongoose Miss",FALSE, OBJECT_INVALID,OBJECT_INVALID, 1));                        
                }
        }
} */