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

const int CONST_LEVER_COUNT = 3;

// Do small animation.
// SpeakString(sSpeak) too.
void DoAnimation(string sSpeak);

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
    int nPulled = GetLocalInt(oDoor, "JASP_PULLED_COUNT");

    // Get the status - is the thing active. If the lock is NOT off, we
    // are OK.
    if(GetLocalInt(oDoor, "JASP_LOCK_OPEN") == FALSE)
    {
        // Check if we will reset because its been pressed once already
        if(GetLocalInt(oDoor, "JASP_LEVERDONE_" + sLever) == TRUE)
        {
            // "We have been pressed, reset the puzzle"
            DoAnimation("*Wiiirrrr, chug chug chug*");
            // Reset the current set pattern
            DeleteLocalInt(oDoor, "JASP_LOCK_NUMBERS");
        }
        else
        {
            // We will now start, or simply add it to the done list
            if(Random(CONST_LEVER_COUNT - nPulled) == 0)
            {
                // Correct lever
                nPulled++;
                SetLocalInt(oDoor, "JASP_PULLED_COUNT", nPulled);

                // Combination Successful
                if(nPulled == CONST_LEVER_COUNT)
                {
                    // DONE:

                    // Reset levers done
                    int nCnt;
                    for(nCnt = 1; nCnt <= 3; nCnt++)
                    {
                        DeleteLocalInt(oDoor, "JASP_LEVERDONE_" + IntToString(nCnt));
                    }
                    DeleteLocalInt(oDoor, "JASP_PULLED_COUNT");

                    // Open door
                    // WOO! done it!
                    // "Completed the puzzle!"
                    DoAnimation("*Wiirrr, chi-ching!*");

                    // Open the door
                    SetLocalInt(oDoor, "JASP_LOCK_OPEN", TRUE);
                    SetLocked(oDoor, TRUE);
                    AssignCommand(oDoor, ActionOpenDoor(oDoor));
                    // Delay closing
                    DelayCommand(60.0, DelayedLockResetDoor(oDoor));
                }
            }
            else
            {
                // Incorrect lever, duh-duh-duh, duuuuhhhh
                // Just clank away, and leave the variables
                DoAnimation("*Wiirrr, clink clunk!*");
            }
        }
    }
    else
    {
        // "Failed to do anything, its already open!"
        DoAnimation("*Wiirrr, clunk*");
    }
}

// Do small animation.
// SpeakString(sSpeak) too.
void DoAnimation(string sSpeak)
{
    SpeakString(sSpeak);
    PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);
    DelayCommand(1.5, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));
}

// Randomise what order the locks have to be pressed
void RandomiseLocks(object oDoor)
{
    // Reset levers done
    int nCnt;
    for(nCnt = 1; nCnt <= 3; nCnt++)
    {
        DeleteLocalInt(oDoor, "JASP_LEVERDONE_" + IntToString(nCnt));
    }
    DeleteLocalInt(oDoor, "JASP_PULLED_COUNT");
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
