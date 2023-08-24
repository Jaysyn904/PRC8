// 0_onperception

// On Perception report. report feedback information via. Speak String.

void main()
{
    object oPerceived = GetLastPerceived();// returns the last perceived creature (whether or not it was actually seen or heard).
    int bHeard = GetLastPerceptionHeard();// returns TRUE or FALSE as to whether the last perceived object was also heard.
    int bInaudible = GetLastPerceptionInaudible();// returns TRUE or FALSE as to whether or not the last perceived object has become inaudible (unable to be heard).
    int bSeen = GetLastPerceptionSeen();// returns TRUE or FALSE as to whether or not the last perceived object was seen.
    int bVanished = GetLastPerceptionVanished();// returns TRUE or FALSE as to whether or not the last perceived object can no longer be seen (invisible).

    SpeakString("[PERCEPTION] [" + GetName(OBJECT_SELF) + "] Perceived: " + GetName(oPerceived) + ". bHeard: " + IntToString(bHeard) +
                ". bInaudible: " + IntToString(bInaudible) + ". bSeen: " + IntToString(bSeen) +
                ". bVanished: " + IntToString(bVanished));
}
