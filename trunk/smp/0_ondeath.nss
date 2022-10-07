// 0_ondeath
// On Death report. report feedback information via. Speak String.


void main()
{
    object oKiller = GetLastKiller();// returns the object that killed OBJECT_SELF.

    // Report
    SpeakString("[KILLED] [" + GetName(OBJECT_SELF) + "] By: " + GetName(oKiller) + ".");
}
