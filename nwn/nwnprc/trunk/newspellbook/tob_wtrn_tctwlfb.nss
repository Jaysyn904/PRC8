/*
   ----------------
   Tactics of the Wolf, Heartbeat

   tob_wtrn_tctwlfb.nss
   ----------------

    18/08/07 by Stratovarius
*/ /** @file

    Tactics of the Wolf

    White Raven (Stance)
    Level: Crusader 3, Warblade 3
    Initiation Action: 1 Swift Action
    Range: 10ft. 
    Area: 10 ft radius centred on you.
    Duration: Stance.

    You shout orders that help coordinate your allies's efforts. They harass their
    enemies, shield each other from attacks. and otherwise maximize the support they lend to each other.
    
    All allies gain a bonus while flanking equal to +1/2 per your initiator level. 
*/

#include "tob_inc_tobfunc"
#include "tob_movehook"
//#include "prc_alterations"

void main()
{
    if(DEBUG) DoDebug("tob_wtrn_tctwlfb: Name: " + GetName(GetAreaOfEffectCreator()));

    //Start cycling through the AOE Object for viable targets
    object oTarget = GetFirstInPersistentObject(OBJECT_SELF);
    while(GetIsObjectValid(oTarget))
    {
    	// Enemies only
	if (GetIsFriend(oTarget, GetAreaOfEffectCreator()))
	{
			object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
			IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 6.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE), oTarget, 6.0);
			SetLocalInt(oTarget, "TacticsWolf", GetInitiatorLevel(GetAreaOfEffectCreator()));
			DelayCommand(5.8, DeleteLocalInt(oTarget, "TacticsWolf"));
        }
        //Get next target.
        oTarget = GetNextInPersistentObject(OBJECT_SELF);
    }
}