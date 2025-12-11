//:://////////////////////////////////////////////
//:: Shifter shifting options management conversation
//:: prc_shift_convo
//:://////////////////////////////////////////////
/** @file
    PnP Shifter shifting & shifting options management
    conversation script.


    @author Ornedan
    @date   Created  - 2006.03.01
    @date   Modified - 2006.10.07 - Finished
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"
#include "prc_inc_shifting"
#include "prc_shifter_info"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_ENTRY                    = 0;
const int STAGE_CHANGESHAPE              = 1;
const int STAGE_LISTQUICKSHIFTS          = 2;
const int STAGE_DELETESHAPE              = 3;
const int STAGE_SETTINGS                 = 4;
const int STAGE_SELECTQUICKSHIFTTYPE     = 5;
const int STAGE_SELECTQUICKSHIFTSHAPE    = 6;
const int STAGE_COULDNTSHIFT             = 7;
const int STAGE_CHANGESHAPE_FILTER       = 8;
const int STAGE_CHOOSE_NEW_SHAPE_PACKAGE = 9;
const int STAGE_CHOOSE_NEW_SHAPE         = 10;
const int STAGE_SHAPE_PACKAGE_HELP       = 11;
const int STAGE_PRINTSHAPE               = 12;

const int CHOICE_CHANGESHAPE              = 1;
const int CHOICE_CHANGESHAPE_EPIC         = 2;
const int CHOICE_LISTQUICKSHIFTS          = 3;
const int CHOICE_DELETESHAPE              = 6;
const int CHOICE_SETTINGS                 = 7;
const int CHOICE_CHANGESHAPE_FILTER       = 8;
const int CHOICE_CHANGESHAPE_FILTER_ALL   = -2;
const int CHOICE_NORMAL_SHAPE_ORDER       = -3;
const int CHOICE_REVERSE_SHAPE_ORDER      = -4;
const int CHOICE_CHOOSE_NEW_SHAPE_PACKAGE = 9;
const int CHOICE_CHOOSE_NEW_SHAPE         = 10;
const int CHOICE_SHAPE_PACKAGE_HELP       = -5;
const int CHOICE_USE_GENERAL_PACKAGE      = -6;
const int CHOICE_USE_MAJOR_FOCUS_PACKAGE  = -7;
const int CHOICE_USE_MINOR_FOCUS_PACKAGE  = -8;
const int CHOICE_SKIP_LEVEL               = -9;
const int CHOICE_PRINTSHAPE               = 11;
const int CHOICE_EXPLORE_SHAPE_PACKAGES   = 12;

const int CHOICE_DRUIDWS                = 1;
const int CHOICE_STORE_TRUEAPPEARANCE   = 2;
const int CHOICE_UPDATE_RACIAL_TYPES    = 3;
const int CHOICE_DELETE_MARKED_SHAPES   = 4;

const int CHOICE_NORMAL                 = 1;
const int CHOICE_EPIC                   = 2;

const int CHOICE_BACK_TO_MAIN           = -1;
const int STRREF_BACK_TO_MAIN           = 16824794; // "Back to main menu"

const string EPICVAR                 = "PRC_ShiftConvo_Epic";
const string QSMODIFYVAR             = "PRC_ShiftConvo_QSToModify";
const string SHAPEFILTERVALUEVAR     = "PRC_ShiftConvo_Shape_Filter_Value";
const string SHAPEFILTERNEXTSTAGEVAR = "PRC_ShiftConvo_Shape_Filter_Next_Stage";
const string SHAPEREVERSEORDERVAR    = "PRC_ShiftConvo_Shape_Reverse_Order";
const string SHAPE_PACKAGE_2DA       = "PRC_ShiftConvo_Shape_Package_2da";
const string SHAPE_PACKAGE_USE_COUNT = "PRC_ShiftConvo_Shape_Package_Use_Count";
const string PRINT_MODE              = "PRC_ShiftConvo_Print_Mode";

const string SHIFTER_LEVELLING_ARRAY = "PRC_Shifter_Levelling_Array";
const string SHIFTER_SHAPE_LEARNED_LEVEL = "PRC_Shifter_AutoGranted";

const string SHIFTER_SHAPE_PACKAGE_LIST_2DA = "shft_packages";
const int SHIFTER_MAJOR_FOCUS_PACKAGE_USES_1 = 2;
const int SHIFTER_MAJOR_FOCUS_PACKAGE_USES_2 = 2;
const int SHIFTER_MINOR_FOCUS_PACKAGE_USES_1 = 1;
const int SHIFTER_MINOR_FOCUS_PACKAGE_USES_2 = 1;

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

const int DEBUG_NEW_SHAPE_LIST = FALSE;

//////////////////////////////////////////////////
/* Aid functions                                */
//////////////////////////////////////////////////

void AddShape(object oPC, int nShape, string sShapeRaceFilter)
{
    if(sShapeRaceFilter == "" || FindSubString(sShapeRaceFilter, "_" + IntToString(GetStoredTemplateRacialType(oPC, SHIFTER_TYPE_SHIFTER, nShape)) + "_") != -1)
        AddChoice(GetStoredTemplateName(oPC, SHIFTER_TYPE_SHIFTER, nShape), nShape, oPC);
}

void GenerateShapeList(object oPC, string sShapeRaceFilter, int nReverseShapeOrder)
{
    int i, nArraySize = GetNumberOfStoredTemplates(oPC, SHIFTER_TYPE_SHIFTER);
    if(nReverseShapeOrder)
        for(i = nArraySize-1; i >= 0; i--)
            AddShape(oPC, i, sShapeRaceFilter);
    else
        for(i = 0; i < nArraySize; i++)
            AddShape(oPC, i, sShapeRaceFilter);
}

void GenerateNewShapePackageList(object oPC, string sFilter)
{
    string sPackageType;
    int nPackage = 0;
    while((sPackageType = Get2DACache(SHIFTER_SHAPE_PACKAGE_LIST_2DA, "Type", nPackage)) != "")
    {
        if(sFilter == "" || sPackageType == sFilter)
        {
            string sPackageName = GetStringByStrRef(StringToInt(Get2DACache(SHIFTER_SHAPE_PACKAGE_LIST_2DA, "Name", nPackage)));
            AddChoice(sPackageName, nPackage, oPC);
        }
        nPackage++;
    }
}

int AddNewShape(string sShapeList, object oPC, int nShape, int nShifterLevel, int nCharacterLevel, string sShapeResRefFilter, int bUseCR, int nExactMatchSL, int bShowAllShapes,int bUseCR)
{
    string sShapeResRef = Get2DACache(sShapeList, "ResRef", nShape);
    if (DEBUG_NEW_SHAPE_LIST) DoDebug("AddNewShape, ShapeList:" + sShapeList + ", Shape: " + IntToString(nShape) + "='" + sShapeResRef + "', ShifterLevel: " + IntToString(nShifterLevel) + ", CharacterLevel: " + IntToString(nCharacterLevel) + ", UseCR: " + IntToString(bUseCR));

    if (!bShowAllShapes)
    {
        //Filter out shapes for which our Shifter level isn't high enough
        //Note: "SL" is the minimum Shifter Level required to be able
        //use a shape; "SLS" is the number of Shifter levels we
        //require before allowing the shape to be learned automatically
        //(though the Shifter could still learn the shape at an earlier 
        //level if it is met "in the wild").
        string sShapeSL = Get2DACache(sShapeList, "SL", nShape);
        int nShapeSL = StringToInt(sShapeSL);
        if(nExactMatchSL)
        {
            if(nShapeSL != nShifterLevel)
            {
                if (DEBUG_NEW_SHAPE_LIST) DoDebug("   SL not exact match: " + sShapeSL);
                return 0;
            }
        }
        else
        {
            if(nShapeSL > nShifterLevel)
            {
                if (DEBUG_NEW_SHAPE_LIST) DoDebug("   SL not qualified: " + sShapeSL);
                return 0;
            }
        }
        string sShapeSLS = Get2DACache(sShapeList, "SLS", nShape);
        int nShapeSLS;
        if (sShapeSLS == "")
            nShapeSLS = nShapeSL;
        else
            nShapeSLS = StringToInt(sShapeSLS);
        if(nShapeSLS > nShifterLevel)
        {
            if (DEBUG_NEW_SHAPE_LIST) DoDebug("   SLS not qualified: " + sShapeSLS);
            return 0;
        }
    
        //Filter out shapes for which our character level isn't high enough
        if(bUseCR)
        {
            string sShapeCR = Get2DACache(sShapeList, "CR", nShape);
            float fShapeCR = StringToFloat(sShapeCR);
            if(FloatToInt(fShapeCR) > nCharacterLevel)
            {
                if (DEBUG_NEW_SHAPE_LIST) DoDebug("   CL not qualified by CR: " + sShapeCR);
                return 0;
            }
        }
        else
        {
            string sShapeHD = Get2DACache(sShapeList, "HD", nShape);
            int nShapeHD = StringToInt(sShapeHD);
            if(nShapeHD > nCharacterLevel)
            {
                if (DEBUG_NEW_SHAPE_LIST) DoDebug("   CL not qualified by HD: " + sShapeHD);
                return 0;
            }
        }

        //Filter out already-known shapes
        if(FindSubString(sShapeResRefFilter, "|" + sShapeResRef + "|") != -1)
        {
            if (DEBUG_NEW_SHAPE_LIST) DoDebug("   Shape already known");
            return 0;
        }
    }

    //Add the shape to the list
    object oTemplate = _prc_inc_load_template_from_resref(sShapeResRef, 0);
    if(GetIsObjectValid(oTemplate))
    {
        string sShapeName = _prc_inc_get_stored_name_from_template(oTemplate);
        if (DEBUG_NEW_SHAPE_LIST) DoDebug("   New Shape Name: " + sShapeName);
        MyDestroyObject(oTemplate);
        AddChoice(sShapeName, nShape, oPC);
    }
    else
    {
        if (DEBUG_NEW_SHAPE_LIST) DoDebug("   Could not load shape");
        return 0;
    }

    return 1;
}

int GenerateNewShapeList(string sShapeList, object oPC, int nShifterLevel, int nCharacterLevel, string sShapeResRefFilter, int bUseCR, int nReverseShapeOrder, int bShowAllShapes)
{
    int nShapesAdded = 0;
    int nExactMatchSL = (nShifterLevel <= 9);
    int bUseCR = GetPRCSwitch(PNP_SHFT_USECR);
    if(nReverseShapeOrder)
    {
        string sResRef;
        int nCount = 0;
        while((sResRef = Get2DACache(sShapeList, "ResRef", nCount)) != "")
            nCount++;
        int i;
        for(i=nCount-1; i>=0; i--)
            nShapesAdded += AddNewShape(sShapeList, oPC, i, nShifterLevel, nCharacterLevel, sShapeResRefFilter, bUseCR, nExactMatchSL, bShowAllShapes, bUseCR);
    }
    else
    {
        string sResRef;
        int i = 0;
        while((sResRef = Get2DACache(sShapeList, "ResRef", i)) != "")
        {
            nShapesAdded += AddNewShape(sShapeList, oPC, i, nShifterLevel, nCharacterLevel, sShapeResRefFilter, bUseCR, nExactMatchSL, bShowAllShapes, bUseCR);
            i++;
        }
    }
    return nShapesAdded;
}

//////////////////////////////////////////////////
/* Main function                                */
//////////////////////////////////////////////////

void main()
{
    object oPC = GetPCSpeaker();
    /* Get the value of the local variable set by the conversation script calling
     * this script. Values:
     * DYNCONV_ABORTED     Conversation aborted
     * DYNCONV_EXITED      Conversation exited via the exit node
     * DYNCONV_SETUP_STAGE System's reply turn
     * 0                   Error - something else called the script
     * Other               The user made a choice
     */
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
    // The stage is used to determine the active conversation node.
    // 0 is the entry node.
    int nStage = GetStage(oPC);

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
        return;

    if(nValue == DYNCONV_SETUP_STAGE)
    {
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oPC))
        {
            // variable named nStage determines the current conversation node
            // Function SetHeader to set the text displayed to the PC
            // Function AddChoice to add a response option for the PC. The responses are show in order added
            if(nStage == STAGE_ENTRY)
            {
                SetHeader(GetStringByStrRef(16824364) + " :"); // "Shifter Options :"

                AddChoiceStrRef(16828366, CHOICE_CHANGESHAPE, oPC); // "Change shape"
                if(GetLevelByClass(CLASS_TYPE_PNP_SHIFTER, oPC) > 10) // Show the epic shift choice only if the character could use it
                    AddChoiceStrRef(16828367, CHOICE_CHANGESHAPE_EPIC, oPC); // "Change shape (epic)"
                AddChoiceStrRef(57482+0x01000000, CHOICE_PRINTSHAPE, oPC); // "Print shape"
                    //TODO: WHY DOESN'T THIS PRINT DEBUG INFORMATION?
                AddChoiceStrRef(16828368, CHOICE_LISTQUICKSHIFTS,  oPC); // "View / Assign shapes to your 'Quick Shift Slots'"
                AddChoiceStrRef(16828369, CHOICE_DELETESHAPE, oPC); // "Mark / unmark shapes to be deleted"

                int nShifterLevel = GetLevelByClass(CLASS_TYPE_PNP_SHIFTER, oPC);
                int nShifterLevelToLearn = GetPersistantLocalInt(oPC, SHIFTER_SHAPE_LEARNED_LEVEL) + 1;
                int nCharacterLevel = persistant_array_get_int(oPC, SHIFTER_LEVELLING_ARRAY, nShifterLevelToLearn-1);
                if (nShifterLevelToLearn <= nShifterLevel && nCharacterLevel > 0)
                    AddChoiceStrRef(57439+0x01000000, CHOICE_CHOOSE_NEW_SHAPE_PACKAGE, oPC); // "Learn new shape"
                AddChoiceStrRef(57485+0x01000000, CHOICE_EXPLORE_SHAPE_PACKAGES, oPC); // "Explore Shape Packages"

                AddChoiceStrRef(16828370,     CHOICE_SETTINGS,         oPC); // "Special settings"

                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens();          // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_CHANGESHAPE_FILTER)
            {
                SetHeader(GetStringByStrRef(57422+0x01000000)); //"Select the racial type of the shape you want to become"

                AddChoiceStrRef(STRREF_BACK_TO_MAIN, CHOICE_BACK_TO_MAIN, oPC);

                AddChoiceStrRef(57400+0x01000000, CHOICE_CHANGESHAPE_FILTER_ALL, oPC); //"All"
                
                string sRacialType;
                int i = 0;
                while((sRacialType = Get2DACache("shifter_races", "Type", i)) != "")
                {
                    string sRacialTypeName = GetStringByStrRef(StringToInt(Get2DACache("shifter_races", "Name", i)));
                    AddChoice(sRacialTypeName, i, oPC);
                    i++;
                }

                MarkStageSetUp(nStage, oPC);
                SetDefaultTokens();
            }
            else if(nStage == STAGE_CHANGESHAPE)
            {
                SetHeaderStrRef(GetLocalInt(oPC, EPICVAR) ?
                          16828371 : // "Select epic shape to become"
                          16828372   // "Select shape to become"
                          );

                // The list may be long, so list the back choice first
                AddChoiceStrRef(STRREF_BACK_TO_MAIN, CHOICE_BACK_TO_MAIN, oPC);

                if(GetLocalInt(oPC, SHAPEREVERSEORDERVAR))
                    AddChoiceStrRef(57425+0x01000000, CHOICE_NORMAL_SHAPE_ORDER, oPC); //"Show oldest shapes first"
                else
                    AddChoiceStrRef(57426+0x01000000, CHOICE_REVERSE_SHAPE_ORDER, oPC); //"Show newest shapes first"

                GenerateShapeList(oPC, GetLocalString(oPC, SHAPEFILTERVALUEVAR), GetLocalInt(oPC, SHAPEREVERSEORDERVAR));

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_COULDNTSHIFT)
            {
                SetHeaderStrRef(16828373); // "You didn't have (Epic) Greater Wildshape uses available."

                AddChoiceStrRef(STRREF_BACK_TO_MAIN, CHOICE_BACK_TO_MAIN, oPC);
            }
            else if(nStage == STAGE_LISTQUICKSHIFTS)
            {
                SetHeaderStrRef(57440+0x01000000);

                int i;
                for(i = 1; i <= 10; i++)
                    AddChoice(GetStringByStrRef(16828374) + " " + IntToString(i) + " - " // "Quick Shift Slot N - "
                            + (GetPersistantLocalString(oPC, "PRC_Shifter_Quick_" + IntToString(i) + "_ResRef") != "" ?
                               GetPersistantLocalString(oPC, "PRC_Shifter_Quick_" + IntToString(i) + "_Name") :
                               GetStringByStrRef(16825282) // "Blank"
                               ),
                              i, oPC);

                AddChoiceStrRef(STRREF_BACK_TO_MAIN, CHOICE_BACK_TO_MAIN, oPC);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_SELECTQUICKSHIFTTYPE)
            {
                SetHeaderStrRef(16828375); // "Select whether you want this 'Quick Shift Slot' to use a normal shift or an epic shift."

                AddChoiceStrRef(66788, CHOICE_NORMAL, oPC); // "Normal"
                AddChoiceStrRef(83333, CHOICE_EPIC,   oPC); // "Epic"

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_SELECTQUICKSHIFTSHAPE)
            {
                SetHeaderStrRef(GetLocalInt(oPC, EPICVAR) ?
                                16828376 : // "Select epic shape to store"
                                16828377   // "Select shape to store"
                                );

                // The list may be long, so list the back choice first
                AddChoiceStrRef(STRREF_BACK_TO_MAIN, CHOICE_BACK_TO_MAIN, oPC);

                if(GetLocalInt(oPC, SHAPEREVERSEORDERVAR))
                    AddChoiceStrRef(57425+0x01000000, CHOICE_NORMAL_SHAPE_ORDER, oPC); //"Show oldest shapes first"
                else
                    AddChoiceStrRef(57426+0x01000000, CHOICE_REVERSE_SHAPE_ORDER, oPC); //"Show newest shapes first"

                GenerateShapeList(oPC, GetLocalString(oPC, SHAPEFILTERVALUEVAR), GetLocalInt(oPC, SHAPEREVERSEORDERVAR));

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_PRINTSHAPE)
            {
                SetHeaderStrRef(57483+0x01000000); // "Select shape to print."

                // The list may be long, so list the back choice first
                AddChoiceStrRef(STRREF_BACK_TO_MAIN, CHOICE_BACK_TO_MAIN, oPC);

                if(GetLocalInt(oPC, SHAPEREVERSEORDERVAR))
                    AddChoiceStrRef(57425+0x01000000, CHOICE_NORMAL_SHAPE_ORDER, oPC); //"Show oldest shapes first"
                else
                    AddChoiceStrRef(57426+0x01000000, CHOICE_REVERSE_SHAPE_ORDER, oPC); //"Show newest shapes first"

                GenerateShapeList(oPC, GetLocalString(oPC, SHAPEFILTERVALUEVAR), GetLocalInt(oPC, SHAPEREVERSEORDERVAR));

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_DELETESHAPE)
            {
                SetHeaderStrRef(16828378); // "Select shape to delete.\nNote that if the shape is stored in any quickslots, the shape will still remain in those until you change their contents."

                // The list may be long, so list the back choice first
                AddChoiceStrRef(STRREF_BACK_TO_MAIN, CHOICE_BACK_TO_MAIN, oPC);

                if(GetLocalInt(oPC, SHAPEREVERSEORDERVAR))
                    AddChoiceStrRef(57425+0x01000000, CHOICE_NORMAL_SHAPE_ORDER, oPC); //"Show oldest shapes first"
                else
                    AddChoiceStrRef(57426+0x01000000, CHOICE_REVERSE_SHAPE_ORDER, oPC); //"Show newest shapes first"

                GenerateShapeList(oPC, GetLocalString(oPC, SHAPEFILTERVALUEVAR), GetLocalInt(oPC, SHAPEREVERSEORDERVAR));

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_SETTINGS)
            {
                SetHeaderStrRef(16828384); // "Select special setting to alter."

                AddChoice(GetStringByStrRef(16828379) // "Toggle using Druid Wildshape uses for Shifter Greater Wildshape when out of GWS uses. Current state: "
                        + (GetPersistantLocalInt(oPC, "PRC_Shifter_UseDruidWS") ?
                           GetStringByStrRef(16828380) : // "On"
                           GetStringByStrRef(16828381)   // "Off"
                           ),
                          CHOICE_DRUIDWS, oPC);
                AddChoiceStrRef(16828385, CHOICE_STORE_TRUEAPPEARANCE, oPC); // "Store your current appearance as your true appearance (will not work if polymorphed or shifted)."
                AddChoiceStrRef(57423+0x01000000, CHOICE_UPDATE_RACIAL_TYPES, oPC); //"Update racial type information"
                AddChoiceStrRef(57487+0x01000000, CHOICE_DELETE_MARKED_SHAPES, oPC); // "Delete marked shapes"
                AddChoiceStrRef(STRREF_BACK_TO_MAIN, CHOICE_BACK_TO_MAIN, oPC);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_CHOOSE_NEW_SHAPE_PACKAGE)
            {
                AddChoiceStrRef(STRREF_BACK_TO_MAIN, CHOICE_BACK_TO_MAIN, oPC);

                AddChoiceStrRef(57441+0x01000000, CHOICE_SHAPE_PACKAGE_HELP, oPC); //"Explanation of shape packages"

                int nShifterLevel = GetLevelByClass(CLASS_TYPE_PNP_SHIFTER, oPC);
                int nShifterLevelToLearn = GetPersistantLocalInt(oPC, SHIFTER_SHAPE_LEARNED_LEVEL) + 1;
                int nCharacterLevel = persistant_array_get_int(oPC, SHIFTER_LEVELLING_ARRAY, nShifterLevelToLearn-1);
                int bPrintMode = GetLocalInt(oPC, PRINT_MODE);

                if(bPrintMode)
                {
                    string sString = GetStringByStrRef(57448+0x01000000);
                    GenerateNewShapePackageList(oPC, "");
                }
                else if(GetPersistantLocalString(oPC, SHIFTER_GENERAL_PACKAGE_2DA) == "")
                {
                    SetHeaderStrRef(57442+0x01000000); //"Select general shape package"
                    GenerateNewShapePackageList(oPC, "general");
                }
                else if(GetPersistantLocalString(oPC, SHIFTER_MAJOR_FOCUS_PACKAGE_2DA) == "" && nShifterLevelToLearn >= 11)
                {
                    SetHeaderStrRef(57443+0x01000000); //"Select major focus shape package"
                    GenerateNewShapePackageList(oPC, "focus");
                }
                else if(GetPersistantLocalString(oPC, SHIFTER_MINOR_FOCUS_PACKAGE_2DA) == "" && nShifterLevelToLearn >= 11)
                {
                    SetHeaderStrRef(57444+0x01000000); //"Select minor focus shape package"
                    GenerateNewShapePackageList(oPC, "focus");
                }
                else if(nShifterLevelToLearn == 10)
                {
                    string sString = GetStringByStrRef(57448+0x01000000);
                    sString = ReplaceString(sString, "%(SL)", IntToString(nShifterLevelToLearn));
                    sString = ReplaceString(sString, "%(CL)", IntToString(nCharacterLevel));
                    SetHeader(sString);
                    GenerateNewShapePackageList(oPC, "");
                    AddChoiceStrRef(57446+0x01000000, CHOICE_SKIP_LEVEL, oPC); //"Skip this level"
                }
                else
                {
                    string sString = GetStringByStrRef(57449+0x01000000);
                    sString = ReplaceString(sString, "%(SL)", IntToString(nShifterLevelToLearn));
                    sString = ReplaceString(sString, "%(CL)", IntToString(nCharacterLevel));
                    SetHeader(sString);

                    string sPackageName = GetPersistantLocalString(oPC, SHIFTER_GENERAL_PACKAGE_NAME);
                    sString = GetStringByStrRef(57451+0x01000000); //"General package"
                    sString = ReplaceString(sString, "%(PACKAGE_NAME)", sPackageName);
                    AddChoice(sString, CHOICE_USE_GENERAL_PACKAGE, oPC);

                    int nUsesRemaining = 0;
                    if(nShifterLevelToLearn >= 21)
                        nUsesRemaining = SHIFTER_MAJOR_FOCUS_PACKAGE_USES_2 - GetPersistantLocalInt(oPC, SHIFTER_MAJOR_FOCUS_PACKAGE_USE_COUNT_2);
                    else if(nShifterLevelToLearn >= 11)
                        nUsesRemaining = SHIFTER_MAJOR_FOCUS_PACKAGE_USES_1 - GetPersistantLocalInt(oPC, SHIFTER_MAJOR_FOCUS_PACKAGE_USE_COUNT_1);
                    if(nUsesRemaining > 0)
                    {
                        sPackageName = GetPersistantLocalString(oPC, SHIFTER_MAJOR_FOCUS_PACKAGE_NAME);
                        sString = GetStringByStrRef(57452+0x01000000); //"Major focus package"
                        sString = ReplaceString(sString, "%(PACKAGE_NAME)", sPackageName);
                        sString = ReplaceString(sString, "%(USES_REMAINING)", IntToString(nUsesRemaining));
                        AddChoice(sString, CHOICE_USE_MAJOR_FOCUS_PACKAGE, oPC);
                    }

                    nUsesRemaining = 0;
                    if(nShifterLevelToLearn >= 21)
                        nUsesRemaining = SHIFTER_MINOR_FOCUS_PACKAGE_USES_2 - GetPersistantLocalInt(oPC, SHIFTER_MINOR_FOCUS_PACKAGE_USE_COUNT_2);
                    else if(nShifterLevelToLearn >= 11)
                        nUsesRemaining = SHIFTER_MINOR_FOCUS_PACKAGE_USES_1 - GetPersistantLocalInt(oPC, SHIFTER_MINOR_FOCUS_PACKAGE_USE_COUNT_1);
                    if(nUsesRemaining > 0)
                    {
                        sPackageName = GetPersistantLocalString(oPC, SHIFTER_MINOR_FOCUS_PACKAGE_NAME);
                        sString = GetStringByStrRef(57453+0x01000000); //"Minor focus package"
                        sString = ReplaceString(sString, "%(PACKAGE_NAME)", sPackageName);
                        sString = ReplaceString(sString, "%(USES_REMAINING)", IntToString(nUsesRemaining));
                        AddChoice(sString, CHOICE_USE_MINOR_FOCUS_PACKAGE, oPC);
                    }
                    
                    AddChoiceStrRef(57446+0x01000000, CHOICE_SKIP_LEVEL, oPC); //"Skip this level"
                }
                
                MarkStageSetUp(nStage, oPC);
            }
            else if (nStage == STAGE_CHOOSE_NEW_SHAPE)
            {
                int nShifterLevel = GetLevelByClass(CLASS_TYPE_PNP_SHIFTER, oPC);
                int nShifterLevelToLearn = GetPersistantLocalInt(oPC, SHIFTER_SHAPE_LEARNED_LEVEL) + 1;
                int nCharacterLevel = persistant_array_get_int(oPC, SHIFTER_LEVELLING_ARRAY, nShifterLevelToLearn-1);
                int bPrintMode = GetLocalInt(oPC, PRINT_MODE);

                AddChoiceStrRef(STRREF_BACK_TO_MAIN, CHOICE_BACK_TO_MAIN, oPC);

                if (bPrintMode)
                {
                    SetHeaderStrRef(57483+0x01000000);

                    if(GetLocalInt(oPC, SHAPEREVERSEORDERVAR))
                        AddChoiceStrRef(57425+0x01000000, CHOICE_NORMAL_SHAPE_ORDER, oPC); //"Show oldest shapes first"
                    else
                        AddChoiceStrRef(57426+0x01000000, CHOICE_REVERSE_SHAPE_ORDER, oPC); //"Show newest shapes first"                        

                    string sPackage2da = GetLocalString(oPC, SHAPE_PACKAGE_2DA);
                    GenerateNewShapeList(
                        sPackage2da,
                        oPC, 
                        nShifterLevelToLearn,
                        nCharacterLevel,
                        GetStoredTemplateFilter(oPC, SHIFTER_TYPE_SHIFTER), 
                        GetPRCSwitch(PNP_SHFT_USECR),
                        GetLocalInt(oPC, SHAPEREVERSEORDERVAR),
                        TRUE
                        );
                }
                else if(nShifterLevelToLearn <= nShifterLevel && nCharacterLevel > 0)
                {
                    string sString = GetStringByStrRef(57450+0x01000000);
                    sString = ReplaceString(sString, "%(SL)", IntToString(nShifterLevelToLearn));
                    sString = ReplaceString(sString, "%(CL)", IntToString(nCharacterLevel));
                    SetHeader(sString);

                    if(GetLocalInt(oPC, SHAPEREVERSEORDERVAR))
                        AddChoiceStrRef(57425+0x01000000, CHOICE_NORMAL_SHAPE_ORDER, oPC); //"Show oldest shapes first"
                    else
                        AddChoiceStrRef(57426+0x01000000, CHOICE_REVERSE_SHAPE_ORDER, oPC); //"Show newest shapes first"                        

                    string sPackage2da = GetLocalString(oPC, SHAPE_PACKAGE_2DA);
                    int nShapesAdded = GenerateNewShapeList(
                        sPackage2da,
                        oPC, 
                        nShifterLevelToLearn,
                        nCharacterLevel,
                        GetStoredTemplateFilter(oPC, SHIFTER_TYPE_SHIFTER), 
                        GetPRCSwitch(PNP_SHFT_USECR),
                        GetLocalInt(oPC, SHAPEREVERSEORDERVAR),
                        FALSE
                        );
                    
                    if(!nShapesAdded)
                    {
                        SetHeaderStrRef(57445+0x01000000); //"Sorry, you've already learned all of the shapes available at this level."
                        AddChoiceStrRef(57446+0x01000000, CHOICE_SKIP_LEVEL, oPC); //"Skip this level"
                    }
                }
                else
                {
                    SetHeaderStrRef(57447+0x01000000); //"No shapes to learn; already up to date"
                }
                
                MarkStageSetUp(nStage, oPC);
            }
            else if (nStage == STAGE_SHAPE_PACKAGE_HELP)
            {
                SetHeaderStrRef(57441+0x01000000);
                AddChoiceStrRef(57466+0x01000000, CHOICE_BACK_TO_MAIN, oPC);
                AddChoiceStrRef(57467+0x01000000, CHOICE_BACK_TO_MAIN, oPC);
                AddChoiceStrRef(57468+0x01000000, CHOICE_BACK_TO_MAIN, oPC);
                AddChoiceStrRef(57469+0x01000000, CHOICE_BACK_TO_MAIN, oPC);
                AddChoiceStrRef(57470+0x01000000, CHOICE_BACK_TO_MAIN, oPC);
                AddChoiceStrRef(57471+0x01000000, CHOICE_BACK_TO_MAIN, oPC);
                AddChoiceStrRef(57472+0x01000000, CHOICE_BACK_TO_MAIN, oPC);
                AddChoiceStrRef(STRREF_BACK_TO_MAIN, CHOICE_BACK_TO_MAIN, oPC);
                MarkStageSetUp(nStage, oPC);
            }
        }

        // Do token setup
        SetupTokens();
    }
    // End of conversation cleanup
    else if(nValue == DYNCONV_EXITED)
    {
        // Add any locals set through this conversation
        DeleteLocalInt(oPC, EPICVAR);
        DeleteLocalInt(oPC, QSMODIFYVAR);
        DeleteLocalString(oPC, SHAPEFILTERVALUEVAR);
        DeleteLocalInt(oPC, SHAPEFILTERNEXTSTAGEVAR);
        //Don't DeleteLocalInt(oPC, SHAPEREVERSEORDERVAR);
        DeleteLocalString(oPC, SHAPE_PACKAGE_2DA);
        DeleteLocalString(oPC, SHAPE_PACKAGE_USE_COUNT);
    }
    // Abort conversation cleanup.
    // NOTE: This section is only run when the conversation is aborted
    // while aborting is allowed. When it isn't, the dynconvo infrastructure
    // handles restoring the conversation in a transparent manner
    else if(nValue == DYNCONV_ABORTED)
    {
        // Add any locals set through this conversation
        DeleteLocalInt(oPC, EPICVAR);
        DeleteLocalInt(oPC, QSMODIFYVAR);
        DeleteLocalString(oPC, SHAPEFILTERVALUEVAR);
        DeleteLocalInt(oPC, SHAPEFILTERNEXTSTAGEVAR);
        //Don't DeleteLocalInt(oPC, SHAPEREVERSEORDERVAR);
        DeleteLocalString(oPC, SHAPE_PACKAGE_2DA);
        DeleteLocalString(oPC, SHAPE_PACKAGE_USE_COUNT);
    }
    // Handle PC responses
    else
    {
        // variable named nChoice is the value of the player's choice as stored when building the choice list
        // variable named nStage determines the current conversation node
        int nChoice = GetChoice(oPC);
        ClearCurrentStage(oPC);
        if(nStage == STAGE_ENTRY)
        {
            switch(nChoice)
            {
                case CHOICE_CHANGESHAPE_EPIC:
                    SetLocalInt(oPC, EPICVAR, TRUE);
                case CHOICE_CHANGESHAPE:
                    nStage = STAGE_CHANGESHAPE_FILTER;
                    SetLocalInt(oPC, SHAPEFILTERNEXTSTAGEVAR, STAGE_CHANGESHAPE);
                    break;                    

                case CHOICE_LISTQUICKSHIFTS:
                    nStage = STAGE_LISTQUICKSHIFTS;
                    break;
                case CHOICE_PRINTSHAPE:
                    nStage = STAGE_CHANGESHAPE_FILTER;
                    SetLocalInt(oPC, SHAPEFILTERNEXTSTAGEVAR, STAGE_PRINTSHAPE);
                    break;
                case CHOICE_DELETESHAPE:
                    nStage = STAGE_CHANGESHAPE_FILTER;
                    SetLocalInt(oPC, SHAPEFILTERNEXTSTAGEVAR, STAGE_DELETESHAPE);
                    break;
                case CHOICE_SETTINGS:
                    nStage = STAGE_SETTINGS;
                    break;
                case CHOICE_CHOOSE_NEW_SHAPE_PACKAGE:
                    SetLocalInt(oPC, PRINT_MODE, FALSE);
                    nStage = STAGE_CHOOSE_NEW_SHAPE_PACKAGE;
                    break;
                case CHOICE_EXPLORE_SHAPE_PACKAGES:
                    SetLocalInt(oPC, PRINT_MODE, TRUE);
                    nStage = STAGE_CHOOSE_NEW_SHAPE_PACKAGE;
                    break;

                default:
                    DoDebug("prc_shift_convo: ERROR: Unknown choice value at STAGE_ENTRY: " + IntToString(nChoice));
            }
        }
        else if(nStage == STAGE_CHANGESHAPE_FILTER)
        {
            if(nChoice == CHOICE_BACK_TO_MAIN)
                nStage = STAGE_ENTRY;
            else
            {
                if(nChoice == CHOICE_CHANGESHAPE_FILTER_ALL)
                    SetLocalString(oPC, SHAPEFILTERVALUEVAR, "");
                else
                {
                    string sRacialType = Get2DACache("shifter_races", "Type", nChoice);
                    SetLocalString(oPC, SHAPEFILTERVALUEVAR, "_" + sRacialType + "_");
                }
                nStage = GetLocalInt(oPC, SHAPEFILTERNEXTSTAGEVAR);
            }            
        }
        else if(nStage == STAGE_CHANGESHAPE)
        {
            // Return to main menu?
            if(nChoice == CHOICE_BACK_TO_MAIN)
                nStage = STAGE_ENTRY;
            else if(nChoice == CHOICE_NORMAL_SHAPE_ORDER)
                SetLocalInt(oPC, SHAPEREVERSEORDERVAR, 0);
            else if (nChoice == CHOICE_REVERSE_SHAPE_ORDER)
                SetLocalInt(oPC, SHAPEREVERSEORDERVAR, 1);
            else
            {
                // Make sure the character has uses left for shifting
                int bPaid = FALSE;
                if(!GetLocalInt(oPC, EPICVAR)) // Normal shapechange
                {
                    // First try paying using Greater Wildshape uses
                    if(GetHasFeat(FEAT_PRESTIGE_SHIFTER_GWSHAPE_1, oPC))
                    {
                        DecrementRemainingFeatUses(oPC, FEAT_PRESTIGE_SHIFTER_GWSHAPE_1);

                        // If we would reach 0 uses this way, see if we could pay with Druid Wildshape uses instead
                        if(!GetHasFeat(FEAT_PRESTIGE_SHIFTER_GWSHAPE_1, oPC)    &&
                           GetPersistantLocalInt(oPC, "PRC_Shifter_UseDruidWS") &&
                           GetHasFeat(FEAT_WILD_SHAPE, oPC)
                           )
                        {
                            IncrementRemainingFeatUses(oPC, FEAT_PRESTIGE_SHIFTER_GWSHAPE_1);
                            DecrementRemainingFeatUses(oPC, FEAT_WILD_SHAPE);
                        }

                        bPaid = TRUE;
                    }
                    // Otherwise try paying with Druid Wildshape uses
                    else if(GetPersistantLocalInt(oPC, "PRC_Shifter_UseDruidWS") &&
                            GetHasFeat(FEAT_WILD_SHAPE, oPC)
                            )
                    {
                        DecrementRemainingFeatUses(oPC, FEAT_WILD_SHAPE);
                        bPaid = TRUE;
                    }
                }
                // Epic shift, uses Epic Greater Wildshape
                else if(GetHasFeat(FEAT_PRESTIGE_SHIFTER_EGWSHAPE_1, oPC))
                {
                    DecrementRemainingFeatUses(oPC, FEAT_PRESTIGE_SHIFTER_EGWSHAPE_1);
                    bPaid = TRUE;
                }

                // If the user could pay for the shifting, do it
                if(bPaid)
                {
                    // Choice is index into the template list
                    if(!ShiftIntoResRef(oPC, SHIFTER_TYPE_SHIFTER,
                                        GetStoredTemplate(oPC, SHIFTER_TYPE_SHIFTER, nChoice),
                                        GetLocalInt(oPC, EPICVAR)
                                        )
                       )
                    {
                        // In case of shifting failure, refund the shifting use
                        if(GetLocalInt(oPC, EPICVAR))
                            IncrementRemainingFeatUses(oPC, FEAT_PRESTIGE_SHIFTER_EGWSHAPE_1);
                        else
                            IncrementRemainingFeatUses(oPC, FEAT_PRESTIGE_SHIFTER_GWSHAPE_1);
                    }

                    // The convo should end now
                    AllowExit(DYNCONV_EXIT_FORCE_EXIT);
                }
                // Otherwise, move to nag at them about it
                else
                    nStage = STAGE_COULDNTSHIFT;
            }
        }
        else if(nStage == STAGE_COULDNTSHIFT)
        {
            // Clear the epicness variable and return to main menu
            DeleteLocalInt(oPC, EPICVAR);

            nStage = STAGE_ENTRY;
        }
        else if(nStage == STAGE_LISTQUICKSHIFTS)
        {
            // Return to main menu?
            if(nChoice == CHOICE_BACK_TO_MAIN)
                nStage = STAGE_ENTRY;
            // Something slot chosen to be modified
            else
            {
                // Store the number of the slot to be modified
                SetLocalInt(oPC, QSMODIFYVAR, nChoice);
                // If the character is an epic shifter, they can select whether the quickselection is normal or epic shift
                if(GetLevelByClass(CLASS_TYPE_PNP_SHIFTER, oPC) > 10)
                    nStage = STAGE_SELECTQUICKSHIFTTYPE;
                else
                {
                    nStage = STAGE_CHANGESHAPE_FILTER;
                    SetLocalInt(oPC, SHAPEFILTERNEXTSTAGEVAR, STAGE_SELECTQUICKSHIFTSHAPE);
                }
            }
        }
        else if(nStage == STAGE_SELECTQUICKSHIFTTYPE)
        {
            // Set the marker variable if they chose epic
            if(nChoice == CHOICE_EPIC)
                SetLocalInt(oPC, EPICVAR, TRUE);

            nStage = STAGE_CHANGESHAPE_FILTER;
            SetLocalInt(oPC, SHAPEFILTERNEXTSTAGEVAR, STAGE_SELECTQUICKSHIFTSHAPE);
        }
        else if(nStage == STAGE_SELECTQUICKSHIFTSHAPE)
        {
            // Return to main menu?
            if(nChoice == CHOICE_BACK_TO_MAIN)
                nStage = STAGE_ENTRY;
            else if(nChoice == CHOICE_NORMAL_SHAPE_ORDER)
                SetLocalInt(oPC, SHAPEREVERSEORDERVAR, 0);
            else if (nChoice == CHOICE_REVERSE_SHAPE_ORDER)
                SetLocalInt(oPC, SHAPEREVERSEORDERVAR, 1);
            else
            {
                // Store the chosen template into the quickslot, choice is the template's index in the main list
                int nSlot = GetLocalInt(oPC, QSMODIFYVAR);
                int bEpic = GetLocalInt(oPC, EPICVAR);
                SetPersistantLocalString(oPC, "PRC_Shifter_Quick_" + IntToString(nSlot) + "_ResRef",
                                         GetStoredTemplate(oPC, SHIFTER_TYPE_SHIFTER, nChoice)
                                         );
                SetPersistantLocalString(oPC, "PRC_Shifter_Quick_" + IntToString(nSlot) + "_Name",
                                         GetStoredTemplateName(oPC, SHIFTER_TYPE_SHIFTER, nChoice)
                                       + (bEpic ? " (epic)" : "")
                                         );
                SetPersistantLocalInt(oPC, "PRC_Shifter_Quick_" + IntToString(nSlot) + "_Epic", bEpic);

                // Clean up
                DeleteLocalInt(oPC, EPICVAR);
                DeleteLocalInt(oPC, QSMODIFYVAR);

                // Return to main menu
                nStage = STAGE_ENTRY;
            }
        }
        else if(nStage == STAGE_PRINTSHAPE)
        {
            if(nChoice == CHOICE_BACK_TO_MAIN)
                nStage = STAGE_ENTRY;
            else if(nChoice == CHOICE_NORMAL_SHAPE_ORDER)
                SetLocalInt(oPC, SHAPEREVERSEORDERVAR, 0);
            else if (nChoice == CHOICE_REVERSE_SHAPE_ORDER)
                SetLocalInt(oPC, SHAPEREVERSEORDERVAR, 1);
            else
            {
                string sResRef = GetStoredTemplate(oPC, SHIFTER_TYPE_SHIFTER, nChoice);
                object oTemplate = _prc_inc_load_template_from_resref(sResRef, 0);
                DelayCommand(0.0, _prc_inc_PrintShape(oPC, oTemplate, TRUE));
                DelayCommand(1.0, MyDestroyObject(oTemplate));
                nStage = STAGE_PRINTSHAPE;
            }
        }
        else if(nStage == STAGE_DELETESHAPE)
        {
            if(nChoice == CHOICE_BACK_TO_MAIN)
                nStage = STAGE_ENTRY;
            else if(nChoice == CHOICE_NORMAL_SHAPE_ORDER)
                SetLocalInt(oPC, SHAPEREVERSEORDERVAR, 0);
            else if (nChoice == CHOICE_REVERSE_SHAPE_ORDER)
                SetLocalInt(oPC, SHAPEREVERSEORDERVAR, 1);
            else
            {                
                SetStoredTemplateDeleteMark(oPC, SHIFTER_TYPE_SHIFTER, nChoice, !GetStoredTemplateDeleteMark(oPC, SHIFTER_TYPE_SHIFTER, nChoice));
                nStage = STAGE_DELETESHAPE;
            }
        }
        else if(nStage == STAGE_SETTINGS)
        {
            // Return to main menu?
            if(nChoice == CHOICE_BACK_TO_MAIN)
                nStage = STAGE_ENTRY;
            // Toggle using Druid Wildshape for Greater Wildshape
            else if(nChoice == CHOICE_DRUIDWS)
            {
                SetPersistantLocalInt(oPC, "PRC_Shifter_UseDruidWS", !GetPersistantLocalInt(oPC, "PRC_Shifter_UseDruidWS"));
                nStage = STAGE_ENTRY;
            }
            else if(nChoice == CHOICE_STORE_TRUEAPPEARANCE)
            {
                // Probably should give feedback about whether this was successful or not. Though the warning in the selection text could be enough
                StoreCurrentAppearanceAsTrueAppearance(oPC, TRUE);
                nStage = STAGE_ENTRY;
            }
            else if (nChoice == CHOICE_UPDATE_RACIAL_TYPES)
            {
                UpdateStoredTemplateInfo(oPC, SHIFTER_TYPE_SHIFTER);
                nStage = STAGE_ENTRY;
            }
            else if (nChoice == CHOICE_DELETE_MARKED_SHAPES)
            {
                DeleteMarkedStoredTemplates(oPC, SHIFTER_TYPE_SHIFTER);
                nStage = STAGE_ENTRY;
            }
        }
        else if(nStage == STAGE_CHOOSE_NEW_SHAPE_PACKAGE)
        {
            DeleteLocalString(oPC, SHAPE_PACKAGE_USE_COUNT);

            int nShifterLevel = GetLevelByClass(CLASS_TYPE_PNP_SHIFTER, oPC);
            int nShifterLevelToLearn = GetPersistantLocalInt(oPC, SHIFTER_SHAPE_LEARNED_LEVEL) + 1;
            int nCharacterLevel = persistant_array_get_int(oPC, SHIFTER_LEVELLING_ARRAY, nShifterLevelToLearn-1);
            int bPrintMode = GetLocalInt(oPC, PRINT_MODE);

            if(nChoice == CHOICE_BACK_TO_MAIN)
                nStage = STAGE_ENTRY;
            else if(nChoice == CHOICE_SHAPE_PACKAGE_HELP)
                nStage = STAGE_SHAPE_PACKAGE_HELP;
            else if (nChoice == CHOICE_SKIP_LEVEL)
            {
                SetPersistantLocalInt(oPC, SHIFTER_SHAPE_LEARNED_LEVEL, nShifterLevelToLearn);
                nStage = STAGE_ENTRY;
            }
            else if(nChoice == CHOICE_USE_GENERAL_PACKAGE)
            {
                string sGeneralPackage2da = GetPersistantLocalString(oPC, SHIFTER_GENERAL_PACKAGE_2DA);
                SetLocalString(oPC, SHAPE_PACKAGE_2DA, sGeneralPackage2da);
                nStage = STAGE_CHOOSE_NEW_SHAPE;
            }
            else if(nChoice == CHOICE_USE_MAJOR_FOCUS_PACKAGE)
            {
                string sFocusPackage2da = GetPersistantLocalString(oPC, SHIFTER_MAJOR_FOCUS_PACKAGE_2DA);
                SetLocalString(oPC, SHAPE_PACKAGE_2DA, sFocusPackage2da);
                if(nShifterLevelToLearn >= 21)
                    SetLocalString(oPC, SHAPE_PACKAGE_USE_COUNT, SHIFTER_MAJOR_FOCUS_PACKAGE_USE_COUNT_2);
                else
                    SetLocalString(oPC, SHAPE_PACKAGE_USE_COUNT, SHIFTER_MAJOR_FOCUS_PACKAGE_USE_COUNT_1);
                nStage = STAGE_CHOOSE_NEW_SHAPE;
            }
            else if(nChoice == CHOICE_USE_MINOR_FOCUS_PACKAGE)
            {
                string sFocusPackage2da = GetPersistantLocalString(oPC, SHIFTER_MINOR_FOCUS_PACKAGE_2DA);
                SetLocalString(oPC, SHAPE_PACKAGE_2DA, sFocusPackage2da);
                if(nShifterLevelToLearn >= 21)
                    SetLocalString(oPC, SHAPE_PACKAGE_USE_COUNT, SHIFTER_MINOR_FOCUS_PACKAGE_USE_COUNT_2);
                else
                    SetLocalString(oPC, SHAPE_PACKAGE_USE_COUNT, SHIFTER_MINOR_FOCUS_PACKAGE_USE_COUNT_1);
                nStage = STAGE_CHOOSE_NEW_SHAPE;
            }
            else
            {
                string sPackageName = GetStringByStrRef(StringToInt(Get2DACache(SHIFTER_SHAPE_PACKAGE_LIST_2DA, "Name", nChoice)));
                string sPackage2da = Get2DACache(SHIFTER_SHAPE_PACKAGE_LIST_2DA, "Package2da", nChoice);
                if (bPrintMode)
                {
                    SetLocalString(oPC, SHAPE_PACKAGE_2DA, sPackage2da);
                    nStage = STAGE_CHOOSE_NEW_SHAPE;
                }
                else if(GetPersistantLocalString(oPC, SHIFTER_GENERAL_PACKAGE_2DA) == "")
                {
                    SetPersistantLocalString(oPC, SHIFTER_GENERAL_PACKAGE_2DA, sPackage2da);
                    SetPersistantLocalString(oPC, SHIFTER_GENERAL_PACKAGE_NAME, sPackageName);
                    nStage = STAGE_CHOOSE_NEW_SHAPE_PACKAGE;
                }
                else if(GetPersistantLocalString(oPC, SHIFTER_MAJOR_FOCUS_PACKAGE_2DA) == "" && nShifterLevelToLearn >= 11)
                {
                    SetPersistantLocalString(oPC, SHIFTER_MAJOR_FOCUS_PACKAGE_2DA, sPackage2da);
                    SetPersistantLocalString(oPC, SHIFTER_MAJOR_FOCUS_PACKAGE_NAME, sPackageName);
                    nStage = STAGE_CHOOSE_NEW_SHAPE_PACKAGE;
                }
                else if(GetPersistantLocalString(oPC, SHIFTER_MINOR_FOCUS_PACKAGE_2DA) == "" && nShifterLevelToLearn >= 11)
                {
                    SetPersistantLocalString(oPC, SHIFTER_MINOR_FOCUS_PACKAGE_2DA, sPackage2da);
                    SetPersistantLocalString(oPC, SHIFTER_MINOR_FOCUS_PACKAGE_NAME, sPackageName);
                    nStage = STAGE_CHOOSE_NEW_SHAPE_PACKAGE;
                }
                else if(nShifterLevelToLearn == 10)
                {
                    SetLocalString(oPC, SHAPE_PACKAGE_2DA, sPackage2da);
                    nStage = STAGE_CHOOSE_NEW_SHAPE;
                }
            }
        }
        else if(nStage == STAGE_CHOOSE_NEW_SHAPE)
        {
            int nShifterLevel = GetLevelByClass(CLASS_TYPE_PNP_SHIFTER, oPC);
            int nShifterLevelToLearn = GetPersistantLocalInt(oPC, SHIFTER_SHAPE_LEARNED_LEVEL) + 1;
            int nCharacterLevel = persistant_array_get_int(oPC, SHIFTER_LEVELLING_ARRAY, nShifterLevelToLearn-1);
            int bPrintMode = GetLocalInt(oPC, PRINT_MODE);

            if(nChoice == CHOICE_BACK_TO_MAIN)
                nStage = STAGE_ENTRY;
            else if(nChoice == CHOICE_NORMAL_SHAPE_ORDER)
                SetLocalInt(oPC, SHAPEREVERSEORDERVAR, 0);
            else if (nChoice == CHOICE_REVERSE_SHAPE_ORDER)
                SetLocalInt(oPC, SHAPEREVERSEORDERVAR, 1);
            else if (nChoice == CHOICE_SKIP_LEVEL)
            {
                SetPersistantLocalInt(oPC, SHIFTER_SHAPE_LEARNED_LEVEL, nShifterLevelToLearn);
                nStage = STAGE_ENTRY;
            }
            else
            {
                object oSpawnWP = GetWaypointByTag(SHIFTING_TEMPLATE_WP_TAG);
                if(!GetIsObjectValid(oSpawnWP))
                    oSpawnWP = CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", GetLocation(GetObjectByTag("HEARTOFCHAOS")), FALSE, SHIFTING_TEMPLATE_WP_TAG);
                location lSpawn  = GetLocation(oSpawnWP);

                string sPackage2da = GetLocalString(oPC, SHAPE_PACKAGE_2DA);
                string sResRef = Get2DACache(sPackage2da, "ResRef", nChoice);
                object oTemplate = CreateObject(OBJECT_TYPE_CREATURE, sResRef, lSpawn);
                
                if (bPrintMode)
                {
                    DelayCommand(0.0, _prc_inc_PrintShape(oPC, oTemplate, TRUE));
                    DelayCommand(1.0, MyDestroyObject(oTemplate));
                }
                else
                {
                    if(StoreShiftingTemplate(oPC, SHIFTER_TYPE_SHIFTER, oTemplate))
                    {
                        DestroyObject(oTemplate, 0.5f);

                        SetPersistantLocalInt(oPC, SHIFTER_SHAPE_LEARNED_LEVEL, nShifterLevelToLearn);

                        string sUseCountVariable = GetLocalString(oPC, SHAPE_PACKAGE_USE_COUNT);
                        int nUseCount = GetPersistantLocalInt(oPC, sUseCountVariable);
                        SetPersistantLocalInt(oPC, sUseCountVariable, nUseCount+1);

                        nStage = STAGE_ENTRY;
                    }
                }
            }
        }
        else if(nStage == STAGE_SHAPE_PACKAGE_HELP)
        {
            nStage = STAGE_ENTRY;
        }
        
        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
