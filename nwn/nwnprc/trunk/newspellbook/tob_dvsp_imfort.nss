/*
   ----------------
   Immortal Fortitude

   tob_dvsp_imfort
   ----------------

   29/09/07 by Stratovarius
*/ /** @file

    Immortal Fortitude

    Devoted Spirit (Stance)
    Level: Crusader 8
    Prerequisite: Three Devoted Spirit maneuvers
    Initiation Action: 1 Swift Action
    Range: Personal
    Target: You
    Duration: Stance

    Despite the horrific wounds you suffer, the flash of searing spells and the crash of a foe's
    mighty attacks, you stand resolute on the field. So long as the potential for victory exists
    you fight on.
    
    While you remain in this stance, you cannot be killed through loss of hitpoints. Other effects,
    such as death spells, may still kill you. If you take damage that would reduce you below 0 hit points,
    you must make a Fortitude save or die. If you succeed, you have 1 hit point remaining. After enduring
    three saves, the stance ends.
*/

#include "tob_inc_move"
#include "tob_movehook"

void FaithfulAvenger(object oInitiator);

void FaithfulAvenger(object oInitiator)
{
	if(GetHasSpellEffect(MOVE_DS_IMMORTAL_FORTITUDE, oInitiator))
	{
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectTemporaryHitpoints(GetLevelByClass(CLASS_TYPE_CRUSADER, oInitiator)), oInitiator, 6.0);
		DelayCommand(6.0, FaithfulAvenger(oInitiator));
	}
}

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
		object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget);
		// Add the OnHit
		IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        effect eDur = EffectVisualEffect(VFX_DUR_BLUESHIELDPROTECT);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eDur), oTarget, 9999.0);
        // Need to be immortal
        SetImmortal(oTarget, TRUE);
        // If holding Faithful Avenger and not initiating the stance from the free uses
        if(GetItemPossessedBy(oTarget, "WOL_Faithful") == GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget) && GetHasManeuver(MOVE_DS_IMMORTAL_FORTITUDE, CLASS_TYPE_CRUSADER, oTarget)) FaithfulAvenger(oTarget);
    }
}