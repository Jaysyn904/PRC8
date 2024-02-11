void main()
{

    //Fire cast spell at event for the specified target
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, 479, FALSE));
    ActionStartConversation(OBJECT_SELF, "mh_art_dialog", FALSE, FALSE);

}
