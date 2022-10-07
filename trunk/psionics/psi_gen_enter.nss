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

int ValidateActivator(object oActivator);
void ResetArea(object oArea);
object GetExitOfNextMansion();
int GetMaxMansions();

#include "psi_inc_psifunc"

void main()
{
    // Getthe activator of the door, and make sure he is in
    // the same party as whoever cast the mansion.
    object oActivator = GetLastUsedBy();
    if (!ValidateActivator(oActivator)) return;
    if(DEBUG) DoDebug(GetName(oActivator) + " is the user of the portal and is valid");

    // Load the activator's current area and party leader.
    object aActivator = GetArea(oActivator);
    object oActivatorLeader = GetFactionLeader(oActivator);
    location oActivatorLoc = GetLocation(oActivator);

    // Get the mansion exit object, we'll dump the party by that.
    object oExit = GetExitOfNextMansion();
    if (GetIsObjectValid(oExit))
    {
    	if(DEBUG) DoDebug("Mansion Exit Object is valid");
    	object aMansion = GetAreaFromLocation(GetLocation(oExit));
        location loc = Location(aMansion, GetPosition(oExit), GetFacing(oExit));

        // Loop through all the players and check to see if they are in
        // the same party as the activator and in the same area, if they
        // are then they go to the mansion.
        object oPC = GetFirstPC();
        while (GetIsObjectValid(oPC))
        {
            if(DEBUG) DoDebug("Beginning JumpToLocation loop");
            if (aActivator == GetArea (oPC) &&
                oActivatorLeader == GetFactionLeader(oPC))
            {
                // Save the PC's return location so they always go to the right
                // spot.
                SetLocalLocation(oPC, "GENESIS_RETURNLOC", oActivatorLoc);
                if(DEBUG) DoDebug("Jumping PCs");
                AssignCommand(oPC, DelayCommand(1.0, ActionJumpToLocation(loc)));
            }

            oPC = GetNextPC();
        }

        // Link the exit door to the entrance so we know which entrance
        // to put the party back at (in case more than 1 mansion gets
        // cast).
        SetLocalObject(oExit, "GENESIS_ENTRANCE", OBJECT_SELF);
    }
    else
    {
        PrintString("All mansions are full, increase the number of mansions.");
        ActionSpeakString("NO VACANCIES!");
        DestroyObject(OBJECT_SELF);
    }
}


///////////////////////////////////////////////////////////////
//
// This method validates the door activator to make sure he is
// a member of the party of the wizard that cast the MMM spell.
// Only members of the party may enter the mansion.
//
///////////////////////////////////////////////////////////////

int ValidateActivator(object oActivator)
{
    // Get the caster that made the mansion, if we can't do that then
    // either the caster poofed or the mansion is corrupt, either
    // way destroy the door in.
    object oCaster = GetLocalObject(OBJECT_SELF, "GENESIS_CASTER");
    if (!GetIsObjectValid(oCaster))
    {
        DestroyObject(OBJECT_SELF);
        return FALSE;
    }

    // Return TRUE if the leader of the activator's party and the
    // caster's party are identical.
    return GetFactionLeader(oActivator) == GetFactionLeader(oCaster);
}


///////////////////////////////////////////////////////////////
//
// This method resets a mansion back to it's original state.
// It closes all containers/doors and deletes any items that
// do not have the "MMM_ITEM" local int attached to them.
// (to prevent players from storing stuff in the mansion)
//
///////////////////////////////////////////////////////////////

void ResetArea(object oArea)
{
    object oTarget = GetFirstObjectInArea(oArea);
    while (GetIsObjectValid(oTarget))
    {
        // All containers/doors should be closed.
        if (GetIsOpen(oTarget))
            ActionCloseDoor(oTarget);

        // Any objects not marked as part of the area should be destroyed.
        if (!GetLocalInt(oTarget, "MMM_ITEM"))
            DestroyObject(oTarget);

        oTarget = GetNextObjectInArea(oArea);
    }
}


///////////////////////////////////////////////////////////////
//
// This method returns the exit door object from the next
// mansion in sequence.  If you are using a server that
// supports multple parties you should make additional copies
// of the mansion area (changing the tags of the exit doors
// to number them in sequence, MordsMansExit01, MordsMansExit02,
// MordsMansExit03, etc. and set nNumMansions to the number of
// mansion areas you have.  This will cycle through the areas
// to prevent 2 players from getting the same mansion.
//
///////////////////////////////////////////////////////////////

int GetNextMansionIndex()
{
    int nNumMansions = GetMaxMansions();

    // Get the next available mansion from the module, and
    // convert from 0 bias to 1 bias, then increment the counter.
    object oModule = GetModule();
    int nNextMansion = GetLocalInt(oModule, "GENESIS_NEXTMANSION") + 1;
    if (nNextMansion > nNumMansions) nNextMansion = 1;

    // Save our mansion incrementor back to the module.
    SetLocalInt(oModule, "GENESIS_NEXTMANSION", nNextMansion);

    return nNextMansion;
}

object GetExitOfNextMansion()
{
    // Loop through all of the mansions looking for one that is
    // currently unoccupied.
    int nNumMansions = GetMaxMansions();
    int i;
    for(i= 0; i < nNumMansions; i++)
    {
        // Get the next mansion in sequence.
        int nNextMansion = GetNextMansionIndex();
	PrintString("nNextMansion = " + IntToString(nNextMansion));
        string sExitName = "GenesisExit" + (nNextMansion < 10 ? "0" : "") +
            IntToString(nNextMansion);

        // Get the exit object and the area that the exit object is in, i.e.
        // the mansion.
        object oExit = GetObjectByTag(sExitName, 0);
        object oArea = GetArea(oExit);

        // Loop through all of the objects in the mansion area to see if
        // there are any PC's in the area.  If there are then the mansion
        // is occupied.
        int fOccupied = FALSE;
        object oObject = GetFirstObjectInArea(oArea);
        while (GetIsObjectValid(oObject))
        {
            if (GetIsPC(oObject))
            {
		PrintString("Area " + IntToString(nNextMansion) + " is OCCUPIED");
                fOccupied = TRUE;
                break;
            }

            oObject = GetNextObjectInArea(oArea);
        }

        // If the mansion is unoccupied then return it.
	PrintString("returning mansion " + IntToString(nNextMansion));
        if (!fOccupied) return oExit;
    }

    // All mansions are occupied, sorry out of luck!
    PrintString("ALL mansions are OCCUPIED");
    return OBJECT_INVALID;
}


///////////////////////////////////////////////////////////////
//
// This method returns the maximum number of mansion instances
// available in the module.  The first time it is called it
// counts the number of mansions and saves it in the module,
// subsequent calls use the saved value.
//
///////////////////////////////////////////////////////////////

int GetMaxMansions()
{
    // Get the buffered number of mansions from the module, if
    // it's been stored.
    object oModule = GetModule();
    int nMaxMansion = GetLocalInt(oModule, "GENESIS_MAXMANSION");
    if (nMaxMansion > 0) return nMaxMansion;

    // Run a loop to keep getting mansion exit doors until we cannot get one
    // any more, this will tell us how many mansions there are in the module.
    int i = 1;
    for(;; i++)
    {
        string sExitName = "GenesisExit" + (i < 10 ? "0" : "") + IntToString(i);
        if (!GetIsObjectValid(GetObjectByTag(sExitName, 0))) break;
    }

    // Save the number of mansions in the module and return that value.
    PrintString("GetMaxMansion counts " + IntToString(i-1) + " mansions");
    SetLocalInt(oModule, "GENESIS_MAXMANSION", i - 1);
    return i - 1;
}
