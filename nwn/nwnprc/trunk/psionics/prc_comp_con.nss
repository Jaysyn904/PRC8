void main()
{
    object oPC = GetLastSpeaker();
    AssignCommand(oPC, ActionRest());
    AssignCommand(OBJECT_SELF, SpeakString("Let this compassion shield you, as it has shielded so many others."));
}
