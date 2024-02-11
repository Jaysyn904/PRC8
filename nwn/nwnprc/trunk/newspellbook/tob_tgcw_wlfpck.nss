/*
   ----------------
   Wolf Pack Tactics
   
   tob_tgcw_wlfpck.nss
   ----------------

    11/12/07 by Stratovarius
*/ /** @file

    Wolf Pack Tactics

    Tiger Claw (Stance)
    Level: Swordsage 8, Warblade 8
    Prerequisite: Two Tiger Claw maneuvers
    Initiation Action: 1 Swift Action
    Range: Personal
    Target: You
    Duration: Stance

    With each stinging attach that connects against a foe, you slip around him, using the
    distraction provided by your attacks to prevent him from hindering your movement.
    
    While you are in this stance, you gain a 5 foot bonus to movement for every succesful attack,
    up to a maximum of 30 feet. This bonus applies the round after the hits strike.
*/

#include "tob_inc_move"
#include "tob_movehook"
//#include "prc_alterations"

void WolfPackTactics()
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
	object oItem = IPGetTargetedOrEquippedMeleeWeapon();
	// Add the OnHit
	IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        effect eDur = ExtraordinaryEffect(EffectVisualEffect(PSI_DUR_BURST));
        if (GetLevelByClass(CLASS_TYPE_BLOODCLAW_MASTER, oInitiator) >= 2)
        {
    		eDur = EffectLinkEffects(eDur, EffectMovementSpeedIncrease(33));
    		eDur = EffectLinkEffects(eDur, EffectACIncrease(1));
    	}         
    	if (GetLocalInt(oInitiator, "TigerFangSharpClaw"))  eDur = EffectLinkEffects(eDur, EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_BASE_WEAPON));       	       
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(eDur), oTarget);
        AddEventScript(oInitiator, EVENT_ONHEARTBEAT, "tob_tgcw_wlfpck", TRUE, FALSE);
        AddEventScript(oItem,        EVENT_ONHIT,     "tob_tgcw_wlfpck", TRUE, FALSE);
        SetLocalObject(oInitiator, "WolfPackWeapon", oItem);
    }
}

void WolfPackOnHit()
{
	object oInitiator = OBJECT_SELF;
        object oItem      = GetSpellCastItem();
        object oTarget    = PRCGetSpellTargetObject();
        if(DEBUG) DoDebug("tob_tgcw_wlfpck: OnHit:\n"
                        + "oPC = " + DebugObject2Str(oInitiator) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                        + "oTarget = " + DebugObject2Str(oTarget) + "\n"
                          );

        // Only applies to weapons
        if(GetBaseItemType(oItem) != BASE_ITEM_ARMOR && GetHasSpellEffect(MOVE_TC_WOLF_PACK_TACTICS, oInitiator))
        {
            	// Get the number of completed attacks this round and increment
            	int nCount = GetLocalInt(oInitiator, "WolfPackTactics");
            	SetLocalInt(oInitiator, "WolfPackTactics", nCount + 1);
        }
        // Target has no spell effect, so clean up.
        else if (!GetHasSpellEffect(MOVE_TC_WOLF_PACK_TACTICS, oInitiator))
        {
        	// Clean up the scripts
        	object oWeap = GetLocalObject(oInitiator, "WolfPackWeapon");
        	RemoveEventScript(oWeap,      EVENT_ITEM_ONHIT,  "tob_tgcw_wlfpck", TRUE, TRUE);
        	RemoveEventScript(oItem,      EVENT_ITEM_ONHIT,  "tob_tgcw_wlfpck", TRUE, TRUE);
        	RemoveEventScript(oInitiator, EVENT_ONHEARTBEAT, "tob_tgcw_wlfpck", TRUE, TRUE);
        	DeleteLocalObject(oInitiator, "WolfPackWeapon");
        }
}

void WolfPackOnHB()
{
	object oInitiator = OBJECT_SELF;
        object oItem      = GetLocalObject(oInitiator, "WolfPackWeapon");

        if(GetHasSpellEffect(MOVE_TC_WOLF_PACK_TACTICS, oInitiator))
        {
            	// Get the number of completed attacks this round and then reset
            	int nCount = GetLocalInt(oInitiator, "WolfPackTactics");
            	DeleteLocalInt(oInitiator, "WolfPackTactics");
            	
            	// Max of +30 feet a round/6 attacks
            	if (nCount > 6) nCount = 6;
            	// Uses a percent bonus, hence the multiplier
            	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectMovementSpeedIncrease(17*nCount), oInitiator, 6.0);
        }
        // Target has no spell effect, so clean up.
        else if (!GetHasSpellEffect(MOVE_TC_WOLF_PACK_TACTICS, oInitiator))
        {
        	// Clean up the scripts
        	RemoveEventScript(oItem,      EVENT_ITEM_ONHIT,  "tob_tgcw_wlfpck", TRUE, TRUE);
        	RemoveEventScript(oInitiator, EVENT_ONHEARTBEAT, "tob_tgcw_wlfpck", TRUE, TRUE);
        	DeleteLocalObject(oInitiator, "WolfPackWeapon");
        }
}

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("tob_tgcw_wlfpck running, event: " + IntToString(nEvent));

    // We aren't being called from any event, instead from the maneuver being activated
    if(nEvent == FALSE)
    {
    	WolfPackTactics();
    }
    else if(nEvent == EVENT_ITEM_ONHIT)
    {
    	WolfPackOnHit();
    }
    else if(nEvent == EVENT_ONHEARTBEAT)
    {
    	WolfPackOnHB();
    }    
}