/*
   ----------------
   Genesis
   
   prc_pow_genesis
   ----------------

   12/4/05 by Stratovarius

   Class: Psion (Shaper)
   Power Level: 9
   Range: Close
   Target: Ground
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 17
   
   You create a finite plane with limited access: a Demiplane. Demiplanes created by this power are very small, very minor planes,
   but they are private. Upon manifesting this power, a portal will appear infront of you that the manifester and all party members
   may use to enter the plane. Once anyone exits the plane, the plane is shut until the next manifesting of this power. Exiting the
   plane will return you to where you cast the portal.
*/

void main()
{
    PrintString("mord_exit entering");

    // Get the person walking through the door and their area, i.e.
    // the mansion.
    object oActivator = GetLastUsedBy();
    object aActivator = GetArea(oActivator);

    // Get the saved return location for the activator, we want to boot all
    // players who have this location saved on them.  This will solve the
    // problem of 2 parties getting mixed somehow, only the party that clicks
    // on the door actually gets booted.
    location lActivatorReturnLoc = GetLocalLocation(oActivator, "GENESIS_RETURNLOC");

    // Loop through all the players and check to see if they are in
    // the mansion and dump them out if they are.
    object oPC = GetFirstPC();
    while (GetIsObjectValid(oPC))
    {
        // If the PC's are in the same area and have the same return location
        // on them then boot the current PC.
        if (aActivator == GetArea (oPC) &&
            lActivatorReturnLoc == GetLocalLocation(oPC, "GENESIS_RETURNLOC"))
        {
            // Get the return location we saved on the PC and send them there.
            DeleteLocalLocation(oPC, "GENESIS_RETURNLOC");
            AssignCommand(oPC, DelayCommand(1.0,
                ActionJumpToLocation(lActivatorReturnLoc)));
        }

        oPC = GetNextPC();
    }

    // Now that all are moved, destroy the mansion door.
    object oGate = GetLocalObject(OBJECT_SELF, "GENESIS_ENTRANCE");
    DeleteLocalObject(OBJECT_SELF, "GENESIS_ENTRANCE");
    if (GetIsObjectValid(oGate)) DestroyObject(oGate, 1.0);
}