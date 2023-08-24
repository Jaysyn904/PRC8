void main()
{
    SpeakString("CONVERSATION");

    object oPC = GetLastSpeaker();

    // Repeat the string said
    string sSaid = GetMatchedSubstring(0);

    SpeakString("CONV. " + GetName(oPC) + " said: " + sSaid);

    if(sSaid == "exit")
    {
        SpeakString("EXIT");
        SetPlotFlag(OBJECT_SELF, FALSE);
        DestroyObject(OBJECT_SELF);
    }
}
