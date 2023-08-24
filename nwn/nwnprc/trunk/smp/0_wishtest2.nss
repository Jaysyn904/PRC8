
void main()
{
    // Spawn in "genie"

    SetListening(OBJECT_SELF, TRUE);
    SetListenPattern(OBJECT_SELF, "**", 0);

    SetFacingPoint(GetPosition(GetFirstPC()));
    ActionSpeakString("You can speak your wish sir");// Never appers
    SendMessageToPC(GetFirstPC(), "Wish debug: Spawn");

    effect eTime = EffectTimeStop();

    // 4 seconds too long
    // 1 second too little, by a small margin.
    // 1.5 should be fine
    DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eTime, OBJECT_SELF));
}
