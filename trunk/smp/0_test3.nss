void main()
{
    if(GetListenPatternNumber() == -1)
    {
        BeginConversation();
    }

    if(GetListenPatternNumber() == 0 && GetIsPC(GetLastSpeaker()))
    {
        string sSpeak = GetMatchedSubstring(0);

        SendMessageToPC(GetLastSpeaker(), "Said: " + sSpeak);

        int iSpeak = StringToInt(sSpeak);

        SetLocalInt(OBJECT_SELF, "VFX", iSpeak);
    }
}
