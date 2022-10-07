// Says the lines necessary for a given part of the area

void main()
{
    object oPC = GetEnteringObject();
    if (!GetIsObjectValid(oPC)) oPC = GetLastUsedBy();
    object oTrigger = OBJECT_SELF;
    string sTag = GetTag(oTrigger);

    if (GetIsPC(oPC))
    {  
        if (sTag == "wol_a_dyenter" && !GetLocalInt(GetModule(), "wol_a_dyenter"))
        {
            AssignCommand(oPC, SpeakString("You hear bellows of fury, clashes of wood on wood, and other sounds that indicate a fight. Visible in the distance is a nightmarish group of thrashing, animate shrubs, each scaled and dark with a terrible rot."));  
            SetLocalInt(GetModule(), "wol_a_dyenter", TRUE);
        } 
        if (sTag == "wol_a_bbbenter" && !GetLocalInt(GetModule(), "wol_a_bbbenter"))
        {
            AssignCommand(oPC, SpeakString("The narrow cul-de-sac of woodlands seems peaceful, but the trail of an insane dwarf has led to this locale."));  
            SetLocalInt(GetModule(), "wol_a_bbbenter", TRUE);
        }           
    }        
}