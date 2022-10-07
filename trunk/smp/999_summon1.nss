void Debug(string sString)
{
    SendMessageToPC(GetFirstPC(), sString);
}



void main()
{
    object oMaster = GetMaster();
    // heartbeat of summon
    Debug("Heartbeat script Id: " + ObjectToString(OBJECT_SELF) + ". Name: " + GetName(OBJECT_SELF) + ". Tag: " + GetTag(OBJECT_SELF) + ". ResRef: " + GetResRef(OBJECT_SELF));

    // Debug properties
    Debug("Master: " + GetName(oMaster));

    Debug("Effects Debug");

    effect eCheck = GetFirstEffect(OBJECT_SELF);
    while(GetIsEffectValid(eCheck))
    {
        Debug("Effect: " + IntToString(GetEffectType(eCheck)) + ". Creator: " + GetName(GetEffectCreator(eCheck)) + ".");

        eCheck = GetNextEffect(OBJECT_SELF);
    }

    // Master effects
    eCheck = GetFirstEffect(oMaster);
    while(GetIsEffectValid(eCheck))
    {
        Debug("Effect: " + IntToString(GetEffectType(eCheck)) + ". Creator: " + GetName(GetEffectCreator(eCheck)) + ".");

        eCheck = GetNextEffect(oMaster);
    }
}
