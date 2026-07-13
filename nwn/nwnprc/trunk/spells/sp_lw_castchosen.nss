//;:
//:: sp_lw_castchosen
//::
#include "inc_cache_setup"
#include "prc_inc_function"
#include "inc_dynconv"
 
int GetClassTypeFromColumn(string sColumn)
{
    if (sColumn == "Wiz_Sorc") return CLASS_TYPE_WIZARD;
    if (sColumn == "Bard")     return CLASS_TYPE_BARD;
    if (sColumn == "Cleric")   return CLASS_TYPE_CLERIC;
    if (sColumn == "Druid")    return CLASS_TYPE_DRUID;
    if (sColumn == "Paladin")  return CLASS_TYPE_PALADIN;
    if (sColumn == "Ranger")   return CLASS_TYPE_RANGER;
    return CLASS_TYPE_INVALID;
}
 
void main()
{
    object oPC      = GetLocalObject(GetModule(), "LW_CastingPC");
    int    bIsInvoc = GetLocalInt(oPC, "LW_IsInvocation");
    int    nSpell   = bIsInvoc ? GetLocalInt(oPC, "LW_ChosenSpell")
                               : GetLocalInt(oPC, "LW_ChosenSpell") - 1;
 
    WriteTimestampedLogEntry("sp_lw_castchosen: main fired. oPC valid=" + IntToString(GetIsObjectValid(oPC)) + " nSpell=" + IntToString(nSpell) + " bIsInvoc=" + IntToString(bIsInvoc));
 
    DeleteLocalObject(GetModule(), "LW_CastingPC");
 
    if (!GetIsObjectValid(oPC) || nSpell < 0) return;
 
    string sRange = Get2DACache("spells", "Range", nSpell);
 
    WriteTimestampedLogEntry("sp_lw_castchosen: sRange=" + sRange + " LW_ClassColumn=" + GetLocalString(oPC, "LW_ClassColumn"));
 
    // Personal range — store spell details and delay cast until conversation fully closes
    if (sRange == "P")
    {
        SetLocalInt(oPC, "LW_DelayedCastSpell", nSpell);
        SetLocalInt(oPC, "LW_DelayedIsInvoc",   bIsInvoc);
        DelayCommand(0.1f, ExecuteScript("sp_lw_delaycst", oPC));
        SetXP(oPC, GetXP(oPC) - 300);
        AllowExit(DYNCONV_EXIT_FORCE_EXIT, FALSE, oPC);
    }
    else
    {
        WriteTimestampedLogEntry("sp_lw_castchosen: nObjectTypes=" + IntToString(OBJECT_TYPE_ALL));
 
        SetLocalInt(oPC, "LW_PendingSpell",   nSpell);
        SetLocalInt(oPC, "LW_PendingIsInvoc", bIsInvoc);
        SetLocalString(oPC, "ONPLAYERTARGET_ACTION", "LW_LIMITED_WISH");
 
        // Exit conversation before entering targeting mode
        SetXP(oPC, GetXP(oPC) - 300);
        AllowExit(DYNCONV_EXIT_FORCE_EXIT, FALSE, oPC);
        EnterTargetingMode(oPC, OBJECT_TYPE_ALL, MOUSECURSOR_MAGIC);
    }
 
    // Clean up wish variables
    DeleteLocalInt(oPC, "LW_ChosenSpell");
    DeleteLocalInt(oPC, "LW_WishType");
    DeleteLocalInt(oPC, "LW_InvMaxGrade");
    DeleteLocalInt(oPC, "LW_IsInvocation");
}