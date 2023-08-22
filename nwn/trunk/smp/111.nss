/*:://////////////////////////////////////////////
//:: Name Jasperre's 3 Level Puzzle script for tom23
//:: FileName J_Levelpuzzle
//:://////////////////////////////////////////////
    This will be put in 3 levers On Used events.

    - Door, must be TAGGED as "JAS_3LEVERDOOR", exactly!

    - Each plate (there are 3 you have to stand on in order) must be tagged
      seperatly:
        "JAS_3LEVER1"
        "JAS_3LEVER2"
        "JAS_3LEVER3"

    How it works:

    - Door can be in "LOCK_OPEN", TRUE or FALSe state. If TRUE, the levers
      do not work, because the door is open!
    - Door handles the total order via. strings. It hsa the "Randomise" pattern
      set as a string, 123, for example, while it has the order already done
      also set to a string, eg could be a partial: "32", and 1 would be the last
      to add.

    - If the door has a randomise pattern, we will add our number to the list

    - If the door hasn't got a randomise pattern (IE: Its been reset from
      completetion) then we make one, and add this as the first one said.

    This does a special string whenever something happens to show something
    has happened.

    WE ONLY RANDOMISE IF WE HAVE NOT BEEN COMPLETED ONCE, thus it will stay
    forever, for example, 312, until they have pressed 312.

    Not too complicated really.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//:: Created On: 25 May
//::////////////////////////////////////////////*/


// Set all the levers to "unpressed" and delete the order.
void ResetLockStatus(object oDoor);

// Do small animation.
// SpeakString(sSpeak) too.
void DoAnimation(string sSpeak);

// Set this lock to have been pressed
// If all have been done, it may open it too.
void SetLockPressed(object oDoor, string sRandomSet, string sDoneAlready, string sLever);

// Randomise what order the locks have to be pressed
void RandomiseLocks(object oDoor);

// Reset lock on this
void DelayedLockResetDoor(object oDoor);
// Assigned from DelayedLockResetDoor.
void DoCloseSelf();

void main()
{
    // Get what lever we are
    object oSelf = OBJECT_SELF;
    string sLever = GetStringRight(GetTag(oSelf), 1);
    object oDoor = GetObjectByTag("JAS_3LEVERDOOR");
    string sRandomSet = GetLocalString(oDoor, "JASP_RANDOM_LOCKNUMBER");
    string sDoneAlready = GetLocalString(oDoor, "JASP_LOCK_NUMBERS");

    // Get the status - is the thing active. If the lock is NOT off, we
    // are OK.
    if(GetLocalInt(oDoor, "JASP_LOCK_OPEN") == FALSE)
    {
        // Check if we will reset because its been pressed once already
        if(FindSubString(sLever, sDoneAlready) >= 0)
        {
            // "We have been pressed, reset the puzzle"
            DoAnimation("*Wiiirrrr, chug chug chug*");
            // Reset the current set pattern
            DeleteLocalInt(oDoor, "JASP_LOCK_NUMBERS");
        }
        else
        {
            // We will now start, or simply add it to the done list
            if(sRandomSet == "")
            {
                // Not started, start it up
                RandomiseLocks(oDoor);
                SetLockPressed(oDoor, sRandomSet, "", sLever);
            }
            else
            {
                // Else, do that we've done
                SetLockPressed(oDoor, sRandomSet, sDoneAlready, sLever);
            }
        }
    }
    else
    {
        // "Failed to do anything, its already open!"
        DoAnimation("*Wiirrr, clunk*");
    }
}

// Set all the levers to "unpressed" and delete the order.
void ResetLockStatus(object oDoor)
{
    // Delete the locals for the door randomise and door already done strings
    DeleteLocalString(oDoor, "JASP_RANDOM_LOCKNUMBER");
    DeleteLocalString(oDoor, "JASP_LOCK_NUMBERS");
}

// Do small animation.
// SpeakString(sSpeak) too.
void DoAnimation(string sSpeak)
{
    SpeakString(sSpeak);
    PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);
    DelayCommand(1.5, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));
}

// Set this lock to have been pressed
// If all have been done, it may open it too.
void SetLockPressed(object oDoor, string sRandomSet, string sDoneAlready, string sLever)
{
    // We check if this is the last one
    if(GetStringLength(sDoneAlready) == 2)
    {
        // Add it, and check if we have completed the puzzle or should
        // just reset sDoneAlready
        sDoneAlready += sLever;

        // check against sRandomSet
        if(sDoneAlready == sRandomSet)
        {
            // WOO! done it!
            // "Completed the puzzle!"
            DoAnimation("*Wiirrr, chi-ching!*");
            // Delete locked code too
            ResetLockStatus(oDoor);
            // Open the door
            SetLocalInt(oDoor, "JASP_LOCK_OPEN", TRUE);
            SetLocked(oDoor, TRUE);
            AssignCommand(oDoor, ActionOpenDoor(oDoor));
            // Delay closing
            DelayCommand(60.0, DelayedLockResetDoor(oDoor));
        }
        else
        {
            // Must have failed - DO NOT RESET LOCKS, just delete JASP_LOCK_NUMBERS
            DoAnimation("*Wiirrr, blonk!*");
            DeleteLocalInt(oDoor, "JASP_LOCK_NUMBERS");
        }
    }
    // Thus this just the first or second one
    else
    {
        // We know if its been pressed already. No more checks here

        // Add the lever to exsisting string
        sDoneAlready += sLever;

        // Set string to the door
        DoAnimation("*Wiirrr, clink clunk!*");
        SetLocalString(oDoor, "JASP_LOCK_NUMBERS", sDoneAlready);
    }
}

// Randomise what order the locks have to be pressed
void RandomiseLocks(object oDoor)
{
    // Thanks to Olias for this. Yes, I can't be bothered
    // to even do it for something this simple myself.
    string sComplete;
    int nOne = d3();
    if(nOne == 1)
    {
        // First string "1"
        sComplete += "1";

        if(d2() == 1)
        {
            // Second string "2", last "3"
            sComplete += "23";
        }
        else
        {
            // Second string "3", last "2"
            sComplete += "32";
        }
    }
    else if(nOne == 2)
    {
        // First string "2"
        sComplete += "2";

        if(d2() == 1)
        {
            // Second string "1", last "3"
            sComplete += "13";
        }
        else
        {
            // Second string "3", last "1"
            sComplete += "31";
        }
    }
    else// if(nOne == 3)
    {
        // First string "3"
        sComplete += "3";

        if(d2() == 1)
        {
            // Second string "1", last "2"
            sComplete += "12";
        }
        else
        {
            // Second string "2", last "1"
            sComplete += "21";
        }
    }
    // Randomise and set to the string JASP_RANDOM_LOCKNUMBER, on oDoor,
    // a combination of sComplete (123, 132, etc).
    SetLocalString(oDoor, "JASP_RANDOM_LOCKNUMBER", sComplete);
}

// Reset lock on this
void DelayedLockResetDoor(object oDoor)
{
    SetLocalInt(oDoor, "JASP_LOCK_OPEN", FALSE);
    AssignCommand(oDoor, DoCloseSelf());
}
// Assigned from DelayedLockResetDoor.
void DoCloseSelf()
{
    ActionCloseDoor(OBJECT_SELF);
    SetLocked(OBJECT_SELF, TRUE);
}
