void main()
{
    object oArea;
    int nEventID = GetLocalInt(OBJECT_SELF, "EventID");
    oArea = GetObjectByTag("Quest1A");
    SignalEvent(oArea, EventUserDefined(nEventID));
    oArea = GetObjectByTag("Quest1B");
    SignalEvent(oArea, EventUserDefined(nEventID));
    oArea = GetObjectByTag("Quest1C");
    SignalEvent(oArea, EventUserDefined(nEventID));
    oArea = GetObjectByTag("Quest1D");
    SignalEvent(oArea, EventUserDefined(nEventID));
}
