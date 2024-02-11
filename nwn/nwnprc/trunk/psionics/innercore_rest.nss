void main()
{
    object oPC = GetPCSpeaker();
    AssignCommand(oPC, ActionRest());
    oPC = GetLastSpeaker();
    AssignCommand(oPC, ActionRest());
    AssignCommand(OBJECT_SELF, SpeakString("At peace with yourself, here in this private extension of your mind you recover from your long travails."));
}
