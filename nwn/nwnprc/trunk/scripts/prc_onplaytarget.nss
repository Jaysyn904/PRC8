//::///////////////////////////////////////////////
//:: PRC Spellbook OnTrigger Event
//:: prc_onplaytarget
//:://////////////////////////////////////////////
#include "prc_inc_skills"
#include "prc_nui_consts"
#include "inc_dynconv"
#include "prc_inc_function"
#include "inv_inc_invfunc"
 
void DoJump(object oPC, location lTarget, int bDoKnockdown);
void DoSpellbookAction(object oPC, object oTarget, location lTarget);
void ClearEventVariables(object oPC);
 
void DoJump(object oPC, location lTarget, int bDoKnockdown)
{
    object oTarget;
    location lSource  = GetLocation(oPC);
    vector vSource    = GetPositionFromLocation(lSource);
    float fDistance   = GetDistanceBetweenLocations(lTarget, lSource);
    string sMessage   = "You cannot jump through a closed door.";
 
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCYLINDER, fDistance, lTarget, TRUE, OBJECT_TYPE_DOOR, vSource);
    while (oTarget != OBJECT_INVALID)
    {
        if (!GetIsOpen(oTarget))
        {
            FloatingTextStringOnCreature(sMessage, oPC, FALSE);
            DeleteLocalLocation(oPC, "TARGETING_POSITION");
            return;
        }
        oTarget = GetNextObjectInShape(SHAPE_SPELLCYLINDER, fDistance, lTarget, TRUE, OBJECT_TYPE_DOOR, vSource);
    }
 
    PerformJump(oPC, lTarget, TRUE);
    DeleteLocalLocation(oPC, "TARGETING_POSITION");
}
 
void DoSpellbookAction(object oPC, object oTarget, location lTarget)
{
    if (GetIsObjectValid(oTarget))
        SetLocalObject(oPC, "TARGETING_OBJECT", oTarget);
    else
        SetLocalLocation(oPC, "TARGETING_POSITION", lTarget);
 
    ExecuteScript("prc_nui_sb_trggr", oPC);
    ClearEventVariables(oPC);
}
 
void ClearEventVariables(object oPC)
{
    DeleteLocalObject(oPC, "TARGETING_OBJECT");
    DeleteLocalLocation(oPC, "TARGETING_POSITION");
    DeleteLocalString(oPC, "ONPLAYERTARGET_ACTION");
    DeleteLocalInt(oPC, NUI_SPELLBOOK_ON_TARGET_IS_PERSONAL_FEAT);
    DeleteLocalInt(oPC, NUI_SPELLBOOK_SELECTED_SPELLID_VAR);
    DeleteLocalInt(oPC, NUI_SPELLBOOK_SELECTED_FEATID_VAR);
    DeleteLocalInt(oPC, NUI_SPELLBOOK_SELECTED_SUBSPELL_SPELLID_VAR);
    DeleteLocalInt(oPC, NUI_SPELLBOOK_NATIVE_DOMAIN_PENDING_VAR);
    DeleteLocalInt(oPC, NUI_SPELLBOOK_NATIVE_DOMAIN_CLASS_VAR);
    DeleteLocalInt(oPC, NUI_SPELLBOOK_NATIVE_DOMAIN_LEVEL_VAR);
    DeleteLocalInt(oPC, NUI_SPELLBOOK_NATIVE_DOMAIN_INDEX_VAR);
    DeleteLocalInt(oPC, NUI_SPELLBOOK_NATIVE_DOMAIN_SPELL_VAR);
    DeleteLocalInt(oPC, NUI_SPELLBOOK_NATIVE_DOMAIN_METAMAGIC_VAR);
    DeleteLocalInt(oPC, NUI_SPELLBOOK_NATIVE_CLASS_PENDING_VAR);
    DeleteLocalInt(oPC, NUI_SPELLBOOK_NATIVE_CLASS_CAST_TYPE_VAR);
    DeleteLocalInt(oPC, NUI_SPELLBOOK_NATIVE_CLASS_CLASS_VAR);
    DeleteLocalInt(oPC, NUI_SPELLBOOK_NATIVE_CLASS_LEVEL_VAR);
    DeleteLocalInt(oPC, NUI_SPELLBOOK_NATIVE_CLASS_SPELL_VAR);
    DeleteLocalInt(oPC, NUI_SPELLBOOK_NATIVE_CLASS_METAMAGIC_VAR);
    DeleteLocalInt(oPC, NUI_SPELLBOOK_NATIVE_CLASS_DOMAIN_VAR);
}
 
void main()
{
    object oPC = GetLastPlayerToSelectTarget();
 
    string sAction     = GetLocalString(oPC, "ONPLAYERTARGET_ACTION");
    object oTarget     = GetTargetingModeSelectedObject();
    vector vTarget     = GetTargetingModeSelectedPosition();
    float fOrientation = GetFacing(oPC);
 
    if (!GetIsObjectValid(oTarget) && vTarget == Vector())
    {
        // A cancelled inline bonus-domain target must not influence a later
        // radial or character-wide domain cast.
        DeleteLocalInt(oPC, NUI_SPELLBOOK_DOMAIN_PREFERRED_CLASS_VAR);
        ClearEventVariables(oPC);
        return;
    }
 
    // When clicking ground, oTarget is the area object - use PC's area for location
    object oArea     = GetIsObjectValid(oTarget) ? GetArea(oTarget) : GetArea(oPC);
    location lTarget = Location(oArea, vTarget, fOrientation);
 
    SetLocalObject(oPC, "TARGETING_OBJECT", oTarget);
    SetLocalLocation(oPC, "TARGETING_POSITION", lTarget);
 
    if (sAction == "PRC_JUMP")
    {
        AssignCommand(oPC, SetFacingPoint(vTarget));
        DelayCommand(0.0f, DoJump(oPC, lTarget, TRUE));
    }
 
    if (sAction == "PRC_NUI_SPELLBOOK")
    {
        DoSpellbookAction(oPC, oTarget, lTarget);
    }
 
    if (sAction == "LW_LIMITED_WISH")
    {
        int nSpell        = GetLocalInt(oPC, "LW_PendingSpell");
        int nClass        = GetLocalInt(oPC, "LW_CastingClass");
        int bIsInvoc      = GetLocalInt(oPC, "LW_PendingIsInvoc");
        int nCasterLevel  = GetPrCAdjustedCasterLevel(nClass, oPC);
 
        WriteTimestampedLogEntry("prc_onplaytarget LW_LIMITED_WISH: nSpell=" + IntToString(nSpell) + " nClass=" + IntToString(nClass) + " nCasterLevel=" + IntToString(nCasterLevel) + " bIsInvoc=" + IntToString(bIsInvoc) + " oTarget=" + GetName(oTarget) + " oTarget type=" + IntToString(GetObjectType(oTarget)));
 
        DeleteLocalInt(oPC, "LW_PendingSpell");
        DeleteLocalInt(oPC, "LW_PendingIsInvoc");
        DeleteLocalString(oPC, "ONPLAYERTARGET_ACTION");
        DeleteLocalString(oPC, "LW_ClassColumn");
 
        // Clear any stale object override from previous casts
        DeleteLocalObject(oPC, PRC_SPELL_TARGET_OBJECT_OVERRIDE);
        DeleteLocalInt(oPC, PRC_SPELL_TARGET_OBJECT_OVERRIDE);
 
        if (bIsInvoc)
        {
            SetLocalInt(oPC, PRC_INVOKING_CLASS, CLASS_TYPE_WARLOCK + 1);
            DelayCommand(2.0f, DeleteLocalInt(oPC, PRC_INVOKING_CLASS));
        }
 
        // Ground click - oTarget is the area object, GetObjectType returns 0
        if (GetIsObjectValid(oTarget) && GetObjectType(oTarget))
        {
            SetLocalObject(oPC, PRC_SPELL_TARGET_OBJECT_OVERRIDE, oTarget);
            AssignCommand(oPC, ActionCastSpell(nSpell, nCasterLevel, 0, 0,
                METAMAGIC_NONE, nClass,
                FALSE, TRUE, oTarget));
        }
        else
        {
            location lGround = Location(GetArea(oPC), vTarget, GetFacing(oPC));
            SetLocalLocation(oPC, PRC_SPELL_TARGET_LOCATION_OVERRIDE, lGround);
            AssignCommand(oPC, ActionCastSpell(nSpell, nCasterLevel, 0, 0,
                METAMAGIC_NONE, nClass,
                TRUE, FALSE));
 
            DeleteLocalInt(oPC, "LW_CastingClass");
        }
    }
}
