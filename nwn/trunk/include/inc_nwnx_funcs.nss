////////////////////////////////////////////////////////////////////////////////////
/*             Combined wrappers for both Win32 and Linux NWNX funcs              */
////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////
/*             Function prototypes              */
//////////////////////////////////////////////////

// Used in OnModuleLoad event to auto-detect if NWNX_Funcs plugin is enabled
void PRC_Funcs_Init(object oModule);

// Sets the amount of hitpoints oObject has currently to nHP
void PRC_Funcs_SetCurrentHitPoints(object oCreature, int nHP);

// Sets the amount of hitpoints oObject can maximally have to nHP
void PRC_Funcs_SetMaxHitPoints(object oCreature, int nHP);

// Changes the skill ranks for nSkill on oObject by iValue
void PRC_Funcs_ModSkill(object oCreature, int nSkill, int nValue);

// Sets a base ability score nAbility (ABILITY_STRENGTH, ABILITY_DEXTERITY, etc) to nValue
// The range of nValue is 3 to 255
void PRC_Funcs_SetAbilityScore(object oCreature, int nAbility, int nValue);

// Changes a base ability score nAbility (ABILITY_STRENGTH, ABILITY_DEXTERITY, etc) by nValue
void PRC_Funcs_ModAbilityScore(object oCreature, int nAbility, int nValue);

// Adds a feat to oObject's general featlist
// If nLevel is greater than 0 the feat is also added to the featlist for that level
void PRC_Funcs_AddFeat(object oCreature, int nFeat, int nLevel=0);

// Checks if oCreature inherently knows a feat (as opposed to a feat given from an equipped item)
// Returns FALSE if oCreature does not know the feat, TRUE if the feat is known
// The return value (if greater than 0) also denotes the position of the feat in the general feat list offset by +1
int  PRC_Funcs_GetFeatKnown(object oCreature, int nFeat);

// Changes the saving throw bonus nSavingThrow of oObject by nValue;
void PRC_Funcs_ModSavingThrowBonus(object oCreature, int nSavingThrow, int nValue);

// Sets the base natural AC
void PRC_Funcs_SetBaseNaturalAC(object oCreature, int nValue);

// Returns the base natural AC
int PRC_Funcs_GetBaseNaturalAC(object oCreature);

// Sets the specialist spell school of a Wizard
void PRC_Funcs_SetWizardSpecialization(object oCreature, int iSpecialization);

// Returns the specialist spell school of a Wizard
int PRC_Funcs_GetWizardSpecialization(object oCreature);

//////////////////////////////////////////////////
/*             Function definitions             */
//////////////////////////////////////////////////

int _PRC_NWNXFuncsZero(object oObject, string sFunc) {
    int nVersion = GetLocalInt(GetModule(), "PRC_NWNX_FUNCS");
    if (nVersion == 1)
        SetLocalString(oObject, sFunc, "-");
    else if (nVersion == 2)
        SetLocalString(oObject, sFunc, "          ");
    int nResult = StringToInt(GetLocalString(oObject, sFunc));
    DeleteLocalString(oObject, sFunc);
    return nResult;
}

int _PRC_NWNXFuncsOne(object oObject, string sFunc, int nVal1) {
    int nVersion = GetLocalInt(GetModule(), "PRC_NWNX_FUNCS");
    if (nVersion == 1)
        SetLocalString(oObject, sFunc, IntToString(nVal1));
    else if (nVersion == 2)
        SetLocalString(oObject, sFunc, IntToString(nVal1) + "          ");
    int nResult = StringToInt(GetLocalString(oObject, sFunc));
    DeleteLocalString(oObject, sFunc);
    return nResult;
}

int _PRC_NWNXFuncsTwo(object oObject, string sFunc, int nVal1, int nVal2) {
    int nVersion = GetLocalInt(GetModule(), "PRC_NWNX_FUNCS");
    if (nVersion == 1)
        SetLocalString(oObject, sFunc, IntToString(nVal1) + " " + IntToString(nVal2));
    else if (nVersion == 2)
        SetLocalString(oObject, sFunc, IntToString(nVal1) + " " + IntToString(nVal2) + "          ");
    int nResult = StringToInt(GetLocalString(oObject, sFunc));
    DeleteLocalString(oObject, sFunc);
    return nResult;
}

int _PRC_NWNXFuncsThree(object oObject, string sFunc, int nVal1, int nVal2, int nVal3) {
    int nVersion = GetLocalInt(GetModule(), "PRC_NWNX_FUNCS");
    if (nVersion == 1)
        SetLocalString(oObject, sFunc, IntToString(nVal1) + " " + IntToString(nVal2) + " " + IntToString(nVal3));
    else if (nVersion == 2)
        SetLocalString(oObject, sFunc, IntToString(nVal1) + " " + IntToString(nVal2) + " " + IntToString(nVal3) + "          ");
    int nResult = StringToInt(GetLocalString(oObject, sFunc));
    DeleteLocalString(oObject, sFunc);
    return nResult;
}

int _PRC_NWNXFuncsFour(object oObject, string sFunc, int nVal1, int nVal2, int nVal3, int nVal4) {
    int nVersion = GetLocalInt(GetModule(), "PRC_NWNX_FUNCS");
    if (nVersion == 1)
        SetLocalString(oObject, sFunc, IntToString(nVal1) + " " + IntToString(nVal2) + " " + IntToString(nVal3) + " " + IntToString(nVal4));
    else if (nVersion == 2)
        SetLocalString(oObject, sFunc, IntToString(nVal1) + " " + IntToString(nVal2) + " " + IntToString(nVal3) + " " + IntToString(nVal4) + "          ");
    int nResult = StringToInt(GetLocalString(oObject, sFunc));
    DeleteLocalString(oObject, sFunc);
    return nResult;
}

void PRC_Funcs_Init(object oModule)
{
    //Only NWNX for Win32 implements GetHasLocalVariable, so if this succeeds, that's what we're using
    string sTestVariable = "PRC_TEST_NWNX_FUNCS";
    SetLocalString(oModule, sTestVariable, "1");
    SetLocalString(oModule, "NWNX!FUNCS!GETHASLOCALVARIABLE", sTestVariable + " 3"); //3 is the variable type
        //NOTE: don't use _PRC_NWNXFuncsX functions here; they depend on the PRC_NWNX_FUNCS that we haven't set yet
    int iTest = StringToInt(GetLocalString(oModule, "NWNX!FUNCS!GETHASLOCALVARIABLE"));
    DeleteLocalString(oModule, "NWNX!FUNCS!GETHASLOCALVARIABLE");
    DeleteLocalString(oModule, sTestVariable);

    if (iTest)
        SetLocalInt(oModule, "PRC_NWNX_FUNCS", 1); //1 == win32
    else
    {
        //NWNX GetLocalVariableCount behaves differently for win32 and linux, 
        //but we know we're not using the win32 version (because the above check failed),
        //so try the linux version of GetLocalVariableCount.
        //Since PRC_VERSION is a module-level variable, and we know it's defined
        //by OnLoad before it calls this function, the variable count will be at
        //least 1 if we're using NWNX. If not, 0 will be returned to indicate that
        //the call failed because NWNX funcs is not present.
        string sFunc = "NWNX!FUNCS!GETLOCALVARIABLECOUNT";
        SetLocalString(oModule, sFunc, "          ");
            //NOTE: don't use _PRC_NWNXFuncsX functions here; they depend on the PRC_NWNX_FUNCS that we haven't set yet
            //NOTE: the number being returned by GetLocalVariableCount() on Linux seems bogus to me (it's huge, e.g. 294,654,504),
                //but it does seem to be reliably zero when NWNX funcs is not present, and so far has been reliably non-zero
                //when it is present. That's all we need here.
                //Info: on win32, GetLocalVariableCount() is returning much more reasonable numbers (e.g. 1707).
        int nVariables = StringToInt(GetLocalString(oModule, sFunc));
        DeleteLocalString(oModule, sFunc);
        if (nVariables)
            SetLocalInt(oModule, "PRC_NWNX_FUNCS", 2); //2 == linux
    }
}

void PRC_Funcs_SetMaxHitPoints(object oCreature, int nHP)
{
    int nVersion = GetLocalInt(GetModule(), "PRC_NWNX_FUNCS");
    if (nVersion == 1 || nVersion == 2)
    {
        _PRC_NWNXFuncsOne(oCreature, "NWNX!FUNCS!SETMAXHITPOINTS", nHP);
        DeleteLocalString(oCreature, "NWNX!FUNCS!SETMAXHITPOINTS");
    }
}

void PRC_Funcs_ModSkill(object oCreature, int nSkill, int nValue)
{
    int nVersion = GetLocalInt(GetModule(), "PRC_NWNX_FUNCS");
    if (nVersion == 1)
        _PRC_NWNXFuncsThree(oCreature, "NWNX!FUNCS!SETSKILL", nSkill, nValue, 1); //The 1 is a flag specifying modify instead of set
    else if (nVersion == 2)
        _PRC_NWNXFuncsTwo(oCreature, "NWNX!FUNCS!MODIFYSKILLRANK", nSkill, nValue);
}

void PRC_Funcs_SetAbilityScore(object oCreature, int nAbility, int nValue)
{
    int nVersion = GetLocalInt(GetModule(), "PRC_NWNX_FUNCS");
    if (nVersion == 1)
        _PRC_NWNXFuncsFour(oCreature, "NWNX!FUNCS!SETABILITYSCORE", nAbility, nValue, 0, 0); //The first 0 is a flag specifying set instead of modify
    else if (nVersion == 2)
        _PRC_NWNXFuncsTwo(oCreature, "NWNX!FUNCS!SETABILITYSCORE", nAbility, nValue);
}

void PRC_Funcs_ModAbilityScore(object oCreature, int nAbility, int nValue)
{
    int nVersion = GetLocalInt(GetModule(), "PRC_NWNX_FUNCS");
    if (nVersion == 1)
        _PRC_NWNXFuncsFour(oCreature, "NWNX!FUNCS!SETABILITYSCORE", nAbility, nValue, 1, 0); //The 1 is a flag specifying modify instead of set
    else if (nVersion == 2)
        _PRC_NWNXFuncsTwo(oCreature, "NWNX!FUNCS!MODIFYABILITYSCORE", nAbility, nValue);
}

void PRC_Funcs_AddFeat(object oCreature, int nFeat, int nLevel=0)
{
    int nVersion = GetLocalInt(GetModule(), "PRC_NWNX_FUNCS");
    if (nVersion == 1)
    {
        if (!nLevel)
            _PRC_NWNXFuncsOne(oCreature, "NWNX!FUNCS!ADDFEAT", nFeat);
        else if(nLevel > 0)
            _PRC_NWNXFuncsTwo(oCreature, "NWNX!FUNCS!ADDFEATATLEVEL", nLevel, nFeat);
    }
    else if (nVersion == 2)
    {
        if (!nLevel)
            _PRC_NWNXFuncsOne(oCreature, "NWNX!FUNCS!ADDKNOWNFEAT", nFeat);
        else if(nLevel > 0)
            _PRC_NWNXFuncsTwo(oCreature, "NWNX!FUNCS!ADDKNOWNFEATATLEVEL", nLevel, nFeat);
    }
}

int PRC_Funcs_GetFeatKnown(object oCreature, int nFeatIndex)
{
    int nVersion = GetLocalInt(GetModule(), "PRC_NWNX_FUNCS");
    if (nVersion == 1)
        return _PRC_NWNXFuncsOne(oCreature, "NWNX!FUNCS!GETFEATKNOWN", nFeatIndex);
    else if (nVersion == 2)
        return _PRC_NWNXFuncsOne(oCreature, "NWNX!FUNCS!GETKNOWNFEAT", nFeatIndex);
    return 0;
}

void PRC_Funcs_ModSavingThrowBonus(object oCreature, int nSavingThrow, int nValue)
{
    int nVersion = GetLocalInt(GetModule(), "PRC_NWNX_FUNCS");
    if (nVersion == 1)
        _PRC_NWNXFuncsThree(oCreature, "NWNX!FUNCS!SETSAVINGTHROWBONUS", nSavingThrow, nValue, 1); //The 1 is a flag specifying modify instead of set
    else if (nVersion == 2)
    {
        int nNewValue = _PRC_NWNXFuncsOne(oCreature, "NWNX!FUNCS!GETSAVINGTHROWBONUS", nSavingThrow) + nValue;
        if (nNewValue < 0)
            nNewValue = 0;
        else if (nNewValue > 127)
            nNewValue = 127;
        _PRC_NWNXFuncsTwo(oCreature, "NWNX!FUNCS!SETSAVINGTHROWBONUS", nSavingThrow, nNewValue);
    }
}

void PRC_Funcs_SetBaseNaturalAC(object oCreature, int nValue)
{
    int nVersion = GetLocalInt(GetModule(), "PRC_NWNX_FUNCS");
    if (nVersion == 1)
        _PRC_NWNXFuncsTwo(oCreature, "NWNX!FUNCS!SETBASEAC", nValue, AC_NATURAL_BONUS);
    else if (nVersion == 2)
        _PRC_NWNXFuncsOne(oCreature, "NWNX!FUNCS!SETACNATURALBASE", nValue);
}

int PRC_Funcs_GetBaseNaturalAC(object oCreature)
{
    int nVersion = GetLocalInt(GetModule(), "PRC_NWNX_FUNCS");
    if (nVersion == 1)
        return _PRC_NWNXFuncsOne(oCreature, "NWNX!FUNCS!GETBASEAC", AC_NATURAL_BONUS);
    else if (nVersion == 2)
        return _PRC_NWNXFuncsZero(oCreature, "NWNX!FUNCS!GETACNATURALBASE");
    return 0;
}

void PRC_Funcs_SetCurrentHitPoints(object oCreature, int nHP) 
{
    int nVersion = GetLocalInt(GetModule(), "PRC_NWNX_FUNCS");
    if (nVersion == 1 || nVersion == 2)
        _PRC_NWNXFuncsOne(oCreature, "NWNX!FUNCS!SETCURRENTHITPOINTS", nHP);
}

void PRC_Funcs_SetCreatureSize (object oCreature, int nSize) 
{
    int nVersion = GetLocalInt(GetModule(), "PRC_NWNX_FUNCS");
    if (nVersion == 1 || nVersion == 2)
        _PRC_NWNXFuncsOne(oCreature, "NWNX!FUNCS!SETCREATURESIZE", nSize);
}

void PRC_Funcs_SetRace(object oCreature, int nRace) 
{
    int nVersion = GetLocalInt(GetModule(), "PRC_NWNX_FUNCS");
    if (nVersion == 1)
        _PRC_NWNXFuncsOne(oCreature, "NWNX!FUNCS!SETRACE", nRace);
    else if (nVersion == 2)
        _PRC_NWNXFuncsOne(oCreature, "NWNX!FUNCS!SETRACIALTYPE", nRace);
}

void PRC_Funcs_SetWizardSpecialization(object oCreature, int iSpecialization)
{
    int nVersion = GetLocalInt(GetModule(), "PRC_NWNX_FUNCS");
    if (nVersion == 1 || nVersion == 2)
        _PRC_NWNXFuncsOne(oCreature, "NWNX!FUNCS!SETWIZARDSPECIALIZATION", iSpecialization);
}

int PRC_Funcs_GetWizardSpecialization(object oCreature)
{
    int nVersion = GetLocalInt(GetModule(), "PRC_NWNX_FUNCS");
    if (nVersion == 1 || nVersion == 2)
        return _PRC_NWNXFuncsZero(oCreature, "NWNX!FUNCS!GETWIZARDSPECIALIZATION");
    return 0;
}