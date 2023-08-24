void Debug(string sString)
{
    SendMessageToPC(GetFirstPC(), sString);
}



void main()
{
    object oMaster = GetMaster();
    // Spawn of summon
    Debug("Spawn Script: Spawned (My Name: " + GetName(OBJECT_SELF) + ". Tag: " + GetTag(OBJECT_SELF) + ". ResRef: " + GetResRef(OBJECT_SELF));

    SetIsDestroyable(FALSE);
    DelayCommand(0.01, SetIsDestroyable(TRUE));

    // Debug properties
    Debug("Master: " + GetName(oMaster));
    Debug("My 'Type of companion': " + IntToString(GetAssociateType(OBJECT_SELF)));


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
