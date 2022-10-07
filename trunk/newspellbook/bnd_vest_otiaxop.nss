/*
12/03/21 by Stratovarius

Otiax, the Key to the Gate
  
The alien Otiax gives its summoners the power to open what is closed, to walk among the clouds, and to strike foes with fog that lands like a hammer.

Vestige Level: 5th
Binding DC: 25
Special Requirement: No

Influence: Otiax’s motives remain a mystery, but its influence is clear. When confronted with unopened doors or gates, you become agitated and nervous. This emotional 
state lasts until the door or gate is opened, or until you can no longer see it. Furthermore, Otiax cannot abide a lock remaining secured. Thus, whenever you see a 
key, Otiax requires that you use it to open the corresponding lock.

Granted Abilities: 
Otiax opens doors for you, lets you batter opponents with wind, and cloaks you in a protective fog that can actually lash out at foes.

Open Portal: At will as a swift action, you can open (but not close) an unlocked door, chest, box, or other object.
*/

#include "bnd_inc_bndfunc"

void main()
{
    //Declare major variables
    object oBinder = OBJECT_SELF;
    int nBinderLevel = GetBinderLevel(oBinder, VESTIGE_OTIAX);
    object oLock = PRCGetSpellTargetObject();
    // Doesn't work on locked things
    if(!GetLocked(oLock))
    {
    	if(!TakeSwiftAction(oBinder)) return;
       
        if(!GetIsOpen(oLock))
        {
            DoDoorAction(oLock, DOOR_ACTION_OPEN);
        }
    }
}

