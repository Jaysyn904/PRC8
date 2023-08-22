// In this code, we will say wether the item aquired was on a logon
// attempt, a normal addition, or a relog.
// The OnItemAquire event would use this.

void main()
{
    // Get item aquired
    object oItem = GetModuleItemAcquired();
    // Who by?
    object oPC = GetModuleItemAcquiredBy();
    object oPC2 = GetItemPossessor(oItem);

    // Who was it taken from?
    object oLostBy = GetModuleItemAcquiredFrom();

    // If oLostBy is invalid, we must have logged in - we are not
    // taking this from anyone
    if(!GetIsObjectValid(oLostBy) || oLostBy == oPC2)
    {
        // Is it a relog in or not?
        // It will be if oPC is invalid
        if(!GetIsObjectValid(oPC))
        {
            // It is a relog, we can use oPC2 as the person who
            // reloged in with this item to send the message to.
            SendMessageToPC(oPC2, "You have relogged in carrying the item: " + GetName(oItem));
        }
        else
        {
            // Not a relog, a normal login, we can use oPC to send
            // a message to.
            // * Note: oPC2 is always valid to use
            SendMessageToPC(oPC, "You just logged in, carrying the item: " + GetName(oItem));
        }
    }
    else
    {
        // This fires when it is a normal case of the event
        // and so oPC can be used to send the message.
        // * Note: oPC2 is always valid to use
        SendMessageToPC(oPC, "You have aquired the item: " + GetName(oItem));
    }
}
