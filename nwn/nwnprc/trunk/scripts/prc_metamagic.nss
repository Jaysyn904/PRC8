//::///////////////////////////////////////////////
//:: Metamagic Feat Abilities
//:: prc_metamagic.nss
//:://////////////////////////////////////////////
//:: Grants new metamagic feat abilities for the new spell system.
//:://////////////////////////////////////////////
//:: Created By: N-S
//:: Created On: 20/09/2009
//:://////////////////////////////////////////////

#include "inc_newspellbook"

int GetHasSpontaneousNSBClass(object oPC)
{
    int i;
    for (i = 1; i <= 8; i++)
    {
        int nClass = GetClassByPosition(i, oPC);
        if (SPELLBOOK_TYPE_SPONTANEOUS == GetSpellbookTypeForClass(nClass))
                return TRUE;
    }
    return FALSE;
}

void main()
{
    object oPC = OBJECT_SELF;
    if(DEBUG) DoDebug("prc_metamagic running");

    if (!UseNewSpellBook(oPC))
    {
        if(DEBUG) DoDebug("prc_metamagic: New spellbook system disabled.");
        return;
    }
    if (!GetHasSpontaneousNSBClass(oPC))
    {
        if(DEBUG) DoDebug("prc_metamagic: No spontaneously casting classes.");
        return;
    }

    object oSkin = GetPCSkin(oPC);

    if (GetHasFeat(FEAT_EXTEND_SPELL, oPC))
        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_EXTEND_SPELL_ABILITY), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); 
    if (GetHasFeat(FEAT_SILENCE_SPELL, oPC))
        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_SILENT_SPELL_ABILITY), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); 
    if (GetHasFeat(FEAT_STILL_SPELL, oPC))
        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_STILL_SPELL_ABILITY), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); 
    if (GetHasFeat(FEAT_EMPOWER_SPELL, oPC))
        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_EMPOWER_SPELL_ABILITY), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); 
    if (GetHasFeat(FEAT_MAXIMIZE_SPELL, oPC))
        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_MAXIMIZE_SPELL_ABILITY), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); 
    if (GetHasFeat(FEAT_QUICKEN_SPELL, oPC))
        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_QUICKEN_SPELL_ABILITY), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); 
}
