/*
03/03/21 by Stratovarius

Andras, the Gray Knight
  
A great warrior in life, Andras is an enigma as a vestige. He gives binders prowess in combat and skill in the saddle.

Vestige Level: 4th
Binding DC: 22
Special Requirement: No.

Influence: Andras’s influence causes you to become listless and emotionally remote. Because Andras wearies of combat quickly, you become exhausted after only 10 rounds of battle, and flee from the fight for 1d4 rounds. 

Granted Abilities: 
Andras lends you some of the skills he had in life, making you a strong combatant with or without a mount.

Mount: As a full-round action, you can summon a heavy warhorse. You can use this ability once per day.
*/

#include "bnd_inc_bndfunc"
#include "x3_inc_horse"

void main()
{
    object oBinder = OBJECT_SELF;
    if (GetLocalInt(oBinder, "AndrasMount"))
        return;

    object oMount = HorseGetPaladinMount(oBinder);
    if (!GetIsObjectValid(oMount)) oMount = GetLocalObject(oBinder, "oX3PaladinMount");
    // No duplicate mounts for sanity reasons
    if (GetIsObjectValid(oMount))
    {
        if (GetIsPC(oBinder))
        {
            if (oMount == oBinder) 
            	FloatingTextStrRefOnCreature(111987, oBinder, FALSE);
            else 
            	FloatingTextStrRefOnCreature(111988, oBinder, FALSE); 
        }
        return;
    }
    
     HorseSummonPhantomSteed(1, 24);
     SetLocalInt(oBinder, "AndrasMount", TRUE);
}
