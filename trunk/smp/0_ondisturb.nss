// 0_ondisturb

// On Disturbed report. report feedback information via. Speak String.


void main()
{

    object oDisturber = GetLastDisturbed();// returns the object that last disturbed OBJECT_SELF.
    int nType = GetInventoryDisturbType();//returns one of the INVENTORY_DISTURB_TYPE_* constants to determine what occured.
    object oItem = GetInventoryDisturbItem();// returns the item that was either added or removed to the inventory of OBJECT_SELF.

    // Report
    SpeakString("[DISTURBED] [" + GetName(OBJECT_SELF) + "] By: " + GetName(oDisturber) + ". Took: " + GetName(oItem) + ". Type: " + IntToString(nType));
}
