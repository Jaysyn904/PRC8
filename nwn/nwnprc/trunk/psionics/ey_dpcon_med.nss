//::///////////////////////////////////////////////
//:: Name ey_dpcon_med
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Simply script that will 'cause the PC to meditate
    When the PC uses an object.
*/
//:://////////////////////////////////////////////
//:: Created By: Emperor Yan
//:: Created On: Nov 14th 2004
//:://////////////////////////////////////////////


object oPC = GetLastUsedBy();
void main()
{
    if (!GetIsPC(oPC)) return;

    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE, 1.0f, 10.0f));
    AssignCommand(OBJECT_SELF, SpeakString("Power is thought, it flows from the mind and is made real."));
}
