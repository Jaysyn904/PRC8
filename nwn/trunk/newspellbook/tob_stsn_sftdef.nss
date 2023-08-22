/*
    ----------------
    Shifting Defense

    tob_stsn_sftdef.nss
    ----------------

    Sept 7 2018 by Stratovarius

    Shifting Defense

    Setting Sun (Stance)
    Level: Swordsage 5
    Initiation Action: 1 Swift Action
    Range: Personal.
    Target: You.
    Duration: Stance.

    The first time per round when an opponent hits you, you reset your position ten feet away from that opponent.
*/

#include "tob_inc_move"
#include "tob_movehook"
#include "prc_inc_combmove"

void main()
{
    int nEvent = GetRunningEvent();
    object oInitiator    = OBJECT_SELF;
    object oTarget       = PRCGetSpellTargetObject();
    object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oInitiator);    

    // We're being called from the OnHit eventhook
    if(nEvent == EVENT_ITEM_ONHIT)
    {
        oItem          = GetSpellCastItem();    
    	if(!GetHasSpellEffect(MOVE_SS_SHIFTING_DEFENSE, oInitiator)) // Clean up
    	{
            // Clean Up - user needs to reactivate stance
            oItem = GetLocalObject(oInitiator, "ShiftDefArm");
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "tob_stsn_sftdef", TRUE, FALSE);
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);   
            return;    		
        }
	
	// find the target, if not already given
	if (oTarget == OBJECT_INVALID)
		oTarget = PRCGetSpellTargetObject(oInitiator);

        if(DEBUG) DoDebug("tob_stsn_sftdef: OnHit:\n" + "oInitiator = " + DebugObject2Str(oInitiator) + "\n" + "oItem = " + DebugObject2Str(oItem) + "\n" + "oTarget = " + DebugObject2Str(oTarget) + "\n");
	if (!GetLocalInt(oInitiator, "ShiftDefDelay"))
	{
		AssignCommand(oTarget, ClearAllActions(TRUE));
		_DoBullRushKnockBack(oInitiator, oTarget, 10.0);
		SetLocalInt(oInitiator, "ShiftDefDelay", TRUE);
		DelayCommand(6.0f, DeleteLocalInt(oInitiator, "ShiftDefDelay")); // Once a round
	}
    }// end if - Running OnHit event   
    else if (!PreManeuverCastCode())
    {
    // If code within the PreManeuverCastCode (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
    else
    {
    	struct maneuver move = EvaluateManeuver(oInitiator, oTarget);
    	if (move.bCanManeuver)
    	{    
    	    if (GetIsObjectValid(oItem)) // Legal items only
    	    {
		effect eDur = EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MINOR);
		SPApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(eDur), oInitiator);
    	        IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    	        AddEventScript(oItem, EVENT_ITEM_ONHIT, "tob_stsn_sftdef", TRUE, FALSE);
    	        SetLocalObject(oInitiator, "ShiftDefArm", oItem);
    	    }
    	}   		
    }    
}