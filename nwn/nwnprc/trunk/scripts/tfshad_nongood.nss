int StartingConditional()
{
    // Get the PC who is involved in this conversation
    object oPC = GetPCSpeaker();

    // The PC's alignment must be any good.
    if ( GetAlignmentGoodEvil(oPC) != ALIGNMENT_GOOD )
        return FALSE;

    // If we make it this far, we have passed all tests.
    return TRUE;
}
