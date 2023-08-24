// Written by Stratovarius
// Turns Battlecast on and off for the Havoc Mage.

#include "prc_spell_const"
#include "prc_ipfeat_const"
#include "prc_alterations"

void main()
{

    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    string nMes = "";

    if(!GetLocalInt(oPC, "HavocMageBattlecast"))
    {
        SetLocalInt(oPC, "HavocMageBattlecast", TRUE);
        //AddItemProperty(DURATION_TYPE_PERMANENT, PRCItemPropertyBonusFeat(IP_CONST_IMP_CC), oSkin);
        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_IMP_CC), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        nMes = "*Battlecast Activated*";
    }
    else
    {
        // Removes effects
        PRCRemoveSpellEffects(SPELL_BATTLECAST, oPC, oPC);
        DeleteLocalInt(oPC, "HavocMageBattlecast");
        nMes = "*Battlecast Deactivated*";
        RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT, IP_CONST_IMP_CC);
    }

    FloatingTextStringOnCreature(nMes, oPC, FALSE);
}