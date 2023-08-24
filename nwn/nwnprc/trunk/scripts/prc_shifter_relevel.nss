// This script allows the user to rechoose the shape choices of a Shifter (PnP).
// It is useful when releveling the PC.
// After the script is called:
    //1) All package choices (general, major focus, and minor focus packages) can be rechosen.
    //2) All shape choices starting at the current shifter level can be rechosen.
// Called from debug console only.

#include "prc_inc_shifting"

const string SHIFTER_SHAPE_LEARNED_LEVEL = "PRC_Shifter_AutoGranted";

const string SHIFTER_GENERAL_PACKAGE_2DA = "PRC_Shifter_General_Package_2da";
const string SHIFTER_GENERAL_PACKAGE_NAME = "PRC_Shifter_General_Package_Name";

const string SHIFTER_MAJOR_FOCUS_PACKAGE_2DA = "PRC_Shifter_Major_Focus_Package_2da";
const string SHIFTER_MAJOR_FOCUS_PACKAGE_NAME = "PRC_Shifter_Major_Focus_Package_Name";
const string SHIFTER_MAJOR_FOCUS_PACKAGE_USE_COUNT_1 = "PRC_Shifter_Major_Focus_Package_Use_Count_1";
const string SHIFTER_MAJOR_FOCUS_PACKAGE_USE_COUNT_2 = "PRC_Shifter_Mafjor_Focus_Package_Use_Count_2";

const string SHIFTER_MINOR_FOCUS_PACKAGE_2DA = "PRC_Shifter_Minor_Focus_Package_2da";
const string SHIFTER_MINOR_FOCUS_PACKAGE_NAME = "PRC_Shifter_Minor_Focus_Package_Name";
const string SHIFTER_MINOR_FOCUS_PACKAGE_USE_COUNT_1 = "PRC_Shifter_Minor_Focus_Package_Use_Count_1";
const string SHIFTER_MINOR_FOCUS_PACKAGE_USE_COUNT_2 = "PRC_Shifter_Minor_Focus_Package_Use_Count_2";

void main()
{    
    object oPC = OBJECT_SELF;
    
    int nShifterLevel = GetLocalInt(oPC, "prc_shifter_relevel");
    if (nShifterLevel < 1)
        nShifterLevel = 1;
    DeleteLocalInt(oPC, "prc_shifter_relevel");
    SendMessageToPC(oPC, "Relevelling Shifter shapes starting with Shifter level " + IntToString(nShifterLevel));

    //Set auto-granted shape level to current level (so we can learn a new shape on next level up)

    SetPersistantLocalInt(oPC, SHIFTER_SHAPE_LEARNED_LEVEL, nShifterLevel-1);

    //Reset packages also

    DeletePersistantLocalString(oPC, SHIFTER_GENERAL_PACKAGE_2DA);
    DeletePersistantLocalString(oPC, SHIFTER_GENERAL_PACKAGE_NAME);

    DeletePersistantLocalString(oPC, SHIFTER_MAJOR_FOCUS_PACKAGE_2DA);
    DeletePersistantLocalString(oPC, SHIFTER_MAJOR_FOCUS_PACKAGE_NAME);
    DeletePersistantLocalInt(oPC, SHIFTER_MAJOR_FOCUS_PACKAGE_USE_COUNT_1);
    DeletePersistantLocalInt(oPC, SHIFTER_MAJOR_FOCUS_PACKAGE_USE_COUNT_2);

    DeletePersistantLocalString(oPC, SHIFTER_MINOR_FOCUS_PACKAGE_2DA);
    DeletePersistantLocalString(oPC, SHIFTER_MINOR_FOCUS_PACKAGE_NAME);
    DeletePersistantLocalInt(oPC, SHIFTER_MINOR_FOCUS_PACKAGE_USE_COUNT_1);
    DeletePersistantLocalInt(oPC, SHIFTER_MINOR_FOCUS_PACKAGE_USE_COUNT_2);
}
