// This script adjusts the PC's alignment.
// Called from debug console only.

#include "inc_utility"

void main()
{
    object oPC = OBJECT_SELF;
    
    int nOldLawChaos = GetLawChaosValue(oPC); // (100=law, 0=chaos)
    int nOldGoodEvil = GetGoodEvilValue(oPC); // (100=law, 0=chaos)
    DoDebug("Old alignment: " + IntToString(nOldLawChaos) + " / " + IntToString(nOldGoodEvil));

    int nNewLawChaos = nOldLawChaos;
    int nNewGoodEvil = nOldGoodEvil;

    string sNewAlign = GetStringUpperCase(GetLocalString(oPC, "prc_setalign"));
    DeleteLocalString(oPC, "prc_setalign");
    string sNewLawChaos = GetLocalString(oPC, "prc_setalign_lc");
    DeleteLocalString(oPC, "prc_setalign_lc");
    string sNewGoodEvil = GetLocalString(oPC, "prc_setalign_ge");
    DeleteLocalString(oPC, "prc_setalign_ge");

    if (GetStringLength(sNewAlign) == 2)
    {
        string sAlign = GetSubString(sNewAlign, 0, 1);
        if (sAlign == "L")
            nNewLawChaos = 85;
        else if (sAlign == "N")
            nNewLawChaos = 50;
        else if (sAlign == "C")
            nNewLawChaos = 15;
        
        sAlign = GetSubString(sNewAlign, 1, 1);
        if (sAlign == "G")
            nNewGoodEvil = 85;
        else if (sAlign == "N")
            nNewGoodEvil = 50;
        else if (sAlign == "E")
            nNewGoodEvil = 15;
    }
 
    if (sNewLawChaos != "")
    {
        nNewLawChaos = StringToInt(sNewLawChaos);    
        if (nNewLawChaos > 100)
            nNewLawChaos = 100;
        else if (nNewLawChaos < 0)
            nNewLawChaos = 0;
    }

    if (sNewGoodEvil != "")
    {
        nNewGoodEvil = StringToInt(sNewGoodEvil);
        if (nNewGoodEvil > 100)
            nNewGoodEvil = 100;
        else if (nNewGoodEvil < 0)
            nNewGoodEvil = 0;
    }
            
    if (nNewLawChaos > nOldLawChaos)
        AdjustAlignment(oPC, ALIGNMENT_LAWFUL, nNewLawChaos - nOldLawChaos, FALSE);
    else
        AdjustAlignment(oPC, ALIGNMENT_CHAOTIC, nOldLawChaos - nNewLawChaos, FALSE);

    if (nNewGoodEvil > nOldGoodEvil)
        AdjustAlignment(oPC, ALIGNMENT_GOOD, nNewGoodEvil - nOldGoodEvil, FALSE);
    else
        AdjustAlignment(oPC, ALIGNMENT_EVIL, nOldGoodEvil - nNewGoodEvil, FALSE);

    DoDebug("New alignment: " + IntToString(nNewLawChaos) + " / " + IntToString(nNewGoodEvil));
}
