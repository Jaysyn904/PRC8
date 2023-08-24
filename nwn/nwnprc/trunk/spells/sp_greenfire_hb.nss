#include "prc_inc_spells"
#include "spinc_greenfire"

void main()
{
    // When the caster poofs, all functions calling GetAreaOfEffectCreator() will
    // fail, so in that case terminate the spell (taken from NWN cloudkill).
	object oCaster = GetAreaOfEffectCreator();
    if (!GetIsObjectValid(oCaster))
    {
		DestroyObject(OBJECT_SELF);
		return;
	}

	// Set a local int on ourselves saying that the heartbeat has fired
	SetHeartbeatFired();

	// Get the adjusted damage type.
	int nDamageType = PRCGetElementalDamageType(DAMAGE_TYPE_ACID, oCaster);
	
	// Loop through all of the objects in the AOE and run the greenfire logic on them.	
	object oTarget = GetFirstInPersistentObject();
	while (GetIsObjectValid(oTarget))
	{
		DoGreenfire(nDamageType, oCaster, oTarget);
		oTarget = GetNextInPersistentObject();
	}
}
