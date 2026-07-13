//;:
//:: sp_lw_delaycst
//:: Fires a personal spell after the Limited Wish conversation has fully closed
//::
#include "prc_inc_function"
#include "inv_inc_invfunc"
 
void main()
{
    object oPC          = OBJECT_SELF;
    int    nSpell       = GetLocalInt(oPC, "LW_DelayedCastSpell");
    int    nClass       = GetLocalInt(oPC, "LW_CastingClass");
    int    bIsInvoc     = GetLocalInt(oPC, "LW_DelayedIsInvoc");
    int    nCasterLevel = GetPrCAdjustedCasterLevel(nClass, oPC);
 
    WriteTimestampedLogEntry("sp_lw_delaycst: nSpell=" + IntToString(nSpell) + " nClass=" + IntToString(nClass) + " nCasterLevel=" + IntToString(nCasterLevel) + " bIsInvoc=" + IntToString(bIsInvoc));
 
    DeleteLocalInt(oPC, "LW_DelayedCastSpell");
    DeleteLocalInt(oPC, "LW_DelayedIsInvoc");
    DeleteLocalString(oPC, "LW_ClassColumn");
 
    if (nSpell < 0) return;
 
    if (bIsInvoc)
    {
        SetLocalInt(oPC, PRC_INVOKING_CLASS, CLASS_TYPE_WARLOCK + 1);
        DelayCommand(2.0f, DeleteLocalInt(oPC, PRC_INVOKING_CLASS));
    }
 
    // Use caster's location so GetSpellTargetLocation() resolves correctly in spell scripts
    location lCaster = GetLocation(oPC);
    SetLocalLocation(oPC, PRC_SPELL_TARGET_LOCATION_OVERRIDE, lCaster);
    DeleteLocalObject(oPC, PRC_SPELL_TARGET_OBJECT_OVERRIDE);
    DeleteLocalInt(oPC, PRC_SPELL_TARGET_OBJECT_OVERRIDE);
    AssignCommand(oPC, ActionCastSpell(nSpell, nCasterLevel, 0, 0,
        METAMAGIC_NONE, nClass,
        TRUE, FALSE));
}