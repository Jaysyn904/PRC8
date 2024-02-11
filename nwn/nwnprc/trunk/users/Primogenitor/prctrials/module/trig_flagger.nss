/*
    Sets a localint on the "Flagger" placeable, to toggle the flagging mode on or off
*/

void main()
{
    if (GetLocalInt(OBJECT_SELF, "flag_mode"))
    {
        SetLocalInt(OBJECT_SELF, "flag_mode", 0);
        SpeakString("Flagging mode OFF");
    }
    else
    {
        SetLocalInt(OBJECT_SELF, "flag_mode", 1);
        SpeakString("Flagging mode ON");
    }
}
