void main()
{
    object oGulnan = GetNearestObjectByTag("M1Q0EGulnan");
    object oDevourer = GetNearestObjectByTag("M1Q0EDevourer");
    if(GetUserDefinedEventNumber() == 30)
    {
        SetLocalInt(GetArea(OBJECT_SELF),"NW_G_M1Q0CutScene",30);
        DelayCommand(2.0,SpeakOneLinerConversation("M1Q0EFinal"));
        DelayCommand(4.0,SignalEvent(oGulnan,EventUserDefined(40)));
        DelayCommand(4.0,SignalEvent(oDevourer,EventUserDefined(40)));
    }
    else if (GetUserDefinedEventNumber() == 0) // fix for enabling On Damaged UD event signal in the default script
    {
        ClearAllActions();
        ActionForceMoveToObject(GetNearestObjectByTag("M1Q0ToChapter1"));
        //ActionOpenDoor(GetNearestObjectByTag("-"));
        ActionDoCommand(DestroyObject(OBJECT_SELF));
        SetCommandable(FALSE);
    }
}