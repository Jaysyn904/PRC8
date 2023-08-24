/*
   ----------------
   Fool's Strike

   tob_stsn_folstrk
   ----------------

   05/12/07 by Stratovarius
*/ /** @file

    Fool's Strike

    Setting Sun (Counter)
    Level: Swordsage 8
    Prerequisite: Three Setting Sun maneuvers
    Initiation Action: 1 swift action
    Range: Melee attack
    Target: One creature

    A creature strikes, but you turn the blow straight back at it.
    
    Make an opposed attack roll against the targeted creature. If you succeed, he damages himself rather than you.
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

    if(move.bCanManeuver)
    {
    	effect eNone;
    	object oInitWeap   = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
    	object oTargetWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
    	int nBase          = GetBaseAttackBonus(oTarget);
    	SetBaseAttackBonus(nBase - 1, oTarget);
    	if (DEBUG) DoDebug("tob_stsn_folstrk: GetBaseAttackBonus returns " + IntToString(nBase));
        
        //Make sure they *have* a weapon
        if(!GetIsObjectValid(oTargetWeap)) // Not a weapon
        {
            oTargetWeap = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oTarget);
            if (!GetIsObjectValid(oTargetWeap))
            {
                oTargetWeap = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oTarget);
                if (!GetIsObjectValid(oTargetWeap))
                {
                    oTargetWeap = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oTarget); // If we're down here and they don't have a weapon, damn
                }                
            }
        }
       
    	int nInit   = GetAttackBonus(oTarget, oInitiator, oInitWeap) + d20();
    	int nTarget = GetAttackBonus(oInitiator, oTarget, oTargetWeap) + d20();
    	
	    if (nInit >= nTarget)
    	{
		    // Deal damage to himself
            DelayCommand(0.0, PerformAttack(oTarget, oTarget, eNone, 0.0, 0, 0, 0, "", "", TRUE)); // Uses touch attack to make it more likely he hits
            FloatingTextStringOnCreature("Fool's Strike Success", oInitiator, FALSE);
        }
        else
        {
		    // Foes attacks as normal     
		    DelayCommand(0.0, PerformAttack(oInitiator, oTarget, eNone, 0.0, 0, 0, 0, "Hit", "Miss"));
            FloatingTextStringOnCreature("Fool's Strike Fail", oInitiator, FALSE);
        }
        
        DelayCommand(6.0, RestoreBaseAttackBonus(oTarget));
    }
    AssignCommand(oInitiator, ActionAttack(oTarget)); // Make sure they keep attacking after this.
}