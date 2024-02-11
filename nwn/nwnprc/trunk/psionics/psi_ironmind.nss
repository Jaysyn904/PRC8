//::///////////////////////////////////////////////
//:: Ironmind
//:: psi_ironmind.nss
//:://////////////////////////////////////////////
//:: Applies the passive bonuses from Ironmind
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: Dec 15, 2005
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
    object oPC = OBJECT_SELF;
    int nIron = GetLevelByClass(CLASS_TYPE_IRONMIND, oPC);

    if(nIron >= 2)
    {
        object oSkin = GetPCSkin(oPC);

        if(GetLocalInt(oSkin, "IronMind_DR"))
            return;

        int nDR = nIron > 8 ? IP_CONST_DAMAGERESIST_3:
                  nIron > 5 ? IP_CONST_DAMAGERESIST_2:
                  IP_CONST_DAMAGERESIST_1;

        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_PIERCING, nDR), oSkin);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_SLASHING, nDR), oSkin);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_BLUDGEONING, nDR), oSkin);
        SetLocalInt(oSkin, "IronMind_DR", TRUE);
    }
}