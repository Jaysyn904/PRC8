//::///////////////////////////////////////////////
//:: Black Blood Cultist
//:: prc_bbc.nss
//::///////////////////////////////////////////////
/*
    Black Blood Cultist claws and damage reduction
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: Jul 18, 2019
//:://////////////////////////////////////////////

#include "prc_inc_natweap"

void main()
{

    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    int nLevel = GetLevelByClass(CLASS_TYPE_BLACK_BLOOD_CULTIST,oPC);

    if(nLevel >= 10)
    {
        string sResRef = "prc_raks_bite_";
        int nSize = PRCGetCreatureSize(oPC);
        sResRef += GetAffixForSize(nSize);
        AddNaturalSecondaryWeapon(oPC, sResRef);
        //primary weapon
        sResRef = "prc_claw_1d8m_";
        sResRef += GetAffixForSize(nSize);
        AddNaturalPrimaryWeapon(oPC, sResRef, 2); 
        IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC), ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1));
        IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC), ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1));
    }
    
    if (nLevel >= 9)
        IPSafeAddItemProperty(oSkin, ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_2, IP_CONST_DAMAGESOAK_5_HP), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    else if (nLevel >= 4)
        IPSafeAddItemProperty(oSkin, ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_2, IP_CONST_DAMAGESOAK_3_HP), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

}