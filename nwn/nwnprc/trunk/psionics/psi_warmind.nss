//::///////////////////////////////////////////////
//:: Warmind
//:: psi_warmind.nss
//:://////////////////////////////////////////////
//:: Applies the passive bonuses from Warmind
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: Dec 15, 2005
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "psi_inc_onhit"

void RemoveSweepingStrike(object oPC, object oWeap)
{
    if (DEBUG) FloatingTextStringOnCreature("Remove Sweeping Strike is run", oPC);

    RemoveSpecificProperty(oWeap,ITEM_PROPERTY_ONHITCASTSPELL,IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,0);
    DeleteLocalInt(oWeap, "SweepingStrike");
}

void AddSweepingStrike(object oPC, object oWeap)
{
    if(GetLocalInt(oWeap, "SweepingStrike"))
        return;

    //Sweeping Strike only works on melee weapons
    if(!IPGetIsMeleeWeapon(oWeap))
        return;

    if(DEBUG) FloatingTextStringOnCreature("Add Sweeping Strike is run", oPC);

    RemoveSweepingStrike(oPC, oWeap);
    DelayCommand(0.1, IPSafeAddItemProperty(oWeap, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 9999.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE));
    SetLocalInt(oWeap, "SweepingStrike", TRUE);
}

void EnduringBody(object oPC, object oSkin, int nLevel)
{
    if(GetLocalInt(oSkin, "EnduringBody"))
        return;

    int nDR = nLevel >= 9 ? IP_CONST_DAMAGERESIST_3:
              nLevel >= 6 ? IP_CONST_DAMAGERESIST_2:
              IP_CONST_DAMAGERESIST_1;

    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_PIERCING, nDR), oSkin);
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_SLASHING, nDR), oSkin);
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_BLUDGEONING, nDR), oSkin);
    SetLocalInt(oSkin, "EnduringBody", TRUE);
}

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nWar = GetLevelByClass(CLASS_TYPE_WARMIND, oPC);
    object oWeap = GetItemLastEquipped();
    object oUnequip = GetItemLastUnequipped();
    int iEquip = GetLocalInt(oPC, "ONEQUIP");

    if(nWar >= 3) EnduringBody(oPC, oSkin, nWar);
    if(nWar >= 5)
    {
        if(iEquip == 1) RemoveSweepingStrike(oPC, oUnequip);
        if(iEquip == 2) AddSweepingStrike(oPC, oWeap);
    }
}
