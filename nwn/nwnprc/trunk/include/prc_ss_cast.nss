// Silverstar's selected divine spellbook. Low-dependency native helpers.
// Only independent PRC 4.947 divine books compatible with Chaotic Good.
// Spirit Shaman (172) and Shugenja (232) are disabled placeholders;
// Heartwarder (87) and Contemplative (215) advance another class, not own books.
// Existing Cleric/Ranger markers remain stable for exported characters.
int SSGetDivineMarker(int nClass)
{
    switch(nClass)
    {
        case 2: return 26437; // Cleric
        case 7: return 26438; // Ranger
        case 64: return 26441; // Healer
        case 157: return 26442; // Justice of Weald and Woe
        case 167: return 26443; // Knight of the Middle Circle
        case 190: return 26444; // Archivist
        case 207: return 26445; // Shaman
        case 225: return 26446; // Favoured Soul
        case 246: return 26447; // Nentyar Hunter
    }
    return -1;
}

int SSGetDivineClassForMarker(int nFeat)
{
    switch(nFeat)
    {
        case 26437: return 2; // Cleric
        case 26438: return 7; // Ranger
        case 26441: return 64; // Healer
        case 26442: return 157; // Justice of Weald and Woe
        case 26443: return 167; // Knight of the Middle Circle
        case 26444: return 190; // Archivist
        case 26445: return 207; // Shaman
        case 26446: return 225; // Favoured Soul
        case 26447: return 246; // Nentyar Hunter
    }
    return 255; // CLASS_TYPE_INVALID
}

int SSGetDivineSelectionCount(object oPC)
{
    int nCount = 0;
    int nFeat;
    for(nFeat = 26437; nFeat <= 26447; nFeat++)
        if(SSGetDivineClassForMarker(nFeat) != 255
            && GetHasFeat(nFeat, oPC, TRUE))
            nCount++;
    return nCount;
}

int SSGetSelectedDivineClass(object oPC)
{
    int nSelected = 255;
    int nCount = 0;
    int nFeat;
    for(nFeat = 26437; nFeat <= 26447; nFeat++)
    {
        int nClass = SSGetDivineClassForMarker(nFeat);
        if(nClass != 255 && GetHasFeat(nFeat, oPC, TRUE))
        {
            nSelected = nClass;
            nCount++;
        }
    }
    if(nCount != 1 || GetLevelByClass(nSelected, oPC) < 1)
        return 255;
    return nSelected;
}

int SSHasValidDivineSelection(object oPC, int nPrimaryClass)
{
    int nSelected = SSGetSelectedDivineClass(oPC);
    return nSelected != 255 && nSelected == nPrimaryClass;
}
