/*:://////////////////////////////////////////////
//:: Name Local variables
//:: FileName SMP_INC_LOCALS
//:://////////////////////////////////////////////
    Functions for setting and getting local variables.

    Might well change or move these and so on as I get to work with the spell
    class settings item.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

// Constant prefix variable for use in:
// - SMP_GetLocalConstant(), SMP_SetLocalConstant()
const string SMP_CONSTANT = "PHSC_";
// Constant prefix variable for use in:
// - SMP_GetLocalSpellSetting(), SMP_SetLocalSpellSetting()
const string SMP_SETTING = "PHSS_";

// SMP_INC_LOCALS. Get oObject's local integer variable sVarName
// * Return value on error: -1
// This is similar to LocalInt, but takes one away as it is a constant value.
int SMP_GetLocalConstant(object oObject, string sVarName);
// SMP_INC_LOCALS. Set oObject's local integer variable sVarName
// This is similar to LocalInt, but adds one as it is a constant value.
// Return with SMP_GetLocalConstant().
void SMP_SetLocalConstant(object oObject, string sVarName, int nConstant);

// SMP_INC_LOCALS. Gets a local varaible set to nSpellId.
// - As set as SMP_SETTING + IntToString(nSpellId).
// - A local integer.
int SMP_GetLocalSpellSetting(object oObject, int nSpellId);
// SMP_INC_LOCALS. Sets a local varaible set to nSpellId.
// - As set as SMP_SETTING + IntToString(nSpellId).
// - A local integer.
void SMP_SetLocalSpellSetting(object oObject, int nSpellId, int nValue);

// SMP_INC_LOCALS. Get oObject's local integer variable sVarName
// * Return value on error: -1
// This is similar to LocalInt, but takes one away as it is a constant value.
int SMP_GetLocalConstant(object oObject, string sVarName)
{
    return GetLocalInt(oObject, SMP_CONSTANT + sVarName) - 1;
}
// SMP_INC_LOCALS. Set oObject's local integer variable sVarName
// This is similar to LocalInt, but adds one as it is a constant value.
// Return with SMP_GetLocalConstant().
void SMP_SetLocalConstant(object oObject, string sVarName, int nConstant)
{
    SetLocalInt(oObject, SMP_CONSTANT + sVarName, nConstant + 1);
}
// SMP_INC_LOCALS. Gets a local varaible set to nSpellId.
// - As set as SMP_SETTING + IntToString(nSpellId).
// - A local integer.
int SMP_GetLocalSpellSetting(object oObject, int nSpellId)
{
    return GetLocalInt(oObject, SMP_SETTING + IntToString(nSpellId));
}
// SMP_INC_LOCALS. Sets a local varaible set to nSpellId.
// - As set as SMP_SETTING + IntToString(nSpellId).
// - A local integer.
void SMP_SetLocalSpellSetting(object oObject, int nSpellId, int nValue)
{
    SetLocalInt(oObject, SMP_SETTING + IntToString(nSpellId), nValue);
}

// End of file Debug lines. Uncomment below "/*" with "//" and compile.
/*
void main()
{
    return;
}
//*/
